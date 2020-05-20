---
title: 关于 Java NIO 的一些小事
date: 2019-10-22 18:58:52
tags: java
---

Java NIO（Non-blocking / New IO）是一种**<u>同步非阻塞</u>**的 I/O 模型，也是 I/O 多路复用的基础，是解决高并发与大量连接和 I/O 处理问题的有效方式。<!-- more -->



## 为什么需要 Java NIO？

以下是传统的服务器端同步阻塞 I/O （每连接每线程，线程用线程池管理）模型的示例代码：

```java
// 创建线程池
ExecutorService executor = Excutors.newFixedThreadPollExecutor(100);
ServerSocket serverSocket = new ServerSocket();
serverSocket.bind(8088);
while (!Thread.currentThread.isInturrupted()) {
		// 主线程死循环等待新连接到来
		Socket socket = serverSocket.accept();
  	// 为新的连接创建新的线程
		executor.submit(new ConnectIOHandler(socket));
}

class ConnectIOnHandler extends Thread {
    private Socket socket;
    public ConnectIOHandler(Socket socket){
    		this.socket = socket;
    }
    public void run() {
      	// 死循环处理读写事件
    		while (!Thread.currentThread.isInturrupted() && !socket.isClosed()) {
      			String someThing = socket.read();
      			if (someThing != null) {
      	  			// 处理数据...
      	  			// 写数据
      	  			socket.write()....
      	  	}
      	}
    }
}
```

这里之所以使用多线程，是因为 socket.accept()、socket.read()、socket.write() 三个方法都是同步阻塞的，所以一个 socket 只能顺序地去执行各个请求。因此使用多线程的目的是从 CPU 的角度去同时执行多个请求，保证 CPU 资源不被浪费。

现在 Java 的多线程一般都是用线程池，线程的创建和回收成本相对较低（在活动连接数较小的情况下，如小于单机 1000）。但这个模型最本质的问题在于**过分依赖线程**。线程是相对来说比较昂贵的系统资源，主要表现在：

- 线程的创建和销毁成本很高
- 线程本身占用较大的内存，像 Java 的线程栈，一般至少分配 512K ~ 1M 的空间
- 线程的切换成本相对很高。操作系统发生线程切换的时候，需要保留线程上下文，执行系统调用。如果线程数过高，其切换的时间甚至会大于执行时间
- 容易造成锯齿状的系统负载。因为系统负载是用活动线程数和 CPU 核心数，一旦线程数量高但外部网络环境不是很稳定，就容易造成大量请求的结果同时返回，激活大量阻塞线程从而使系统负载压力过大

所以当面对十万以上级别连接的时候，传统的 BIO 模型就无能为力了，我们需要更强大的 NIO 来处理高数量级的请求。



## 什么是 NIO？

一个 I/O 操作其实可以分成两个步骤：

1. 发起 I/O 请求
2. 实际的 I/O 操作

NIO 与 BIO 的区别在于第一个步骤是否阻塞，也就是说 BIO 在发起 socket.read() 请求时，如果没有数据，就会一直阻塞；NIO 遇到数据还没准备好的情况则直接返回 0。

最新的 AIO（Async I/O）则更进一步，等待就绪和实际读写的过程都是异步的，用户只需要关心“数据是否已经准备好”或“已经写好”这些问题。

总而言之，NIO 在 socket 读、写、注册和接收方法中，在等待就绪阶段是非阻塞的，而真正的 I/O 操作是同步（阻塞）的（但性能很高）。



## 使用 NIO 的同步非阻塞特性

NIO 的读写函数可以立即返回结果而无需等待，所以当一个连接还不能进行读写（表现为 socket.read() / socket.write() 返回 0）的时候，我们可以把这件事记下来，通常是在 Selector 上注册标记位，然后切换到其他就绪的连接（Channel）继续进行读写。

利用事件模型（event-driven）我们可以**单线程**处理所有的 I/O 请求：

NIO 的主要事件有：读就绪、写就绪、发现新连接

我们首先需要注册这几个事件对应的处理器（handler），然后在合适的时机我们可以告诉事件选择器：我对这个事件感兴趣。对于写操作，就是写不出去的时候对写事件感兴趣；对于读操作，就是完成连接和系统没有办法承载新读入的数据的时；对于 accept，一般是服务器刚启动的时候；而对于 connect，一般是 connect 失败需要重连或者直接异步调用 connect 的时候。

然后我们用一个死循环选择就绪的事件，此时会执行系统调用（Linux 2.6 前是 select & poll，2.6 之后是 epoll），还会阻塞地等待新事件的到来。新事件到来的时候，会在 selector 上注册标记位，标记可读、可写或有新连接到来。

**select 是阻塞的**，无论是通过操作系统的通知（epoll）还是轮询（select & poll）。

程序的代码示例如下：

```java
interface ChannelHandler {
	void channelReadable(Channel channel);
	void channelWritable(Channel channel);
}

class Channel {
  Socket socket;
  Event event; // 读，写或者连接
}

class IoThread extends Thread {
  	// 所有channel的对应事件处理器
		Map<Channel，ChannelHandler> handlerMap;
  
   	public void run(){
   			Channel channel;
   			// 选择就绪的事件和对应的连接
   			while (channel = Selector.select()) {
   					if (channel.event == accept) {
   			   		// 如果是新连接，则注册一个新的读写处理器
   			   		registerNewChannelHandler(channel);
   			   }
   			   if (channel.event == write) {
   			     	// 如果可以写，则执行写事件
   			   		getChannelHandler(channel).channelWritable(channel);
   			   }
   			   if (channel.event == read) {
   			     	// 如果可以读，则执行读事件
   			      getChannelHandler(channel).channelReadable(channel);
   			   }
   			 }
   	}
}
```



## 进一步优化线程模型

通过以上的例子，我们由原来的阻塞读写（占用线程）变成了单线程轮询事件，找到可以进行读写的网络描述符进行读写。除了事件的轮询是阻塞的（没有可干的事情必须要阻塞），剩余的 I/O 操作都是纯 CPU 操作，没有必要开启多线程。不过现在服务器一般都拥有多核处理器，如果能利用多核心进行 I/O，将会极大地提升效率。

仔细分析我们需要的线程，主要包含以下几种：

1. 事件分发器，单线程选择就绪的事件
2. I/O 处理器，包括 connect、read、write 等，这种纯 CPU 操作，一般开启 CPU 核心个线程就可以
3. 业务线程，在处理完 I/O 后，业务一般还会有自己的业务逻辑，有的还会有其他的阻塞 I/O ，如 DB 操作，RPC 等

但 Java 的 Selector 对于 Linux 系统来说，有一个致命的限制：**同一个 channel 的 select 不能被并发地调用**。因此如果有多个 I/O 线程，必须保证一个 socket 只能属于一个 I/O thread，而一个 I/O thread 可以管理多个 socket。

另外连接的处理和读写的处理通常可以分开，这样对于海量连接的处理和读写就可以进行分发，虽然 read() 和 write() 都是无阻塞的函数，但毕竟会占用 CPU，如果面对更高的并发则无能为力。



## Proactor 与 Reactor

一般情况下，I/O 复用机制需要事件分发器（event dispatcher）。 事件分发器的作用，即将那些读写事件源分发给各读写事件的处理者，就像送快递的在楼下喊：谁谁谁的快递到了， 快来拿吧！开发人员在开始的时候需要在分发器那里注册感兴趣的事件，并提供相应的处理者（event handler)，或者是回调函数；事件分发器在适当的时候，会将请求的事件分发给这些 handler 或者回调函数。

涉及到事件分发器的两种模式称为：Reactor 和 Proactor。 Reactor 模式是基于同步 I/O 的，而 Proactor 模式是和异步 I/O 相关的。在 Reactor 模式中，事件分发器等待某个事件或者可应用或个操作的状态发生（比如文件描述符可读写，或者是 socket 可读写），事件分发器就把这个事件传给事先注册的事件处理函数或者回调函数，由后者来做实际的读写操作。而在 Proactor 模式中，事件处理者（或者代由事件分发器发起）直接发起一个异步读写操作（相当于请求），而实际的工作是由操作系统来完成的。发起时，需要提供的参数包括用于存放读到数据的缓存区、读的数据大小或用于存放外发数据的缓存区，以及这个请求完后的回调函数等信息。事件分发器得知了这个请求，它默默等待这个请求的完成，然后转发完成事件给相应的事件处理者或者回调。举例来说，在 Windows 上事件处理者投递了一个异步 I/O 操作（称为 overlapped 技术），事件分发器等 IO Complete 事件完成。这种异步模式的典型实现是基于操作系统底层异步 API 的，所以我们可称之为“系统级别”的或者“真正意义上”的异步，因为具体的读写是由操作系统代劳的。举个例子：

在 Reactor 中实现读操作需要的步骤：

1. 注册读就绪事件和相应的事件处理器
2. 事件分发器等待事件
3. 事件到来，激活分发器，分发器调用事件对应的处理器
4. 事件处理器完成实际的读操作，处理读到的数据，注册新的事件，然后返还控制权

在 Proactor 中实现读操作需要的步骤：

1. **处理器**发起异步读操作（操作系统必须支持异步 I/O ），在这种情况下，处理器**无视 I/O 就绪事件**，关心的是 **I/O 完成事件**
2. 事件分发器等待操作完成事件
3. 在分发器等待过程中，操作系统利用并行的内核线程执行实际的读操作，并将结果数据存入用户自定义缓冲区，最后通知事件分发器读操作完成
4. 事件分发器呼唤事件处理器
5. 事件处理器处理用户自定义缓冲区中的数据（此时数据已经读好了），然后启动一个新的异步操作，并将控制权返回事件分发器

回调 Handler 的时机：

- Reactor：读写操作已经就绪，Handler 来执行读写操作
- Proactor：读写操作已经完成，可以直接对缓冲区的数据进行操作



## Buffer 的选择

通常情况下，操作系统的一次写操作分为两步： 

1. 将数据从用户空间拷贝到系统空间
2. 从系统空间往网卡上写

同理，读操作也分为两步： 

1. 将数据从网卡拷贝到系统空间
2. 将数据从系统空间拷贝到用户空间

对于 NIO 来说，缓存的使用可以使用 DirectByteBuffer 和 HeapByteBuffer 。如果使用了 DirectByteBuffer ，一般来说可以减少一次系统空间到用户空间的拷贝；但此时 Buffer 创建和销毁的成本更高，更不宜维护，通常会用内存池来提高性能。

如果数据量比较小的中小应用情况下，可以考虑使用 HeapBuffer ；反之可以用 DirectBuffer 。



## 其他一些需要注意的地方

使用 NIO != 高性能，当连接数 <1000，并发程度不高或者局域网环境下 NIO 并没有显著的性能优势。

NIO 并没有完全屏蔽平台差异，它仍然是基于各个操作系统的 I/O 系统实现的，差异仍然存在。使用 NIO 做网络编程构建事件驱动模型并不容易，陷阱重重；推荐使用成熟的 NIO 框架，如 Netty、MINA 等，这类框架已经解决了很多 NIO 的陷阱，且屏蔽了操作系统的差异，有较好的编程模型和性能。



> 参考（抄自）：https://tech.meituan.com/2016/11/04/nio.html