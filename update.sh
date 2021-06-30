echo "Site updated at: `date`"
git add . 
git commit -m "Site updated: `date`" 
git push
hexo d -g