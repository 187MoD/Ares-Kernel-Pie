#
# Ares-Kernel (AnyKernel) Script
#
# Credits: osm0sis @ xda-developers
#
# Modified by The~Skater~187 @ xda-developers
#
# Repacked to AnyKernel3 by SmgKhOaRn @ xda-developers
#

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Ares Kernel by @The~Skater~187, repacked to AK3 by @SmgKhOaRn
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

chmod 775 $ramdisk/sbin;
chmod 755 $ramdisk/sbin/busybox;

## AnyKernel install
dump_boot;

# Check Android version
ui_print " ";

android_sdk=$(cat /system/build.prop | grep ro.build.version.sdk | cut -d "=" -f 2)
case "$android_sdk" in
26|27|28|29) support_status="supported";;
  *) support_status="unsupported";;
esac;

if [ "$support_status" == "supported" ]; then
	ui_print "Android 8.0/8.1/9.0/10 detected!";
else
 ui_print "This version of Ares-Kernel is only compatible with android versions 8 & 8.1 & 9 & 10!";
 exit 1;
fi;

dump_boot;

# begin ramdisk changes
mount -o rw,remount /system;
mount -o rw,remount /system_root;

# sysinit
backup_file /system/bin/sysinit;
backup_file /system/xbin/sysinit;
replace_file /system/bin/sysinit 755 aressysinit
replace_file /system/xbin/sysinit 755 aressysinit

# init.rc
backup_file init.rc;
grep "import /init.Ares.rc" init.rc >/dev/null || sed -i '1,/.*import.*/s/.*import.*/import \/init.Ares.rc\n&/' init.rc;

# init_d.rc
backup_file /system/etc/init/init_d.rc;
replace_file /system/etc/init/init_d.rc 755 init_d.rc

# init.qcom.rc
if [ -d /system_root ]; then
 ui_print "Use System-On-Root...";
 cp sbin/busybox /system_root/sbin
 chmod 755 /system_root/sbin/busybox
 backup_file /system/vendor/etc/init/hw/init.qcom.rc;
 remove_line /system/vendor/etc/init/hw/init.qcom.rc "start mpdecision";
 insert_line /system/vendor/etc/init/hw/init.qcom.rc "u:r:supersu:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:supersu:s0 root root -- /init.Ares.sh"
 insert_line /system/vendor/etc/init/hw/init.qcom.rc "u:r:magisk:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:magisk:s0 root root -- /init.Ares.sh"
 insert_line /system/vendor/etc/init/hw/init.qcom.rc "u:r:su:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:su:s0 root root -- /init.Ares.sh"
 insert_line /system/vendor/etc/init/hw/init.qcom.rc "u:r:init:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:init:s0 root root -- /init.Ares.sh"
 insert_line /system/vendor/etc/init/hw/init.qcom.rc "u:r:supersu:s0 root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:supersu:s0 root root -- /init.Ares.sh"
 insert_line /system/vendor/etc/init/hw/init.qcom.rc "root root -- /init.Ares.sh" after "Post boot services" "    exec u:r:supersu:s0 root root -- /init.Ares.sh"
 insert_line /system/vendor/etc/init/hw/init.qcom.rc "Execute Ares boot script..." after "Post boot services" "    # Execute Ares boot script..."
 replace_string /system/vendor/etc/init/hw/init.qcom.rc "setprop sys.io.scheduler zen" "setprop sys.io.scheduler bfq" "setprop sys.io.scheduler zen";
else
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
fi;

# end ramdisk changes
write_boot;

## end install
