#!/bin/bash
#
# Copyright (C) 2011 - 2015 Rafael PacMe (ROM-PacMe)
# Copyright (C) 2014 - 2015 MaxiCM Team
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

# How To Use This Script
	usage () {
		echo "         Usage:"
		echo "maxi.sh [Option] (device)"
		echo ""
		echo "         Options:"
		echo ""
		echo "--------------------------------------------------------------"
		echo "  PD: ONE AND MORE OPTIONS ARE NOT AVARIABLE FOR THIS MOMENT"
		echo "--------------------------------------------------------------"
		echo ""
		echo "  -a: Disable ADB authentication and set root access to Apps and ADB"
		echo "  -c#: Cleaning options before your build:"
		echo "       1 - Run make clean"
	    echo "       2 - Run make installclean"
	    echo "  -d: Build ROM without ccache"
	    echo "  -e#: Extra build output options:"
	    echo "       1 - Verbose build output"
	    echo "       2 - Quiet build output"
	    echo "  -f: Fetch extras"
	    echo "  -i: Ignore minor error during build"
	    echo "  -j# set number of jobs"
	    echo "  -w#: Log file options"
	    echo "       1 - Send warnings and errors to a log file"
	    echo "       2 - Send all output to a log file"
	    echo "  -s: Repo sync"
	    echo ""
	    echo "          Example:"
	    echo "     ./maxi.sh -c1 jagnm"
	    echo ""
	    echo ""
	}

#Find Out Directory
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
thisDIR="${PWD##*/}"

if [ -n "$OUT_DIR_COMMON_BASE+x" ]; then
	RES=1
else
	RES=0
fi

if [ $RES = 1 ]; then
	export OUTDIR=$OUT_DIR_COMMON_BASE/$thisDIR
	echo "external out directory is set to ($OUTDIR)"
	echo ""
elif [ RES = 0 ]; then
	export OUTDIR=$DIR/out
	echo "no external out, using default ($OUTDIR)"
	echo ""
else
	echo "NULL"
	echo "error, wrong results! blame the split screen!"
	echo ""
fi

opt_adb=0
opt_clean=0
opt_ccache=0
opt_extra=0
opt_fetch=0
opt_jobs="$CPUS"
opt_kr=0
opt_ignore=0
opt_lrd=0
opt_only=0
opt_reset=0
opt_sync=0
opt_twrp=0
opt_log=0
opt_sob=0

while getopts "ac:de:fij:klo:rs:twx:" opt; do
    case "$opt" in
    a) opt_adb=1 ;;
    c) opt_clean="$OPTARG" ;;
    d) opt_ccache=1 ;;
    e) opt_extra="$OPTARG" ;;
    f) opt_fetch=1 ;;
    i) opt_ignore=1 ;;
    j) opt_jobs="$OPTARG" ;;
    k) opt_kr=1 ;;
    l) opt_lrd=1 ;;
    o) opt_only="$OPTARG" ;;
    r) opt_reset=1 ;;
    s) opt_sync="$OPTARG" ;;
    t) opt_twrp=1 ;;
    w) opt_log="$OPTARG" ;;
    x) opt_sob=1 ;;
    *) usage
    esac
done

shift $((OPTIND-1))
if [ "$#" -ne 1 ]; then
    usage
fi
device="$1"

#check android build tree
if [ ! -d ".repo" ]; then
	echo "no .repo directory found. is this a Android build tree?"
	exit 1
fi

# ccache options
if [ "$opt_ccache" -eq 1 ]; then
    echo "ccache not be used in this build"
    unset USE_CCACHE
    echo ""
fi

#Use ccache
if [ -z "${USE_CCACHE}"]; then
	export USE_CCACHE=1
fi

#clean out
if [ "$opt_clean" -eq 1 ]; then
	echo "cleaning output directory..."
	make clean >/dev/null
	echo "output directory is: Clean"
	echo ""
elif [ "$opt_clean" -eq 2 ]; then
	. build/envsetup.sh
	lunch "maxi_$device-userdebug"
	make installclean >/dev/null
	echo "output directory is: Dirty"
	echo ""
else
	if [ -d "$OUTDIR/target" ]; then
		echo "output directory is: Untouched"
		echo ""
	else
		echo "output directory is: Clean"
	fi
fi

#Get OS (Linux / Mac OS X)
IS_DARWIN=$(uname -a | grep Darwin)
if [ -n "$IS_DARWIN" ]; then
	CPUS=$(sysctl hw.ncpu | awk '{print $2}')
else
	CPUS=$(grep "^processor" /proc/cpuinfo -c)
fi

#lower RAM devices
if [ "$opt_lrd" -ne 0 ]; then
	echo "applying optimizations for devices with low RAM"
	export LOW_RAM_DEVICES=true
	echo ""
else
	unset LOW_RAM_DEVICES
fi

#set OFFICIAL build
if [ "$opt_sob" -ne 0 ]; then
	echo "setting OFFICIAL Build type"
	echo ""
	export MAXI_BUILDTYPE=OFFICIAL
fi

#setup building
echo "setting up enviroment..."
echo "----------------------------------------------------"
. build/envsetup.sh
echo "----------------------------------------------------"

#i will create a new build.prop bitch.... xD
rm -f "$OUTDIR"/target/product/"$device"/system/build.prop

#i will create a new version of MaxiKernel Bitch... xD
rm -f "$OUTDIR"/target/product/"$device"/obj/KERNEL_OBJ/.version

#launch device
echo ""
echo "launch Device:'$device'"
lunch maxi_$device-userdebug
echo ""

#start compilation
echo "----------------------------------------------------"
brunch $device
echo ""
echo ""
echo "   *                              *     "
echo " (  '                      (    (   '   "
echo " )\))(      )     )  (     )\   )\))(   "
echo "((_)()\  ( /(  ( /(  )\  (((_) ((_)()\  "
echo "(_()((_) )(_)) )\())((_) )\___ (_()((_) "
echo "|  \/  |((_)_ ((_)\  (_)((/ __||  \/  | "
echo "| |\/| |/ _' |\ \ /  | | | (__ | |\/| | "
echo "|_|  |_|\__,_|/_\_\  |_|  \___||_|  |_| "
echo ""
