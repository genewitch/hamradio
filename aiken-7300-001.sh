#!/bin/bash

[ -z "${1}" ] && {
	echo Presets are
	echo 6wspr 6jt 30wspr 30jt 80wspr 80jt
	echo 6 10 30 40 80 80s 160
	exit 1
}

freq() {
	CFREQ=$(echo f | rigctl -m 2 | awk '/Frequency/ {print $2}')
	[ ${1} -eq ${CFREQ} ] || {
		echo F ${FREQ} | rigctl -m 2
	}
}

mode() {
	MODE=$(echo m | rigctl -m 2 | awk '/Mode/ {print $2}')
	[ "${MODE}" == "${1}" ] || {
		echo M ${1} ${2} | rigctl -m 2
	}
}

preamp() {
	PREAMP=$(echo l PREAMP | rigctl -m 2 | awk '/Level/ {print $3}')
	[ "${PREAMP}" == "${1}" ] || {
		echo L PREAMP ${1} | rigctl -m 2
	}
}

agc() {
	AGC=$(echo l AGC | rigctl -m 2 | awk '/Level/ {print $3}')
	[ "${AGC}" == "${1}" ] || {
		echo L AGC ${1} | rigctl -m 2
	}
}

# the power fucntion needs work

power() {
	RF=$(echo l RFPOWER | rigctl -m 2 | awk '/Level/ {print int($3*1000)}')
	[ "${1}" == "100" -a "${RF}" == "1000" ] && return
	[ "${1}" == "10" -a "${RF}" == "101" ] && return
	[ "${1}" == "25" -a "${RF}" == "301" ] && return
	[ "${1}" == "5" -a "${RF}" == "82" ] && return

	RF="1"
	[ "${1}" == "10" ] && RF="0.102"
	[ "${1}" == "25" ] && RF="0.302"
	[ "${1}" == "5" ] && RF="0.083"
	
	echo L RFPOWER ${RF} | rigctl -m 2
}

FREQ=$(echo ${1} | awk '{print $1 * 1000000}')

MODE="AM 9000"
PREAMP="0"
AGC="3"
POWER=100

[ "${1}" == "6" ] && {
	FREQ="50110000"
}
[ "${1}" == "10" ] && {
	FREQ="28490000"
}
[ "${1}" == "30" ] && {
	FREQ="10120000"
}
[ "${1}" == "40" ] && {
	FREQ="7068000"
}
[ "${1}" == "80" ] && {
	FREQ="3650000"
}
[ "${1}" == "80s" ] && {
	FREQ="3655000"
}
[ "${1}" == "160" ] && {
	FREQ="1848000"
}

[ ${FREQ} -ge 1800000 -a ${FREQ} -lt 1890000 ] && {
	MODE="LSB 3000"
}
[ ${FREQ} -ge 3500000 -a ${FREQ} -lt 4000000 ] && {
	MODE="LSB 3000"
}
[ ${FREQ} -ge 7000000 -a ${FREQ} -lt 7300000 ] && {
	MODE="LSB 3000"
}
[ ${FREQ} -ge 9999000 -a ${FREQ} -lt 10138000 ] && {
	MODE="USB 3000"
}
[ ${FREQ} -ge 14000000 ] && {
	PREAMP="2"
}
[ ${FREQ} -ge 14000000 -a ${FREQ} -lt 14350000 ] && {
	MODE="USB 3000"
}
[ ${FREQ} -ge 28000000 -a ${FREQ} -lt 29000000 ] && {
	MODE="USB 3000"
}
[ ${FREQ} -ge 50000000 -a ${FREQ} -lt 50300000 ] && {
	MODE="USB 3000"
}

[ "${1}" == "6wspr" ] && {
	FREQ="50293000"
	MODE="PKTUSB 3000"
	PREAMP="2"
	AGC="5"
	POWER=5
}

[ "${1}" == "6jt" ] && {
	FREQ="50276000"
	MODE="PKTUSB 3000"
	PREAMP="2"
	AGC="5"
	POWER=25
}

[ "${1}" == "30wspr" ] && {
	FREQ="10138700"
	MODE="PKTUSB 3000"
	PREAMP="1"
	AGC="5"
	POWER=5
}

[ "${1}" == "30jt" ] && {
	FREQ="10138000"
	MODE="PKTUSB 3000"
	PREAMP="1"
	AGC="5"
	POWER=25
}

[ "${1}" == "80wspr" ] && {
	FREQ="3592600"
	MODE="PKTUSB 3000"
	PREAMP="1"
	AGC="5"
	POWER=5
}

[ "${1}" == "80jt" ] && {
	FREQ="3576000"
	MODE="PKTUSB 3000"
	PREAMP="1"
	AGC="6"
	POWER=25
}


freq ${FREQ}
mode ${MODE}
preamp ${PREAMP}
agc ${AGC}
power ${POWER}
