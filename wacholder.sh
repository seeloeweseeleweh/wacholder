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
From seeloewe.seele.weh@piratenpartei-nrw.de Tue Aug 28 11:38:59 2012
Return-Path: <seeloewe.seele.weh@piratenpartei-nrw.de>
Delivered-To: nanooq-piratenpartei.de_wacholder1@nanooq.org
Received: (qmail 2012 invoked from network); 28 Aug 2012 11:38:59 -0000
Received: from unknown (HELO mail.piratenpartei-nrw.de) (84.246.124.146)
  by cassiopeia.uberspace.de with SMTP; 28 Aug 2012 11:38:59 -0000
Received: from localhost (unknown [127.0.0.1])
	by mail.piratenpartei-nrw.de (MTA) with ESMTP id 1AA44B5E3C8
	for <piratenpartei.de_wacholder1@nanooq.org>; Tue, 28 Aug 2012 11:38:56 +0000 (UTC)
Received: from mail.piratenpartei-nrw.de ([127.0.0.1])
	by localhost (mail.piratenpartei-nrw.de [127.0.0.1]) (MFA, port 10024)
	with LMTP id dDAtrr6cpgjj
	for <piratenpartei.de_wacholder1@nanooq.org>;
	Tue, 28 Aug 2012 13:38:54 +0200 (CEST)
Received: from [192.168.26.21] (pD9ECB0ED.dip.t-dialin.net [217.236.176.237])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.piratenpartei-nrw.de (MTA) with ESMTPSA id DE430B5E3C4
	for <piratenpartei.de_wacholder1@nanooq.org>; Tue, 28 Aug 2012 11:38:53 +0000 (UTC)
Message-ID: <503CADCD.5000106@piratenpartei-nrw.de>
Date: Tue, 28 Aug 2012 13:38:53 +0200
From: Seeloewe Seele weh <seeloewe.seele.weh@piratenpartei-nrw.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: piratenpartei.de_wacholder1@nanooq.org
Subject: DasIstEinTestAusEinerEMailHeraus
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE0628D484A6CD29D699225CC"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE0628D484A6CD29D699225CC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

DasisteinText









--------------enigE0628D484A6CD29D699225CC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQPK3NAAoJEFVZaSsBFC/xDI0H/1PiV2c9FQfClpGqo93gR9Oz
NZMw+LPRFrrrOisuN3iVks6UrqCcbBqx3C/ob4jbbS9MO1POVXx49R5C3mlZVNep
QlJDSRYyyaGR1tIzLDR6MI4AVYVyzj6+RuRVPpg6vwosatwpDT7/k0v6SP9eSYQN
zHST1F9Jz+lBLFPPS0irT6sRK6h5t/Rqb0HIRY/4sUSr0KIhpewnWhuOxQaTrHSc
vhMQ8o0Uo2SRjmpATatgjbLmo8pevu3CHsDgaKWHQAOGH1j8HZzD71jM4FNvsLNA
/QcY18LuIgOwyao87CHmvyQKNWYxmS2lHacdwwW2+avurqgh1Xa022ggZVapkyo=
=EYgj
-----END PGP SIGNATURE-----

--------------enigE0628D484A6CD29D699225CC--

