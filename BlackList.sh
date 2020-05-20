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

	_program=(vi jq)
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
	echo ""
	echo "*********************************"
	echo "MX Record and Blacklist Checker"
	echo "GPLv3"
	echo "*********************************"
	echo ""
	echo "Usage: "
	echo "	./Blacklist.sh -d <DOMAIN> -b -> Blacklist Check"
	echo "	./Blacklist.sh -d <DOMAIN> -m -> MX and SPF Record Check"
	echo "	./Blacklist.sh -d <DOMAIN> -a -> Blacklist and MX Record Check combined"
	echo ""
	echo "####################  /HELP  ##################"
	echo ""
}


funcMXCheck(){
	local _domain=${_DOMAIN}
	local _mxrecord=`dig +noall +answer +short mx ${_domain} | cut -d " " -f2`
	echo "*********************************************************"
	echo "MX Record für $_domain:"
        dig +noall +answer +short mx ${_domain} | cut -d " " -f2
	echo ""
	echo "*********************************************************"
	echo "IP für $_mxrecord:"
	dig +noall +answer +short ${_mxrecord}
	echo ""
	echo "*********************************************************"
	echo "SPF Record für $_domain:"
        dig +noall +answer +short txt ${_domain} | grep -i spf
	echo ""
}

funcBlacklist(){
	local _domain=${_DOMAIN}
	local _mxrecord=`dig +noall +answer +short mx ${_domain} | cut -d " " -f2`
	local _i
	local _red="\033[1;31m"
	local _green="\033[1;32m"
	local _nocolor="\033[0m"
	#local _ip=`dig +noall +answer +short ${_mxrecord}`
	dig +noall +answer +short ${_mxrecord} > ip.tmp
	read -d '' -a _ip < ip.tmp
	
	if [ "${#_ip[*]}" -gt 1 ]; then
		for ((_i=0; _i<${#_ip[*]}; _i++))
		do
			_result=$(wget -q -O- --post-data="host=${_ip[$_i]}" https://urlhaus-api.abuse.ch/v1/host/)
			_resultFormat=$(echo ${_result} | jq '.query_status')
			if [ "${_resultFormat}" == "\"no_results\"" ]; then
				echo "*********************************************************"
				echo "Query-Resultat für ${_domain} / ${_ip[$_i]}"
				echo -e "${_green}OK${_nocolor}"
				echo ""
			else
				echo "*********************************************************"
				echo "Query-Resultat für ${_domain} / ${_ip[$_i]}"
				echo -e "${_red}NOK!${_nocolor}"
				echo ""
			fi
		done
	else
		echo "MX Record nicht RFC XXX konform"
	fi
	#DEBUG
	#_resultDEBUGG=$(wget -q -O- --post-data="host=${_mxrecord}" https://urlhaus-api.abuse.ch/v1/host/)
	#echo ${_resultDEBUGG}
}

funcCheckAll(){
	local _domain=${_DOMAIN}
	funcMXCheck
	funcBlacklist
}


###############################
### GETOPTS - TOOL OPTIONS  ###
###############################

while getopts "d:hbma" opt; do
	case ${opt} in
        	h) funcHelp; exit 1;;
		d) _DOMAIN="$OPTARG"; _CHECKARG1=1;;
		b) funcBlacklist; exit 1;;
		m) funcMXCheck; exit 1;;
		a) funcCheckAll; exit 1;;
		*) funcHelp; exit 1;;
  	esac
	done

#Check if _CHECKARG1 is set
if [ "${_CHECKARG1}" == "" ]; then
	echo ""
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
