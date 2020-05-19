#!/system/bin/sh

#
# Ares-Kernel Boot Script
# 
# Author: sunilpaulmathew <sunil.kde@gmail.com>
#

#
# This script is licensed under the terms of the GNU General Public 
# License version 2, as published by the Free Software Foundation, 
# and may be copied, distributed, and modified under those terms.
#

#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
#     ###################
#     #   ARES~Tweaks   #
#     #                 #
#     #     187~Mod     #
#     ###################


if [ "$(grep -c Ares-Kernel- /proc/version)" -eq "1" ]; then
    echo "Apply Ares-Kernel default settings..." | tee /dev/kmsg
	# Huge thanks to sultanxda and justjr @ xda-developers.com
	
	## Increase Z-RAM to 1GB
	# disable default zRam if configured
	if [ -f $DISABLE_DEFAULT_ZRAM ]; then
		busybox swapoff /dev/block/zram0
		echo "1" > /sys/block/zram0/reset
		busybox sync
	fi
	# setting zram size to liitle more than 1024MB(1073741824)
	echo 1073741830 > /sys/block/zram0/disksize
    #
    # making zram swapable
	busybox mkswap /dev/block/zram0
	/sbin/.magisk/busybox/mkswap /dev/block/zram0
	mkswap /dev/block/zram0
    #
    # starting swap on zram
	busybox swapon /dev/block/zram0
	/sbin/.magisk/busybox/swapon /dev/block/zram0
	swapon /dev/block/zram0
	#
	echo 70 > /proc/sys/vm/swappiness
	#
    # Thermal
     echo 1 >  /sys/module/msm_thermal/parameters/enabled
     echo 0 > /sys/module/msm_thermal/vdd_restriction/enabled
     echo 0 > /sys/module/msm_thermal/core_control/enabled
     echo 80 > /sys/module/msm_thermal/parameters/freq_mitig_temp_degc
     echo 90 > /sys/module/msm_thermal/parameters/core_temp_limit_degC
     echo 85 > /sys/module/msm_thermal/parameters/hotplug_temp_degC
    
    # Tweak Interactive CPU governor
     echo "20000 1190400:60000 1728000:74000 1958400:82000 2265600:120000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
     echo 99 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
     echo '1190400' > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
     echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
     echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
     echo "98 268800:28 300000:12 422400:34 652800:41 729600:12 883200:52 960000:9 1036800:8 1190400:73 1267200:6 1497600:87 1574400:5 1728000:89 1958400:91 2265600:94" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
     echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
     echo 80000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack
     
    # CPU Governor
     echo 0 > /sys/devices/system/cpu/sched_mc_power_savings
     
     ##Set to IntelliActive
     chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
     echo intelliactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
     chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
     echo intelliactive > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
     chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
     echo intelliactive > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
     chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
     echo intelliactive > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

     ##Set min CPU freq.
     chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
     echo 268800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
     chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
     echo 268800 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
     chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
     echo 268800 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
     chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
     echo 268800 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

     ##Set max CPU freq.
     chmod 644 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
     echo 2457600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
     chmod 644 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
     echo 2457600 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
     chmod 644 /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
     echo 2457600 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
     chmod 644 /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
     echo 2457600 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
     echo '1267200' > /sys/devices/system/cpu/cpufreq/intelliactive/hispeed_freq
     
    # CPU Hotplug
     echo 0 > /sys/kernel/alucard_hotplug/hotplug_enable
     echo 0 > /sys/class/misc/mako_hotplug_control/enabled
     echo 0 > /sys/module/intelli_plug/parameters/intelli_plug_active
     echo 1 > /sys/module/lazyplug/parameters/lazyplug_active
     echo 4 > /sys/module/lazyplug/parameters/nr_run_hysteresis
	 echo 6 > /sys/module/lazyplug/parameters/nr_run_profile_sel
	 echo 650 > /sys/module/lazyplug/parameters/cpu_nr_run_threshold
     echo 4 > /sys/module/lazyplug/parameters/nr_possible_cores
	 	 
    # GPU
     echo 'msm_cpufreq' > /sys/class/kgsl/kgsl-3d0/devfreq/governor
	 echo 27000000 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
	 echo 578000000 > /sys/class/kgsl/kgsl-3d0/max_gpuclk

    # Display and LED
     echo 0 > /sys/class/sec/led/led_fade

    # LMK
     echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
     chmod 666 /sys/module/lowmemorykiller/parameters/minfree
     chown root /sys/module/lowmemorykiller/parameters/minfree
     echo "10240,14336,18432,34816,47104,55296" > /sys/module/lowmemorykiller/parameters/minfree

    # VM
     echo 0 > /proc/sys/vm/oom_dump_tasks
     echo 10 > /proc/sys/vm/dirty_background_ratio
     echo 100 > /proc/sys/vm/vfs_cache_pressure
     echo 30 > /proc/sys/vm/dirty_ratio
     echo 0 > /proc/sys/vm/page-cluster

    # IO
     echo 1 > /sys/block/mmcblk0/queue/rq_affinity
     echo 0 > /sys/block/mmcblk0/queue/iostats
     echo 1024 > /sys/block/mmcblk0/queue/read_ahead_kb
     echo 512 > /sys/block/mmcblk0/queue/nr_requests
     echo 1 > /sys/block/mmcblk1/queue/rq_affinity
     echo 0 > /sys/block/mmcblk1/queue/iostats
     echo 1024 > /sys/block/mmcblk1/queue/read_ahead_kb
     echo 384 > /sys/block/mmcblk1/queue/nr_requests

    # Misc
     echo 2048 > /proc/sys/kernel/random/read_wakeup_threshold
     echo 2048 > /proc/sys/kernel/random/write_wakeup_threshold
     echo 0 > /sys/kernel/dyn_fsync/Dyn_fsync_active


    # The END
     echo "Everything done..." | tee /dev/kmsg
    fi
	
	