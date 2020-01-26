#!/bin/bash 

newspeedtest(){
rm ./speedtest.py 2>&1 /dev/null
wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py 
}

speedloop(){
echo "---------------------------------------------------"
	python speedtest.py --no-download --no-upload
echo "---------------------------------------------------" 
	sleep $loopsleep
speedloop
}

main(){
	echo -e "[1] Download new copy of speedtest.py"
	echo -e "[2] Disable speedtest --no-upload and --no-download error in speedtest.py"
	echo -e "[3] Re-enable speedtest --no-upload and --no-download error in speedtest.py"
	echo -e "[4] Run speedtest.py in a loop"
	echo -e "[.] Quit"
	read -p "Enter selection: " choice
	if [[ "$choice" == "" ]]; then
		main
	fi
	if [[ "$choice" == "." ]]; then
		exit 1
	fi
	if [[ "$choice" == "1" ]]; then
		newspeedtest
		main
	fi
	if [[ "$choice" == "2" ]]; then
		sed -i 's/    if not args.download and not args.upload:/    #if not args.download and not args.upload:/g' speedtest.py
		sed -i 's/        raise SpeedtestCLIError('"'"'Cannot supply both --no-download and '"'"'/        #raise SpeedtestCLIError('"'"'Cannot supply both --no-download and '"'"'/g' speedtest.py
		sed -i 's/                                '"'"'--no-upload'"'"')/                                #'"'"'--no-upload'"'"')/g' speedtest.py
		main
	fi
	if [[ "$choice" == "3" ]]; then
		sed -i 's/    #if not args.download and not args.upload:/    if not args.download and not args.upload:/g' speedtest.py
		sed -i 's/        #raise SpeedtestCLIError('"'"'Cannot supply both --no-download and '"'"'/        raise SpeedtestCLIError('"'"'Cannot supply both --no-download and '"'"'/g' speedtest.py
		sed -i 's/                                #'"'"'--no-upload'"'"')/                                '"'"'--no-upload'"'"')/g' speedtest.py
		main
	fi
	if [[ "$choice" == "4" ]]; then
		read -p "Enter number of seconds to pause before looping [default 5]: " choice
		if [[ "$choice" == "" ]]; then
			loopsleep="5"
		fi
		speedloop
		main
	fi
main
}

loopsleep="5" #default time in seconds to pause before running speedtest.py again
main
