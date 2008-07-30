# Quick shell script to format the xml files
for xml in *.xml ; do
echo Formatting $xml
xmlstarlet fo $xml > temp.xml
mv temp.xml $xml
done
