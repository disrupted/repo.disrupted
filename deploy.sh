#!/bin/bash
PKG_NAME='skin.arctic.zephyr.plus'

version_prev=$(tail -n+2 $PKG_NAME/addon.xml | head -n1 | cut -d\" -f6)
rsync -avh --progress --exclude=".*" ../$PKG_NAME $PKG_NAME/
#cd ..
#curl -v -o $PKG_NAME/$PKG_NAME/ FILE://$PKG_NAME
cd $PKG_NAME
version=$(tail -n+2 $PKG_NAME/addon.xml | head -n1 | cut -d\" -f6)
# cd $PKG_NAME > /dev/null
zip -r $PKG_NAME-$version.zip $PKG_NAME -x $PKG_NAME/*.git*\* $PKG_NAME/*.DS_Store*\*
#tail -n +2 addon.xml > addon.xml # remove first line
#comm -23 addon.xml ../addons.xml
cp $PKG_NAME/addon.xml .
rm -r $PKG_NAME

cd ..

echo -e "\n\n"
echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<addons>" > addons.xml.new

for D in `find . -mindepth 1 -type d -not -path '*/\.*'`
do
  #echo -e "\n $D"
  tail -n+2 $D/addon.xml | sed 's/^/  /' >> addons.xml.new
done
echo -e "</addons>" >> addons.xml.new
cat addons.xml.new
echo -e "\n$version_prev → $version\nDoes this look right?"
#echo "don't forget to copy over the content from $PKG_NAME/addon.xml to addons.xml"
#read -t 30
read
mv addons.xml.new addons.xml
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
