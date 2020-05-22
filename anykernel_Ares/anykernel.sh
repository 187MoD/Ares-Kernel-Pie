#
# Ares-Kernel (AnyKernel 3) Script
#
# Credits: osm0sis@xda-developers
#
# Modified by The~Skater~187@xda-developers.com
#
# Repacked to AnyKernel3 by SmgKhOaRn@xda-developers.com
#

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Ares Kernel by The~Skater~187@xda-developers.com  Repacked to anykernel3 by SmgKhOaRn@xda-developers.com
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=kltexx
device.name2=kltelra
device.name3=kltetmo
device.name4=kltecan
device.name5=klteatt
device.name6=klteub
device.name7=klteacg
device.name8=klte
device.name9=kltekor
device.name10=klteskt
device.name11=kltektt
device.name12=kltelgt
device.name13=kltejpn
device.name14=kltekdi
device.name15=
'; } # end properties

# Shell variables
block=/dev/block/platform/msm_sdcc.1/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
. tools/ak3-core.sh;


## AnyKernel file attributes
# Set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;
chmod 775 $ramdisk/sbin
chmod 755 $ramdisk/sbin/busybox

## AnyKernel install
dump_boot;

# Check Android version
ui_print " ";
ui_print "Checking android version...";
android_sdk=$(cat /system/build.prop | grep ro.build.version.sdk | cut -d "=" -f 2)
ui_print " ";

if [ "$android_sdk" < 24 ]; then 
  android_ver="4.4 or 5.0 or 5.1 or 6.0"
fi;

if [ "$android_sdk" == 24 ]; then 
  android_ver="7.0";
fi;

if [ "$android_sdk" == 25 ]; then 
  android_ver="7.1";
fi;

if [ "$android_sdk" == 26 ]; then 
  android_ver="8.0";
fi;

if [ "$android_sdk" == 27 ]; then 
  android_ver="8.1";
fi;

if [ "$android_sdk" == 28 ]; then 
  android_ver="9.0";
fi;

if [ "$android_sdk" == 29 ]; then 
  android_ver="10";
fi; 
ui_print "Android $android_ver detected...";
case "$android_sdk" in
26|27|28|29) support_status="supported";;
  *) support_status="unsupported";;
esac;
ui_print " ";
if [ ! "$support_status" == "supported" ]; then
  ui_print "This version of Ares-Kernel is only compatible with Android 8.0/8.1/9.0/10!";
  exit 1;
fi;

# init.rc
backup_file init.rc;
grep "import /init.Ares.rc" init.rc >/dev/null || sed -i '1,/.*import.*/s/.*import.*/import \/init.Ares.rc\n&/' init.rc

# init.qcom.rc
backup_file init.qcom.rc;
remove_line init.qcom.rc "start mpdecision";
insert_line init.qcom.rc "u:r:supersu:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:supersu:s0 root root -- /init.Ares.sh"
insert_line init.qcom.rc "u:r:magisk:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:magisk:s0 root root -- /init.Ares.sh"
insert_line init.qcom.rc "u:r:su:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:su:s0 root root -- /init.Ares.sh"
insert_line init.qcom.rc "u:r:init:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:init:s0 root root -- /init.Ares.sh"
insert_line init.qcom.rc "u:r:supersu:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:supersu:s0 root root -- /init.Ares.sh"
insert_line init.qcom.rc "root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:supersu:s0 root root -- /init.Ares.sh"
insert_line init.qcom.rc "Execute Ares boot script..." after "Post boot services" "    # Execute Ares boot script..."
replace_string init.qcom.rc "setprop sys.io.scheduler zen" "setprop sys.io.scheduler bfq" "setprop sys.io.scheduler zen";

write_boot;

## End install

