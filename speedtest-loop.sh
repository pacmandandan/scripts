#!/bin/bash

newspeedtest(){
rm ./speedtest.py 2>&1 /dev/null
wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py 
}

disable_speedtest(){
		sed -i 's/    if not args.download and not args.upload:/    #if not args.download and not args.upload:/g' speedtest.py
		sed -i 's/        raise SpeedtestCLIError('"'"'Cannot supply both --no-download and '"'"'/        #raise SpeedtestCLIError('"'"'Cannot supply both --no-download and '"'"'/g' speedtest.py
		sed -i 's/                                '"'"'--no-upload'"'"')/                                #'"'"'--no-upload'"'"')/g' speedtest.py
}

enable_speedtest(){
		sed -i 's/    #if not args.download and not args.upload:/    if not args.download and not args.upload:/g' speedtest.py
		sed -i 's/        #raise SpeedtestCLIError('"'"'Cannot supply both --no-download and '"'"'/        raise SpeedtestCLIError('"'"'Cannot supply both --no-download and '"'"'/g' speedtest.py
		sed -i 's/                                #'"'"'--no-upload'"'"')/                                '"'"'--no-upload'"'"')/g' speedtest.py
}


speedloop(){
	if [[ "$upload_status" == "ON" ]] && [[ "$download_status" == "ON" ]]; then
		enable_speedtest
		echo "---------------------------------------------------" 
		python speedtest.py
		echo "---------------------------------------------------" 
	fi
	if [[ "$upload_status" == "OFF" ]] && [[ "$download_status" == "ON" ]]; then
		enable_speedtest
		echo "---------------------------------------------------" 
		python speedtest.py --no-upload
		echo "---------------------------------------------------" 
	fi
	if [[ "$upload_status" == "ON" ]] && [[ "$download_status" == "OFF" ]]; then
		enable_speedtest
		echo "---------------------------------------------------" 
		python speedtest.py --no-download
		echo "---------------------------------------------------" 
	fi
	if [[ "$upload_status" == "OFF" ]] && [[ "$download_status" == "OFF" ]]; then
		disable_speedtest
		echo "---------------------------------------------------" 
		python speedtest.py --no-download --no-upload
		echo "---------------------------------------------------" 
	fi

	if [[ "$loopstatus" == "ON" ]]; then
		sleep $loopsleep
		speedloop
	fi
}

main(){
	clear
	echo -e "Speedtest Upload Speed is $upload_status\nSpeedtest Download Speed is $download_status\nSpeedtest Looping is $loop_status every $loopsleep seconds"

	echo -e "[u] Toggle upload speedtest\n[d] Toggle download speedtest"
	echo -e "[0] Toggle speedtest looping"
	echo -e "[-] Enter delay between speedtest loops\n"
	echo -e "[n] Download new copy of speedtest.py"

	echo -e "[r] Run speedtest.py"
	echo -e "[.] Quit"
	read -p "Enter selection: " choice
	if [[ "$choice" == "" ]]; then
		main
	fi
	if [[ "$choice" == "." ]]; then
		exit 1
	fi
	if [[ "$choice" == "u" ]]; then
		if [[ "$upload_status" == "ON" ]]; then
			upload_status="OFF"
		else
		upload_status="ON"
		fi
	fi
	if [[ "$choice" == "d" ]]; then
		if [[ "$download_status" == "ON" ]]; then
			download_status="OFF"
		else
		download_status="ON"
		fi
	fi
	if [[ "$choice" == "0" ]]; then
		if [[ "$loop_status" == "ON" ]]; then
			loop_status="OFF"
		else
		loop_status="ON"
		fi
	fi
	if [[ "$choice" == "n" ]]; then
		newspeedtest
		main
	fi
	if [[ "$choice" == "-" ]]; then
		read -p "Enter number of seconds to pause before looping [default 5]: " choice
		if [[ "$choice" == "" ]]; then
			loopsleep="5"
			else
			loopsleep=$choice
		fi
	fi
	if [[ "$choice" == "r" ]]; then
		speedloop
		main
	fi
main
}

upload_status="ON"
download_status="ON"
loop_status="OFF"
loopsleep="5" #default time in seconds to pause before running speedtest.py again
main
