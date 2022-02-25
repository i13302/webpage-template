#!/bin/bash -e

FILESDATA=`cat ./files.tsv`
PAGEFILE=(`cat ./files.tsv | cut -f 1`)
PAGETITLE=(`cat ./files.tsv | cut -f 2`)
ROOTPATH='..'

# PHPファイルを基にHTMLファイルを生成
function build(){
	mkdir -p $ROOTPATH/docs
	for pf in ${PAGEFILE[@]}
	do
		php $pf.php > $ROOTPATH/docs/$pf.html 
	done
}

# 生成物であるHTMLファイルを/tmp/UNIQFILENAMEに移動
function clean(){
	for pf in ${PAGEFILE[@]}
	do
		mv $ROOTPATH/docs/$pf.html `mktemp`
	done
}

# 新しいページファイルの生成 $filename
function newfile(){
	cp -i parts/_template.php $1.php
	echo $1 >> $ROOTPATH/files.tsv
}

# 目次を生成
function tof(){
	mkdir -p parts/table_of_contents
	echo '<ol>' > parts/table_of_contents/$1.php
	for _h2 in $(cat $1.php |\
		grep -i '<h2>' |\
		sed -e 's/<[^>]*>//g' |\
		sed -e 's/\t*//g')
	do
		echo '<li>'$_h2'</li>' >> parts/table_of_contents/$1.php
	done
	echo '</ol>' >> parts/table_of_contents/$1.php
}

# create nav ... navを生成
function create(){
	if [ $1 == nav ]
	then 
		echo '<nav><ul>' > $ROOTPATH/page/parts/nav.php
		echo "$FILESDATA"|  awk '{print "'\<li\>\<'a href="$1"''.html'\>'"$2"'\<''\/'a>\<\/li\>" }' >> $ROOTPATH/page/parts/nav.php
		echo '</ul></nav>' >> $ROOTPATH/page/parts/nav.php
	fi
	
}

# help
function help(){
	echo 'help function'
	echo 'Usage:'
	cat `dirname $0`$0 | grep -E '^function' -B 1 | sed 's/^function\s//g'
}

function empty(){
	echo 'empty function for test.'
}


# echo $PAGEFILE
cd page
$@
