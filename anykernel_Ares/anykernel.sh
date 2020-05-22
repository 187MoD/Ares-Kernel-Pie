#
# Ares-Kernel (AnyKernel) Script
#
# Credits: osm0sis @ xda-developers
#
# Modified by The~Skater~187@xda-developers.com
#
# Repacked to AnyKernel3 by @Blazko381 @ xda-developers.com
#

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Ares Kernel by The~Skater~187@xda-developers.com  Repacked to anykernel3 by @Blazko381
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

# shell variables
block=/dev/block/platform/msm_sdcc.1/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak3-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 755 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;

chmod 775 $ramdisk/sbin
chmod 755 $ramdisk/sbin/busybox

## AnyKernel install
dump_boot;

# Check Android version
ui_print " ";
ui_print "Checking android version...";
android_ver=$(file_getprop /system/build.prop "ro.build.version.release");
ui_print " ";
ui_print "Android $android_ver detected...";
case "$android_ver" in
7.1.1|8.1.0|9|10) support_status="supported";;
  *) support_status="unsupported";;
esac;
ui_print " ";
if [ ! "$support_status" == "supported" ]; then
  ui_print "This version of Ares-Kernel is only compatible with android versions 7.1.2 & 8.1.0 & 9 & 10!";
  exit 1;
fi;

dump_boot;

# begin ramdisk changes

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

mount -o rw,remount /system
mount -o rw,remount /system_root

if [ -d /system_root ]; then
 ui_print "Android 10+ detected! System-On-Root";
 cp sbin/busybox /system_root/sbin
 chmod 755 /system_root/sbin/busybox
fi;

backup_file sysinit;
backup_file init_d.rc;
replace_file /system/etc/init/init_d.rc 755 init_d.rc
replace_file /system/bin/sysinit 755 aressysinit
# end ramdisk changes

write_boot;

## end install

