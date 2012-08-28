# !/bin/bash

# Daily mowing happens here
#
# Create a folder of with today's junipers.

bSomeDateToBeMoved="$(date --date='today -1 days' +%Y%m%d)"
bFolderDaily="dailyMow"

if [ -f "$bSomeDateToBeMoved"* ]
then
   bFoldername="$bFolderDaily""$bSomeDateToBeMoved"
   mkdir "$bFoldername"
   for bFileFromLastDay in $bSomeDateToBeMoved*
   do
      echo 'Wacholder '"$bFileFromLastDay"' nach '"$bFoldername"' verschoben.'
      mv "$bFileFromLastDay" "$bFoldername"
      echo 'Fertig gemäht!'
   done
else
   echo "Keine Wacholder von gestern gefunden."
fi

# Weely mowing happens here
#
# get week old juniper folder and move it to the weekly junipers

#bSomeDateToBeMoved="$(date --date='today -1 weeks -1days' +%Y%m%d)"
#bFolderDailyWeekly="$bFolderDaily""$bSomeDateToBeMoved"
#bFolderWeekly="weeklyMows"

#if [ ! -d "$bFolderWeekly" ] # Check for weekly folder
#then
#   mkdir "$bFolderWeekly"
#fi

#if [ -d "$bFolderDailyWeekly"* ] # Check for one week old juniper
#then
#   mv "$bFolderDailyWeekly" "$bFolderWeekly"
#fi

# Monthly mowing happens here
#
# check if the folder for weekly junipers is full, then 
# move one into the monthly folder

#bFolderMonthly="monthlyMows"

#if [ ! -d "$bFolderMonthly" ] # Check for monthly folder
#then
#   mkdir "$bFolderMonthly"
#fi

#bNumberOfFolders=$( find "$bFolderMonthly" -maxdepth 1 -type d | wc -l)

#if [[ $bNumberOfFolders -ge 7 ]]
#then
#   for folder in "$bFolderMonthly"/
#   do 
#      echo $folder
#      echo $(date --d="$(stat -c %y $folder)" +%Y%m%d)
#   done
#fi

