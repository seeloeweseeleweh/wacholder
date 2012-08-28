# !/bin/bash

# Daily mowing happens here
#
# Create a folder of with today's junipers.

bSomeDateToBeMoved="$(date --date='today -1 days' +%Y%m%d)"
bFolderDaily="dailyMow"
bFolderWacholder="dailies"

if ls "$bFolderWacholder"/"$bSomeDateToBeMoved"* > /dev/null 2>&1 
then 
   bFoldername="$bFolderDaily""$bSomeDateToBeMoved"
   mkdir "$bFoldername"
   for bFileFromLastDay in ls "$bFolderWacholder"/"$bSomeDateToBeMoved"*
   do
      mv "$bFileFromLastDay" "$bFoldername"
   done
   echo 'Fertig gemäht!'
fi