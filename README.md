extract-vendor-image
====================

<div id="screenshots" align="center">
<img src="https://github.com/BenSartor/extract-vendor-image/raw/readme/screenshot-vendor-image-warning.png" alt="Screenshot vendor image mismatch" text-align="center" width="400">
</div>

After upgrading my Nexus 5x to a new [lineageos](https://lineageos.org/) version it may sometimes show me a warning complaining about a vendor image mismatch.
In order to fix this, one has to download the right factory aosp image from [google](https://developers.google.com/android/images), extract the ```vendor.img``` file and flash it.
This bash script automates this process.
```
./extract-vendor-image.sh opm6.171019.030.h1
```
Use the vendor image id presented in the warning as parameter.

After succeeding the script will present you the commands to flash the extracted images on your phone.
```
adb reboot bootloader
fastboot flash radio vendor-image-bullhead-opm6.171019.030.h1/radio-bullhead-m8994f-2.6.41.5.01.img
fastboot flash bootloader vendor-image-bullhead-opm6.171019.030.h1/bootloader-bullhead-bhz31b.img
fastboot flash vendor vendor-image-bullhead-opm6.171019.030.h1/vendor.img
```

### Other devices
Theoretically this script should work with Nexus and Pixel devices, too. E.g. for a Nexus 6p
```
DEVICE=angler ./extract-vendor-image.sh opm6.171019.030.h1
```
But as I do not own one, I cannot test it :)

Of course the good old Nexus 5 and other older devices do not need this.
