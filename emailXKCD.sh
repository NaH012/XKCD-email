sent="false"
mkdir $dir/tmp
touch $dir/viewed.pictures
wget -O $dir/tmp/index.html xkcd.com/index.html
while [ $sent = "false" ]
do
	num="$(cat $dir/tmp/index.html | grep Permanent\ link | cut -d'/' -f4)"
	img="$(cat $dir/tmp/index.html | grep -A 1 \<div\ id=\"comic\" | grep -v \<div)"
	url="$(echo "{$img}" | cut -d'/' -f3- | cut -d'"' -f1)"
	name="$(echo $url | cut -d'/' -f3)"
	alt="$(echo "{$img}" | cut -d'"' -f4 | recode html..ascii)"
	used="$(cat $dir/viewed.pictures | grep $num)"
	if [ -z "$used" ]; then
		wget -O $dir/tmp/$name $url
		echo $num >> $dir/viewed.pictures
		rm $dir/tmp/index.html*
		file="$(ls -l $dir/tmp | grep - | sed 's/  */ /g' | cut -d' ' -f9)"
		echo $alt | mail -A $dir/tmp/$file $*
		rm -r $dir/tmp
		sent="true"
	else
		while [ -n "$used" ]
		do
			new="$(shuf -i 1-$num -n 1)"
			used="$(cat $dir/viewed.pictures | grep $new)"
		done
		rm $dir/tmp/index.html*
		wget -O $dir/tmp/index.html xkcd.com/$new/index.html
	fi
done
