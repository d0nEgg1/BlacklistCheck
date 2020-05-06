#!/bin/bash

#################################################################################
################### FREE - BlackList Check v0.1 - under GPLv3 ###################
#################################################################################

##########################################################
#  INFORMATIONS                                          #
#   Group 1	                                         #
##########################################################

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

	_program=(python3 vi emacs)
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

#Check if a program is installed via an input file.
funcCheckProg() {
	local _program
	local _proginst
	local _count
	local _line

	while read _line
	do
		_program=$(echo "${_line}" | awk -F ';;' '{print $1}')
		_proginst=$(echo "${_line}" | awk -F ';;' '{print $2}')

		if [ -z $(command -v ${_program}) ]; then
			echo "${_program} is not installed. Installation: ${_proginst}"
			_count=1
		fi

	done <./commandcheck.txt

	if [[ ${_count} -eq 1 ]]; then
		exit
	fi
}

funcCheckProg

#Read current date and time in hours and minutes into variable.
_TIME=$(date +%d.%m.%Y-%H:%M)

#Check if a folder exists and create otherwise.
if ! [ -d "./inputs/temp" ]; then
	mkdir ./inputs/temp
fi


############################
### Integrated functions ###
############################

#. libraries/


###############################
### EXAMPLE TOOL USAGE TEXT ###
###############################

funcHelp() {
	echo "From the Free OCSAF project"
	echo "Free OCSAF SKELETON 0.4 - GPLv3 (https://freecybersecurity.org)"
	echo "Use only with legal authorization and at your own risk!"
	echo "ANY LIABILITY WILL BE REJECTED!"
	echo ""
}


###############################
### GETOPTS - TOOL OPTIONS  ###
###############################

while getopts "d:l:hc" opt; do
	case ${opt} in
        	h) funcHelp; exit 1;;
		d) _VALUE="$OPTARG"; _CHECKARG1=1;;
		l) _LIST="$OPTARG"; _CHECKARG2=1;;
		c) _COLORS=1;;
		\?) echo "**Unknown option**" >&2; echo ""; funcHelp; exit 1;;
        	:) echo "**Missing option argument**" >&2; echo ""; funcHelp; exit 1;;
		*) funcHelp; exit 1;;
  	esac
	done
    	shift $(( OPTIND - 1 ))

#Check if _CHECKARG1 or/and _CHECKARG2 is set
if [ "${_CHECKARG1}" == "" ] && [ "${_CHECKARG2}" == "" ]; then
	echo "**No argument set**"
	echo ""
	funcHelp
	exit 1
fi


###############
### COLORS  ###
###############

#Colors directly in the script.
if [[ ${_COLORS} -eq 1 ]]; then
	cOFF=''
	rON=''
	gON=''
	yON=''
else
	cOFF='\e[39m'	  #color OFF / Default color
	rON='\e[31m'	  #red color ON
	gON='\e[32m'	  #green color ON
	yON='\e[33m'	  #yellow color ON
fi


#As color library.
. colors.sh


############################
#### your cool functions ###
############################

# My function for ...
# Naming convention for functions funcFunctionname() - z.B. funcMycheck()

funcMyFunction() {

}


############
### MAIN ###
############

echo ""
echo "##########################################"
echo "####  FREE OCSAF BASH SKELETON GPLv3  ####"
echo "####  https://freecybersecurity.org   ####"
echo "##########################################"
echo ""

if [ "${_CHECKARG1}" == "1" ]; then        #For one argument
	funcMyFunction
	echo ""
elif [ "${_CHECKARG2}" == "1" ]; then      #For a list of arguments
	while read _line
	do
		funcMyFunction
		unset _line
	done <${_LIST}
	echo ""
fi

################### END ###################
