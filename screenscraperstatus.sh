#!/bin/bash 

screenscraper(){
clear
lasttime="0"
timetilloop="1800"
looptime=$(python -c "print($timetilloop - $lasttime)")

mkdir ~/Downloads/screenscraperstatus
cd ~/Downloads/screenscraperstatus
wget screenscraper.fr
downformaintenance=$(cat index.html | grep -o "Site is down for maintenance")
if [[ "$downformaintenance" == "Site is down for maintenance" ]]; then
	echo -e "\n================ www.screenscraper.fr is down. Website reply follows: ================"
	echo -e "\n\t\tSite is down for maintenance. Please come back later\n\n"
	rm -R ~/Downloads/screenscraperstatus
	exit 1
	fi

cpu1=$(cat index.html | grep -A 1 "nowrap>CPU1" | grep % | cut -d '>' -f2 | cut -d '<' -f1 | cut -d '&' -f1)
cpu2=$(cat index.html | grep -A 1 "nowrap>CPU2" | grep % | cut -d '>' -f2 | cut -d '<' -f1 | cut -d '&' -f1)
nmbrthreadsperminute=$(cat index.html | grep -A 3 "nowrap>nb. threads / min." | grep -v sujet | grep -v tr | grep -v result | cut -d '<' -f1 )
nmbrscrapers=$(cat index.html | grep -A 3 "nowrap>nb. scrapeurs" | grep -v sujet | grep -v tr | grep -v result | cut -d '<' -f1 )
nmbrnonmembersonline=$(cat index.html | grep -A 3 "nowrap>nb. non inscrits" | grep -v sujet | grep -v tr | grep -v result | cut -d '<' -f1 )

nonmembers=$(cat index.html | grep -A 2 "nowrap>non inscrits" | grep false | cut -d '/' -f2 | cut -d '.' -f1)
if [[ "$nonmembers" == "false" ]]; then
	nonmemberstatus="DOWN"
fi
nonmembers=$(cat index.html | grep -A 2 "nowrap>non inscrits" | grep true | cut -d '/' -f2 | cut -d '.' -f1)
if [[ "$nonmembers" == "true" ]]; then
	nonmemberstatus="UP"
fi

members=$(cat index.html | grep -A 2 "nowrap>inscrits" | grep false | cut -d '/' -f2 | cut -d '.' -f1)
if [[ "$members" == "false" ]]; then
	memberstatus="DOWN" 
fi
members=$(cat index.html | grep -A 2 "nowrap>inscrits" | grep true | cut -d '/' -f2 | cut -d '.' -f1)
if [[ "$members" == "true" ]]; then
	memberstatus="UP"
fi

contributors=$(cat index.html | grep -A 2 "nowrap>contributeurs" | grep false | cut -d '/' -f2 | cut -d '.' -f1)
if [[ "$contributors" == "false" ]]; then
	contributorstatus="DOWN"
fi
contributors=$(cat index.html | grep -A 2 "nowrap>contributeurs" | grep true | cut -d '/' -f2 | cut -d '.' -f1)
if [[ "$contributors" == "true" ]]; then
	contributorstatus="UP"
fi

if [[ "$cpu1" == "%" ]]; then cpu1="N/A (Not in use)";fi
if [[ "$cpu2" == "%" ]]; then cpu2="N/A (Not in use)";fi

echo -e "================================"
echo -e "SCREENSCRAPER SERVER STATUS:"
echo -e "CPU1 USE: $cpu1\nCPU2 USE: $cpu2"
echo -e "Processing $nmbrthreadsperminute threads per minute"
echo -e "Scrapers Online: $nmbrscrapers"
echo -e "Unregistered Guests Online: $nmbrnonmembersonline"
echo -e "================================"
echo -e "SCREENSCRAPER API STATUS FOR:"
echo -e "Unregistered Guests: \t$nonmemberstatus\nFree Members: \t\t$memberstatus\nContributors: \t\t$contributorstatus\n"
cd
rm -R ~/Downloads/screenscraperstatus
looplabel=$(($timetilloop / 60 | bc))
starttime=$(date +%s)
lasttime="0"
new="0"
seconds="0"
minutes="0"

while [ $looptime -gt "0" ]
	do
	looptime=$(python -c "print($timetilloop - $lasttime)")
	loopminutes=$(python -c "print(($timetilloop - $lasttime) / 60)")
	loopseconds=$(python -c "print(($timetilloop - $lasttime) % 60)")
	echo -ne "\rScreenScraperStatus will run again in $loopminutes mins $loopseconds seconds......"
	sleep 1
	lasttime=$(($lasttime+1))
	done
screenscraper
}

screenscraper
