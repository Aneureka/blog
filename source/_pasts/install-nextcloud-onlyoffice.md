---
title: 在 Ubuntu 16.04 安装 NextCloud 与 OnlyOffice
date: 2019-07-30 11:21:47
tags: Linux NextCloud OnlyOffice
---

由于一些奇奇怪怪的原因，有时候我们需要建立公司或团队内部的文件/在线文档共享平台。稍微看了一下，符合条件的收费产品有 Confluence、语雀等，但对小团队来说几块钱一年确实还是显得有些贵的… 所以打算用开源的软件搭建，这里采用了较为主流的 NextCloud + OnlyOffice 的方案。<!-- more -->



## 安装 NextCloud

NextCloud 的安装用 snap 的话几行命令就解决了，但**不推荐**，因为snap-nextcloud 并没有 OnlyOffice 等应用，相当于阉割版，对之后的拓展很不方便。这里以 Ubuntu 16.04 平台 和 NextCloud 15 为例，详细讲一下安装的过程。

#### 在 MySQL 中创建数据库

用 `mysql -u <user_name> -p` 进入到数据库中，执行以下命令：

```mysql
CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL ON nextcloud.* TO 'nextcloud'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;
```

这里 `nextcloud` 与 `password` 可以自定义，以上命令声明 nextcloud 将要使用的数据库。

#### 安装 PHP 与 Apache 相关依赖

在 Ubuntu 16.04 中，php 的版本是 7.0，可以替换成你服务器上的版本，执行 `apt cache search php` 就可以看到啦。

```shell
sudo apt install apache2 php7.0 php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring php7.0-intl php7.0-imagick php7.0-xml php7.0-zip libapache2-mod-php7.0
```

如果提示找不到相应的包，比如 `php7.0-imagick` ，可以用 `php-imagick` 代替。

#### 下载安装 NextCloud

```shell
wget https://download.nextcloud.com/server/releases/nextcloud-15.0.0.zip -P /tmp
sudo unzip /tmp/nextcloud-15.0.0.zip  -d /var/www
sudo chown -R www-data: /var/www/nextcloud
```

#### 配置 Apache

**注：如果想（跟我一样）通过 Nginx 代理可以跳过这一步**

```shell
sudo vim /etc/apache2/conf-available/nextcloud.conf
```

按 `i` 进入 vim 的编辑模式，把以下代码复制进去：

```xml
Alias /nextcloud "/var/www/nextcloud/"

<Directory /var/www/nextcloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/nextcloud
 SetEnv HTTP_HOME /var/www/nextcloud

</Directory>
```

这样的话最终访问路径是 http://domain_name_or_ip_address/nextcloud ，如果想要指定特定的端口，如 8001，可以用：

```xml
<VirtualHost *:8001>
  Alias /nextcloud "/var/www/nextcloud/"
  
  <Directory /var/www/nextcloud/>
    Options +FollowSymlinks
    AllowOverride All
  
   <IfModule mod_dav.c>
    Dav off
   </IfModule>
  
   SetEnv HOME /var/www/nextcloud
   SetEnv HTTP_HOME /var/www/nextcloud
  
  </Directory>
</VirtualHost>
```

（如果自定义访问路径，需要在 `/etc/apache2/ports.conf` 中添加 8001 端口，在 `Listen 80` 下面添加 `Listen 8001` 即可，同时可能需要防火墙开放特定端口，如 Ubuntu 下可以执行 `ufw allow 8001` ）

启用必需的 Apache 模块：

```shell
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime
```

重启 Apache 服务：

```shell
sudo service apache2 reload
```

然后就可以通过 `http://domain_name_or_ip_address[:port]/nextcloud` 访问到 NextCloud 啦。

#### 配置 Nginx

如果你想我一样对 Nginx 情有独钟，或者不想安装 Apache 的话，可以用 Nginx 来反向代理。

在 `/etc/nginx/sites-available` 中添加 NextCloud 的配置：

```shell
vim /etc/nginx/sites-available/nextcloud
```

把下面的配置代码*按你的具体情况修改后*复制进去：

```bash
upstream php-handler {
    server unix:/run/php/php7.0-fpm.sock;
}

server {
    listen 8002;
    listen [::]:8002;
    server_name <domain_name_or_ip_address>;

    # Add headers to serve security related headers
    # Before enabling Strict-Transport-Security headers please read into this
    # topic first.
    #add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;";
    #
    # WARNING: Only add the preload option once you read about
    # the consequences in https://hstspreload.org/. This option
    # will add the domain to a hardcoded list that is shipped
    # in all major browsers and getting removed from this list
    # could take several months.
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;
    add_header Referrer-Policy no-referrer;

    # Remove X-Powered-By, which is an information leak
    fastcgi_hide_header X-Powered-By;

    # Path to the root of your installation
    root /var/www/nextcloud;

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # The following 2 rules are only needed for the user_webfinger app.
    # Uncomment it if you're planning to use this app.
    #rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
    #rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

    # The following rule is only needed for the Social app.
    # Uncomment it if you're planning to use this app.
    #rewrite ^/.well-known/webfinger /public.php?service=webfinger last;

    location = /.well-known/carddav {
      return 301 $scheme://$host:$server_port/remote.php/dav;
    }
    location = /.well-known/caldav {
      return 301 $scheme://$host:$server_port/remote.php/dav;
    }

    # set max upload size
    client_max_body_size 512M;
    fastcgi_buffers 64 4K;

    # Enable gzip but do not remove ETag headers
    gzip on;
    gzip_vary on;
    gzip_comp_level 4;
    gzip_min_length 256;
    gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
    gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

    # Uncomment if your server is build with the ngx_pagespeed module
    # This module is currently not supported.
    #pagespeed off;

    location / {
        rewrite ^ /index.php$request_uri;
    }

    location ~ ^\/(?:build|tests|config|lib|3rdparty|templates|data)\/ {
        deny all;
    }
    location ~ ^\/(?:\.|autotest|occ|issue|indie|db_|console) {
        deny all;
    }

    location ~ ^\/(?:index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+)\.php(?:$|\/) {
        fastcgi_split_path_info ^(.+?\.php)(\/.*|)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param HTTPS on;
        # Avoid sending the security headers twice
        fastcgi_param modHeadersAvailable true;
        # Enable pretty urls
        fastcgi_param front_controller_active true;
        fastcgi_pass php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off;
    }

    location ~ ^\/(?:updater|oc[ms]-provider)(?:$|\/) {
        try_files $uri/ =404;
        index index.php;
    }

    # Adding the cache control header for js, css and map files
    # Make sure it is BELOW the PHP block
    location ~ \.(?:css|js|woff2?|svg|gif|map)$ {
        try_files $uri /index.php$request_uri;
        add_header Cache-Control "public, max-age=15778463";
        # Add headers to serve security related headers (It is intended to
        # have those duplicated to the ones above)
        # Before enabling Strict-Transport-Security headers please read into
        # this topic first.
        #add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;";
        #
        # WARNING: Only add the preload option once you read about
        # the consequences in https://hstspreload.org/. This option
        # will add the domain to a hardcoded list that is shipped
        # in all major browsers and getting removed from this list
        # could take several months.
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag none;
        add_header X-Download-Options noopen;
        add_header X-Permitted-Cross-Domain-Policies none;
        add_header Referrer-Policy no-referrer;

        # Optional: Don't log access to assets
        access_log off;
    }

    location ~ \.(?:png|html|ttf|ico|jpg|jpeg)$ {
        try_files $uri /index.php$request_uri;
        # Optional: Don't log access to other assets
        access_log off;
    }
}
```

如果你遇到什么问题或想用 HTTPS，可以参考这篇文章：https://docs.nextcloud.com/server/15/admin_manual/installation/nginx.html

建立软链接：

```shell
ln -s /etc/nginx/sites-available/nextcloud /etc/nginx/sites-enabled/nextcloud
```

重启 Nginx 服务：

```shell
service nginx restart
```

然后就大功告成啦！



## 安装 OnlyOffice

大致步骤参考 [官方文档](https://helpcenter.onlyoffice.com/server/linux/document/linux-installation.aspx) 就可以啦，需要注意的是 `sudo apt-get install onlyoffice-documentserver` 可能会很慢，所以推荐新建一个窗口来执行安装的步骤，比如用 tmux 命令 `tmux new -s install-onlyoffice` ，安装完成后按 `Ctrl+B D` 组合键就可以啦。



## 链接 NextCloud 和 OnlyOffice

运行下面的命令：

```shell
cd /var/www/nextcloud/apps
git clone https://github.com/ONLYOFFICE/onlyoffice-nextcloud.git onlyoffice
chown -R www-data:www-data onlyoffice
```

然后在 `http://<documentserver>/` 里面访问应用再安装就成了。



## 参考

- https://linuxize.com/post/how-to-install-and-configure-nextcloud-on-ubuntu-18-04/
- https://www.linux.com/learn/how-install-nextcloud-server-ubuntu
- https://mediatemple.net/community/products/dv/211643846/install-nextcloud-on-ubuntu-14.04
- https://docs.nextcloud.com/server/15/admin_manual/installation/nginx.html
- https://help.nextcloud.com/t/i-dont-want-to-use-https/3969/5
- https://stackoverflow.com/questions/43543718/nginx-and-php-fpm-502-error
- https://helpcenter.onlyoffice.com/server/linux/document/linux-installation.aspx
- https://github.com/ONLYOFFICE/onlyoffice-nextcloud#overview

