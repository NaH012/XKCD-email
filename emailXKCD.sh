#!/bin/bash

dir=$(readlink -f $0)
dir=$(dirname $dir)
sent=false
unsubLink=false
sendCount=$#
if [ "$1" = "-u" ]; then
	unsubLink=true
	sendCount=`expr $# - 1`
	sendCount=`expr $sendCount / 2`
fi
args=($@)
mkdir $dir/tmp
touch $dir/viewed.pictures
wget -q -O $dir/tmp/index.html xkcd.com/index.html
while [ $sent = "false" ]
do
	num="$(cat $dir/tmp/index.html | grep Permanent\ link | cut -d'/' -f4)"
	img="$(cat $dir/tmp/index.html | grep -A 1 \<div\ id=\"comic\" | grep -v \<div)"
	valid="$(grep -A 3 comic\"\> $dir/tmp/index.html | grep -A 2 \<img | grep \<\/div)"
	if [ -z "$valid" ]; then
		valid=false
	else
		valid=true
	fi
	url="$(echo "{$img}" | sed -s "s/.*src=\"//g;s/\"\ title.*//g")"
	title="$(grep ctitle $dir/tmp/index.html | cut -d\> -f2 | sed -s "s/<\/.*//g")"
	link="$(grep Permanent\ link $dir/tmp/index.html | sed -s "s/.*c:\ //g;s/<.*>//g")"
	name="$(echo $url | cut -d'/' -f3)"
	alt="$(grep -E img.*title $dir/tmp/index.html | sed -s "s/.*title=\"//g;s/\".*alt.*//g")"
	used="$(cat $dir/viewed.pictures | grep $num)"
	if [ -z "$used" -a "$valid" = true ]; then
		echo $num >> $dir/viewed.pictures

		htmlPath="$(echo /var/www/PHP-Framework/base64.html)"
		first="$(echo "<html><body style=\"font-family: Lucida,Helvetica,sans-serif; font-variant: small-caps;background-color:#96A8C8; text-align: center; padding: 40px 40px 20px 40px; align-items: center;max-width:850px;\">" )"
		first=$(echo "$first<style>.sub-title{font-weight: bold;}</style>")
		first=$(echo "$first<div style=\"background: white;border: solid 1.5px #071419; border-radius: 12px; padding:20px; max-width: 800px; width: 90%; margin-bottom: 15px;\"><h1>XKCD Email</h1><hr><h2>$title</h2>")
		first=$(echo $first\<img src=\"https:$url\" alt=\"$title\"\ style=\"max-width:100%\"\> )
		first=$(echo "$first<p><span style=\"font-weight: bold;\">Alt Text: </span>$alt</p> \
			<p><span style=\"font-weight: bold;\">Permanent Link: </span>$link</p>")
		first=$(echo "$first</div><div style=\"background: white;border: solid 1.5px #071419; border-radius: 12px; padding:20px; max-width: 800px; width: 90%; margin-bottom: 15px;font-size:0.6em;\"><p> \
			<span style=\"padding: 0 10px;\"><a href=\"https://github.com/Sodium-Hydrogen/XKCD-Email\">Source Code</a></span>")
		last=$(echo "</p></div></body></html>")
		i=0
		loc=0
		steps=1
		if [ $unsubLink = "true" ]; then
			loc=1	
			steps=2
		fi
		while [ $i -lt $sendCount ]; do
			let i=$i+1
			if [ $unsubLink = "true" ]; then
				html=$(echo "$first<span style=\"padding: 0 10px;\"><a href=\"${args[`expr $loc + 1`]}\">Unsubscribe</a></span>$last")
			else
				html=$(echo "$first$last")
			fi
			data="$( echo -e "Subject: XKCD Email\r\nMIME-Version: 1.0\r\nContent-Type: text/html; charset=utf-8\r\n")"
			#echo -e "$data\n$html" | sed -s "s/</\r\n</g" 
			echo -e "$data$html" | sed -s "s/</\n</g" | /usr/sbin/ssmtp -F "NoReply" ${args[$loc]}

			let loc=$loc+$steps
		done

		rm -r $dir/tmp
		sent="true"
	else
		while [ -n "$used" ]
		do
			new="$(shuf -i 1-$num -n 1)"
			used="$(cat $dir/viewed.pictures | grep $new)"
		done
		rm $dir/tmp/index.html*
		wget -q -O $dir/tmp/index.html xkcd.com/$new/index.html
	fi
done
