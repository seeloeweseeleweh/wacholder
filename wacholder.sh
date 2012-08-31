# !/bin/bash

###############################################################################
#
# wachholder.sh
#
# 'Wacholder' is a plant, a juniper, in English. Basically, the plan is to have
# a meta look at mailinglists. There'll be an e-mail adress planted as a "root"
# (not admin, a root as the feet of a flower) into the soil of n mailinglists. 
# From there it'll get all the e-mails from and forward it to this shell
# script. This script makes a juniper file out of it and saved all the 
# following e-mails as tupels inside of that file. A tupel consist of the date
# of e-mail received and the bee (user) that wrote it.
#
# There will be another script called "rasenmaeher" (lawn mower) that'll take
# care of the files, but them in folders after some time and also deletes them.
#
# There will be another script called "imker" (dude that handles bees) that'll 
# evaluate the wacholder files and generat meta information of them and saves
# them in files called "honigtopf" (honey pots) 
# 
# Enter @OLGR who will make a web visual of those statistics. No clue how he 
# will call them. 
#
# Yes, the methaphor only goes so far. There are TODOs included in the script
# just search for them.
#
# Developers:
#
# How the csv-format is implemented:
# fields' delimiter: ,
# texts' delimert: "
#
# Happy Hacking
#
###############################################################################

# cd to script's directory
wPathWorkingDirectory=$( cd "$( dirname "$0" )" && pwd )
cd "$wPathWorkingDirectory"

wConfigFile='wacholder.cfg'

###
# 
# Config variables
#

# TODO: http://wiki.bash-hackers.org/howto/conffile security issues with config 
# files

source "$wConfigFile"

###
#
# Functions
#

encoding() { # $1 string to check for encoding
   if [[ "$1" == *=?* ]]
   then
      echo "$1" >> "$wFileEnc"
   fi
}

###
# 
# Variables
#

wPipedEmail="$(cat)" # Store piped e-mail text
# Generate a re   presentative filename
# Date: Extract e-mail's date for 
wDateString=$(echo "$wPipedEmail" | sed '/^Date: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;') 
wDate=$(date -d "$wTupelDate" +%Y%m%d)
# Mailinglist: Extract mailinglist
wMailinglist=$(echo "$wPipedEmail" | sed '/^List-Id: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
encoding "$wMailinglist" # TODO take care of encoding
# Subject: Extract subject
wSubject=$(echo "$wPipedEmail" | sed '/^Subject: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
encoding "$wSubject" # TODO take care of encoding
# TODO take care of Tags, "Re:" and "Forwards"
# TODO remove not meant separators from text before adding them
# TODO cut filename at some point. 255 seems to be maximum, but 100 should be enough.
wtFilename="$wDate""$sep1""$wMailinglist""$sep2""$wSubject""$wCSV"

# Make e-mail meta data 'tupel' permanent in .csv-format
if [ ! -e "$wDirData"'/'"$wtFilename" ] # If the file does not yet exist...
then # ...hence this is a new thread and...
   touch "$wDirData"'/'"$wtFilename" # ...new threads are saved in a file.
fi
# Create 'tupel' to be fed into file in .csv-format
wTupelDate="$wDateString"
wTupelUser=$(echo "$wPipedEmail" | sed '/^From: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
# TODO remove not meant separators from text before adding them
wTupel='"'"$wTupelDate"'"'","'"'"$wTupelUser"'"'
# Push tupel into file
echo "$wTupel" >> "$wDirData"'/'"$wtFilename"