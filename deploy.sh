#!/bin/bash
PKG_NAME="plugin.video.youtube"

rsync -avh --progress --exclude=".*" ../$PKG_NAME $PKG_NAME/
version="5.3.7"
cd $PKG_NAME > /dev/null
zip -r $PKG_NAME-$version.zip $PKG_NAME -x $PKG_NAME/*.git*\* $PKG_NAME/*.DS_Store*\*
#tail -n +2 addon.xml > addon.xml # remove first line
#comm -23 addon.xml ../addons.xml
cp $PKG_NAME/addon.xml .
rm -r $PKG_NAME
cd ..
echo "don't forget to copy over the content from $PKG_NAME/addon.xml to addons.xml"
#read -t 30
read
MD5=$(md5 -q addons.xml)
if [[ $(cat addons.xml.md5) == "$MD5" ]]; then
  echo "[WARNING] addons.xml unchanged"
  # exit 1
else
  echo $MD5 > addons.xml.md5 
  echo $MD5
fi
git add .
git commit -m "[update] $PKG_NAME v$version"
echo "ready to push changes?"
read
git push origin master
exit 0