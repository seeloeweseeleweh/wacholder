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
# TODO don't surpass 80 digits line length
# TODO getops
# TODO usage
#
# Happy Hacking
#
###############################################################################

###
#
# Variables
#

wConfigFile="$1" 	# will hold absolute path to config file
decoded='' 		# will hold decoded string, see decoding()
unified=''		# will hold unified string, see unifying()
source "$wConfigFile"   # TODO: http://wiki.bash-hackers.org/howto/conffile 
			# security issues with config files

###
#
# Functions
#

# TODO take care of Tags, "Re:" and "Forwards"
# TODO remove not meant separators from text before adding them
# TODO cut filename at some point. 255 seems to be maximum, but 100 should be enough.
# Returns unified
unifying() { # $1 string to unify
   unified="$1"
#   unified=${unified,,} #TODO Hi, idiot! This will break base64-encoding. Have fun.
   unified=$(echo "$unified" | sed 's/Re//' )	# Re
   unified=$(echo "$unified" | sed 's/Fwd//' )	# Fwd
   unified=$(echo "$unified" | sed 's/://g' )	# :
#   if [[ unified == *=?* ]]
   if [[ "${unified#*'=?'}" != "$unified" ]] # If coding in use #newway
   then
      echo 'UnifyingNeeded:'"$unified" >> "$wFileLog"
      decoding "$unified" #decode
      unified="$decoded"
      echo 'UnifyingNeeded:'"$unified" >> "$wFileLog"
   else 
      echo 'NoUnifyingNeeded:'"$unified" >> "$wFileLog"
   fi
}

# https://www.ietf.org/rfc/rfc2047.txt
# Returns decoded

# 
# Benzinmotor 33 - 36%
# Dieselmotor 36 - 38%
# Dampfmotor 34 - 40%
# Gasturbinen 35 - 40%
# Dampfturbinen 39%
# Strahlturbinen 40%
# Raketeturbinen 45-53%
#


decoding() { # $1 string to check for decoded
   decoded="$1"
   decoded=$(echo "$decoded" | sed 's/_/ /g' )			#_
   if [[ "${decoded#*'=?utf-8?b?'}" != "$decoded" ]] # UTF-8 base 64 encoding #newway
   then 
       echo "$decoded" >> '[?utf-8?b?]'
   elif [[ "${decoded#*'=?windows-1252?Q?'}" != "$decoded" ]] # Windos 1252 Q-encoding #newway
   then 
      decoded=${decoded,,}
      decoded=$(echo "$decoded" | sed 's/=?windows-1252?Q?//' )	# coding
      decoded=$(echo "$decoded" | sed 's/=e9/e/' )		# coding
      echo "$decoded" >> '[=?windows-1252?Q?]'
   elif [[ "${decoded#*'=?iso-8859-1?q?'}" != "$decoded" ]] # ISO 8859-1 Q-encoding #newway
   then
      decoded=${decoded,,}					# lower case
      decoded=$(echo "$decoded" | sed 's/=?iso-8859-1?q?//' )	# coding
      decoded=$(echo "$decoded" | sed 's/=fc/ü/g' )		#ü
      decoded=$(echo "$decoded" | sed 's/=e4/ä/g' )		#ä
      decoded=$(echo "$decoded" | sed 's/=f6/ö/g' )		#ö
      decoded=$(echo "$decoded" | sed 's/=d6/Ö/g' )		#Ö
      echo "$decoded" >> '[=?iso-8859-1?q?]'
    elif [[ "${decoded#*'=?utf-8?q?'}" != "$decoded" ]] # UTF-8 Q-encoding #newway
   then 
      decoded=${decoded,,}					# lower case
      decoded=$(echo "$decoded" | sed 's/=?utf-8?q?//' )	# coding
      decoded=$(echo "$decoded" | sed 's/=c3=bc/ü/g' )		#ü
      decoded=$(echo "$decoded" | sed 's/=c3=96/Ö/g' )		#Ö
      decoded=$(echo "$decoded" | sed 's/=c3=a4/ä/g' )		#ä
      decoded=$(echo "$decoded" | sed 's/=22/"/g' )		#"
      decoded=$(echo "$decoded" | sed 's/=c3=b6/ö/g' )		#"
      decoded=$(echo "$decoded" | sed 's/=c3=9f/ß/g' )		#ß
      decoded=$(echo "$decoded" | sed 's/=2e/./g' )		#.
      echo "$decoded" >> '[=?utf-8?q?]'
   fi
      decoded=$(echo "$decoded" | sed 's/?=//' )		#?=
}

usage() {
   echo "Usage: cat email | wacholder.sh path/to/config.file"
}

###
#
# Skript
#

wPathWorkingDirectory=$( cd "$( dirname "$0" )" && pwd ) # cd to script's 
							 # directory
cd "$wPathWorkingDirectory"	# change into pwd
wPipedEmail="$(cat)" 		# Store piped e-mail text

#
# Prepare creation of a representative filename
# Date: Extract e-mail's date 
wDateString=$(echo "$wPipedEmail" | sed '/^Date: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;') 
wDate=$(date -d "$wTupelDate" +%Y%m%d)
# Mailinglist: Extract mailinglist
wMailinglist=$(echo "$wPipedEmail" | sed '/^List-Id: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
unifying "$wMailinglist" # Unify mailinglist name
wMailinglist="$unified"
# Subject: Extract subject
wSubject=$(echo "$wPipedEmail" | sed '/^Subject: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
unifying "$wSubject" # Unify subject
wSubject="$unified"
# Create a representative filename
wtFilename="$wDate""$sep1""$wMailinglist""$sep2""$wSubject""$wCSV"

#
# Save e-mail meta data 'tupel' permanent in a .csv-formated file
# Prepare permanent .csv-formated file 
if [ ! -e "$wDirData"'/'"$wtFilename" ] # If the file does not yet exist...
then # ...hence this is a new thread and...
   touch "$wDirData"'/'"$wtFilename" # ...new threads are saved in a file.
fi
# Prepare creation of 'tupel' to be fed into file in .csv-format
wTupelDate="$wDateString"
wTupelUser=$(echo "$wPipedEmail" | sed '/^From: */!d; s///; q' | sed 's/.*< *//;s/ *>.*//;')
unifying "$wTupelUser"
wTupelUser="$unified"
# Create 'tupel' to be fed into file in .csv-format
wTupel='"'"$wTupelDate"'"'","'"'"$wTupelUser"'"'
# Push tupel into permanent in a .csv-formated file
echo "$wTupel" >> "$wDirData"'/'"$wtFilename"

#
# Save e-mail 

