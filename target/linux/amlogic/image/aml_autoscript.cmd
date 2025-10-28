defenv
setenv bootcmd 'usb start; fatload usb 0 0x1000000 u-boot.ext && go 0x1000000; fatload usb 1 0x1000000 u-boot.ext && go 0x1000000; fatload mmc 1 0x1000000 u-boot.ext && go 0x1000000; run storeboot'
setenv system_part b
setenv upgrade_step 2
saveenv
sleep 1
reboot