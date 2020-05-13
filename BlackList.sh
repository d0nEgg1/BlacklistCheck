#!/bin/bash

#################################################################################
################### FREE - BlackList Check v0.1 - under GPLv3 ###################
#################################################################################

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

#Check if a folder exists and create otherwise.
#if ! [ -d "./inputs/temp" ]; then
#	mkdir ./inputs/temp
#fi


############################
### Integrated functions ###
############################

#. libraries/


###############################
### EXAMPLE TOOL USAGE TEXT ###
###############################

funcHelp() {
	echo "MX Record and Blacklist Checker"
	echo "GPLv3)"
	echo "Use only with legal authorization and at your own risk!"
	echo "ANY LIABILITY WILL BE REJECTED!"
	echo "***********************************************************"
	echo "Usage: "
}


###############################
### GETOPTS - TOOL OPTIONS  ###
###############################

while getopts "d:hb" opt; do
	case ${opt} in
        	h) funcHelp; exit 1;;
		d) _DOMAIN="$OPTARG"; _CHECKARG1=1;;
		b) funcBlacklist; exit 1;;
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


###############
### COLORS  ###
###############

#Colors directly in the script.
#if [[ ${_COLORS} -eq 1 ]]; then
#	cOFF=''
#	rON=''
#	gON=''
#	yON=''
#else
#	cOFF='\e[39m'	  #color OFF / Default color
#	rON='\e[31m'	  #red color ON
#	gON='\e[32m'	  #green color ON
#	yON='\e[33m'	  #yellow color ON
#fi


#As color library.
#. colors.sh


############################
#### your cool functions ###
############################

# My function for ...
# Naming convention for functions funcFunctionname() - z.B. funcMycheck()

funcMXspf(){
	local _domain=${1}
        dig +noall +answer +short mx ${_domain} | cut -d " " -f2
        dig +noall +answer +short txt ${_domain} | grep -i  spf
}



############
### MAIN ###
############

echo ""
echo "####################################"
echo "####  Blacklist Checker GPLv3	####"
echo "####  Group1 HFI3913		####"
echo "####################################"
echo ""

if [ "${_CHECKARG1}" == "1" ]; then        #For one argument
	funcMXspf $_DOMAIN
	echo ""
fi

################### END ###################
