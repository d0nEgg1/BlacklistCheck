#!/bin/bash

# Gruppe1 - Mike, Joel, Matthias, Luca <NR>
# Basic Script to Check MX/SPF Record of any given domain or/and if the given domain is on a blacklist


#######################
### Preparing tasks ###
#######################

#Check root rights (sudo) before execution.
if [ $(id -u) -ne 0 ]; then
	echo "You need root rights (sudo)."
	exit
fi

#Check if a program is installed.
funcCheckProg() {
	local _program
	local _count
	local _i

	_program=(vi)
	for _i in "${_program[@]}"; do
		if [ -z $(command -v ${_i}) ]; then
			echo "${_i} is not installed."
			_count=1
		fi
	done

	if [[ ${_count} -eq 1 ]]; then
		exit
	fi
}


funcCheckProg

#Read current date and time in hours and minutes into variable.
_TIME=$(date +%d.%m.%Y-%H:%M)

###############################
######  Basic Functions  ######
###############################

funcHelp() {
	echo ""
	echo "####################  HELP  ####################"
	echo "*********************************"
	echo "MX Record and Blacklist Checker"
	echo "GPLv3"
	echo "*********************************"
	echo ""
	echo "Usage: "
	echo "	./Blacklist.sh -d <DOMAIN> -b -> Blacklist Check"
	echo "	./Blacklist.sh -d <DOMAIN> -m -> MX and SPF Record Check"
	echo "	./Blacklist.sh -d <DOMAIN> -> ????"
	echo ""
	echo "####################  /HELP  ##################"
	echo ""
}


funcMXCheck(){
	local _domain=${_DOMAIN}
	echo "MX Record für $_domain:"
        dig +noall +answer +short mx ${_domain} | cut -d " " -f2
	echo "SPF Record für $_domain:"
        dig +noall +answer +short txt ${_domain} | grep -i  spf
}

funcBlacklist(){
	local _domain=${_DOMAIN}
	echo "hier sollte die Blacklist für $_domain gecheckt werden"
}

funcCheckAll(){
	local _domain=${_DOMAIN}
	echo "hier sollte Blacklist und MX für $_domain gecheckt werden"
}


###############################
### GETOPTS - TOOL OPTIONS  ###
###############################

while getopts "d:hbm" opt; do
	case ${opt} in
        	h) funcHelp; exit 1;;
		d) _DOMAIN="$OPTARG"; _CHECKARG1=1;;
		b) funcBlacklist; exit 1;;
		m) funcMXCheck; exit 1;;
		a) funcCheckAll; exti 1;;
		*) funcHelp; exit 1;;
  	esac
	done

#Check if _CHECKARG1 or/and _CHECKARG2 is set
if [ "${_CHECKARG1}" == "" ]; then
	echo "**No argument set**"
	echo ""
	funcHelp
	exit 1
fi

if [ "${_CHECKARG1}" == 1 ]; then
	funcMXCheck
	echo ""
fi


################### END ###################
