#!/bin/sh
# Created By Nate Ober
# Nate [dot] Ober [at] Gmail

LBLUE='\033[0;36m';
DBLUE='\033[0;34m';
BLACK='\033[0;30m';
GREEN='\033[0;32m';
RED='\033[0;31m';
YELLOW='\033[0;33m';
WHITE='\033[0;37m';

LINES=20;
HIGHLIGHT=RED;
SYMBOL="__";
MOUNT="/";
DEVICENAME="hd"

usage()
{
cat << EOF
usage: $0 options

This script will output a series of divisor symbols with the line that represents the percent full highlighted in one of several colors. 
I wrote this for use with Geektool. It is best operated in Geektool by using the "dot" convention ". /path/to/script.sh".

OPTIONS:
   -h      Highlight color. The color of the pipe line that indicates percent full. 
		   Options are LBLUE, DBLUE, BLACK, GREEN, RED, YELLOW, WHITE. Default is RED.
		   
   -l      Total number of divisor symbols. Default is 40.
   
   -s      The string to use as a divisor symbol. The default is a "__". (As you might expect, you must surround the string in quotes)
   
   -m	   Mount location. The default is "/", the home directory. Remember to quote any directory that contains spaces. (Example -m "/Volumes/Time Machine Backups")
   
   -n	   Name of device. This is an alias used to visually identify this device. The default is "hd".
   		   If you use multile instantiations of this script you may want to identify each device by a short
   		   identifier. It looks best, at the moment, if you use two characters such as "HD" or "TM" (for Time Machine).
   
EOF
}

while getopts “:h:l:s:m:n:” OPTION
do
     case $OPTION in
         h)
             HIGHLIGHT=$(echo "$OPTARG" | tr '[a-z]' '[A-Z]')
             ;;
         l)
             LINES="$OPTARG"
             ;;
    	 s)
             SYMBOL=$(printf '%s' $OPTARG)
             ;;
         m)
             MOUNT="$OPTARG"
             ;;
    	 n)
             DEVICENAME="$OPTARG"
             ;;
    	 ?)
             usage
             exit
             ;;
         *)
             usage
             exit
             ;;
     esac
done

case $HIGHLIGHT in
	LBLUE)
		HIGHLIGHT=$LBLUE
		;;
	DBLUE)
		HIGHLIGHT=$DBLUE
		;;
	BLACK)
		HIGHLIGHT=$BLACK
		;;
	GREEN)
		HIGHLIGHT=$GREEN
		;;
	RED)
		HIGHLIGHT=$RED
		;;
	YELLOW)
		HIGHLIGHT=$YELLOW
		;;
	WHITE)
		HIGHLIGHT=$WHITE
		;;
	*)
		usage
		exit
		;;
esac


DIVTOT=`df -h "$MOUNT" | awk -v lines="$LINES" 'NR==2{printf "%.0f\n", lines-(($5/100)*lines)}'`
for ((i=1;i<$LINES;i++));do 
	if [ $i -ge $DIVTOT ]; then
		echo " $(echo $HIGHLIGHT)$SYMBOL$(echo  '\033[0m')"; 
	else 
		echo " $SYMBOL";
	fi
done
echo " $DEVICENAME"
echo "$(df -h "$MOUNT" | awk 'NR==2{printf "%s",$5}')"