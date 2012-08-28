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
###############################################################################

wPathWorkingDirectory='/home/nanooq/.wacholder/dailies/'

wIncoming="$(cat)"

sep1='{sep1}'
sep2='{sep2}'
sep3='{sep3}'

# We ll make file names out of those:
wDate="$(date +%Y%m%d)"
wMailingliste=$(echo "$wIncoming" | sed '/^List-Id: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
wSubject=$(echo "$wIncoming" | sed '/^Subject: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
wMailingliste="${wMailingliste/$sep1/}" # remove probable separators 
wMailingliste="${wMailingliste/$sep2/}"
wSubject="${wSubject/$sep1/}" # remove probable separators 
wSubject="${wSubject/$sep2/}"
wSubject="${wSubject/'Re: '/}" # remove stupid prefixes	
wtFilename="$wPathWorkingDirectory""$wDate""$sep1""$wMailingliste""$sep2""$wSubject" # TODO That's going to be a long one...

#echo $wtFilename

# If this is a new "Wacholder" make a file
if [ ! -e "$wtFilename" ] 
then 
   touch "$wtFilename" 
fi

#if [[ "$wSubject" == *=?* ]] # Encoding TODO
#then 
#   echo 'message is encoded!'
#fi

# Here, we want to add a date-bee-tupel to the juniper
wTupelDate=$(echo "$wIncoming" | sed '/^Date: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
#TODO Should the date be saved in a special format?
wTupelBee=$(echo "$wIncoming" | sed '/^From: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
wTupelDate="${wTupelDate/$sep3/}" # remove probable separators 
wTupelBee="${wTupelBee/$sep3/}" # remove probable separators 
wTupel="$wTupelDate""$sep3""$wTupelBee"
echo "$wTupel" >> "$wtFilename"