# Notes on BunsenLabs Boron Setup

On a ThinkPad X1 Yoga Gen 2.

## fresh installation

### welcome script

After new installation, the welcome script is automatically started. It can
 also be done later manually, running the command `bl-welcome`.

#### firmware update check

- install the package `isenkram-cli`
- can later manually be run as well
  - `sudo isenkram-autoinstall-firmware`
- throws some unresolved errors (at least) for wifi firmware
  - wifi works flawlessly though
  - intel firmware package is automatically installed

### observations

- almost instantly ready and idle
- important thinkpad function keys are working
  - `F1` to `F3` correctly control audio (xfce audio applet **must** run)
  - `F4` mute does not work but LED works when mic is muted in audio applet
  - brightness control `F5` & `F6` work
  - monitor modes `F7` don't work
  - `F8` toggles flight mode correctly
  - `F9` does nothing
  - `F10` seems to toggle bluetooth correctly
  - `F11` & `F12` do nothing
- trackpoint, nav keys and touchpad generally work
  - multitouch gestures are missing
  - natural scroll doesn't work
  - palm recognition doesn't work
- touchscreen works with fingers and pen
- default debian DE keyboard is *with* deadkeys
- menu can be navigated with keyboard
- system time comes with default linux UTC offset
- external monitors work *after* setting them up in xrandr with `arandr` gui
  - but unplugging a monitor still keeps it *active*
  - external screens have to be deactivated manually
  - plugging in a different monitor keeps the old settings alive
  - need to close connection in `arandr` (messes up winow positions)
  - windows seem to get alinged left to right (no matter what screen is primary)

## fixes and configuration

### change system time settings

Linux reads the UEFI system time differently than windows.
 Windows interprets system time as local time, Linux as UTC.
 Linux then uses an offset to set the operating system time.
 This overwrites the systemtime in UEFI and causes wrong system time
 when dual booting with Windows.

- use `timedatectl` to check time setting in linux
- use `timedatectl set-local-rtc 1 --adjust-system-clock` to set system as local
  - linux will *complain* with a recommendation

### change xflc power manager settings

Take care of default behaviour for

- closing lid
- standby
- dimming
- and similar things.

 Use the applet in the tray. Also use cli commands to ensure lid behavior
 (*see multi monitor setup*)

### fix keyboard (no dead keys)

Current configuration can be read from `/etc/default/keyboard`.
 Check `man 5 keyboard` for more information.

```sh
sudo dpkg-reconfigure keyboard-configuration
setupcon
sudo update-initramfs -u
```

### change touchpad driver to `libinput`

The `synaptics` driver is old, deprecated and not upgraded for modern touchpads.
 This mostly affects palm detection, because the driver cannot interpret
 information reported by the touchpad correctly.

Another possible explanation is, that the modern linux kernel does not extract
 the correct event from the touchpad firmware in the first place,
 so it cannot be reported to the synaptics driver.

Bunsenlabs Boron comes with synaptics driver and configurations preinstalled.
 Those need to be removed. The modern driver `libinput` is installed by default
 and only needs some additional configuration afterwards.
 Palm detection works out of the box.
 Reading [arch wiki](https://wiki.archlinux.org/title/Libinput) on `libinput`
 is highly recommended. Another nice guide can be found
 [here](https://smarttech101.com/libinput-fix-your-linux-touchpad-using-libinput)

- read basic information about the input devices and its properties
  - `xinput --list` then select the ID for the touchpad
  - `xinput list-props <ID>` get a list of properties for `libinput`
- remove `synaptics` driver: `sudo apt purge xserver-xorg-input-synaptics`
  - removes default `70-synaptics.conf` file automatically
  - remove any custom ones manually
- check default ***X11*** configuration files
  - `ls /usr/share/X11/xorg.conf.d` should **not** contain
 `70-synaptics.conf` file anymore
  - check for existence of `40-libinput.conf`
    - should be there
    - check contents for active touchpad (Identifier touchpad)
  - `sudo rm /usr/share/X11/xorg.conf.d/70-synaptics.conf`
  - `sudo rm /etc/X11/xorg.conf.d/70-synaptics.conf`
- remove from **bunsenlab autostart**
  - open `Menu > User Settings > BunsenLabs session > Edit autostart`
  - locate segment ***TOUCHPAD*** probably around line 62
  - comment out the active lines regarding `synclient`  and `syndaemon`
  - per default there are two active entries
- customizing `libinput`
  - temporary test with `xinput set-prop <ID> <propID> value value...`
    - see above for `<ID>` and `<propID>`
  - create a new libinput.conf file in /etc/X11/xorg.conf.d
  - follow the comments in default one and strip it down to bare essentials
  - for me `Option "Name" "value"`:
    - "Tapping" "on"
    - "NaturalScrolling" "true"
    - "AccelSpeed" "0.400000"

### power optimization

Take advantage of good tools out there to finetune powersettings
 and identify strange behaviour in apps.
 Read [tlp doc](https://linrunner.de/tlp) and info on combining `tlp` and
  `powertop` [here](httpw://linrunner.de/tlp/faq/powertop.html).
 You can check wakeup time (`powertop`), I/O activity (`iostat`),
 CPU load (`htop`), and even trace systemcall (`strace`) to identify
 actively working applications.

- install the neccessary tools
  - `sudo apt install powertop tlp iotop strace`
- take advantage of the custom config files for `tlp` in `/etc/tlp.d`
  - create custom files in there, need to end in `.conf`
  - my files are provided and customized to my needs and hardware
    - *01-service.conf*, *02-cpu.conf* and *03-devices.conf*
    - validate your `DISK_DEVICES` in *03-devices.conf*
    - also I allowed usb autosuspend for the wacom touch device
- run `tlp` with `sudo tlp start`
  - follow instructions, if something is not running
- check various system settings and applied configuration
  - run `sudo tlp-stat`
  - output can be limited by using flags like `-b` for battery
- run power widh `sudo powertop` and check tunables
  - all settings there should be covered by my `tlp` configuration
    - there will be an issue with `VM_writeback_time` from my template file
    - consider activating other remaining one(s)
  - when on battery, run `sudo powertop --configure`
  - issue with `tcp` and `powertop` and `VM_writeback_time`
    - `powertop` insists on 1500 centisecs (15s) for *good* value
    - `tlp` uses 15s per default for AC (`MAX_LOST_WORK_SEC_ON_AC`)
    - `tlp` uses 60s per default for battery
    - this 60s will trigger a *bad* flag in `powertop` on battery
- read current battery discharge level
  - in microwatt: `cat /sys/class/power_supply/BAT0/power_now`
  - in watt:
    - custom shell function to print the power consumption
     every X seconds to terminal
    - add following lines to your `.bashrc`, `.zshrc` or other shell config
    - then you can simply run `power` or `power <seconds>` in your terminal

```sh
power()  {
	local interval="${1:-1}" # Defaults to 1 if no argument given
	while true; do
		awk '{printf "battery usage: %.2f W\n", $1 / 1000000}'\
			/sys/class/power_supply/BAT0/power_now
		sleep "$interval"
	done
}
```

I also turned off some starting apps, but I didn't track on whether or not I
 deleted them from the *autostart* script in `/.config/bunsen/autostart`:
 They are at least `picom` (compositor), `blueman-applet` and `conky`.

### multi monitor setup

I want to automatically detect when a monitor is plugged in, unplugged or the
 lid is closed and that the monitors are setup automatically. A special case is
 booting with the lid closed.

The program `autorandr` offers automatic switching between different configured
 monitor profiles, when a monitor is connected **after** login. That means, you
 still need to setup your monitors manually once. Simply follow the instructions
 on its [github page](https://github.com/phillipberndt/autorandr). What it
 cannot do is handle inital setup when the lid is closed due `xinit` starting
 *after* `logind` (login screen).

- my files are available in directory *monitor*
- install tool `sudo apt install autorandr`
- plug in and setup your monitors (internal and external)
  - follow the developers instructions
  - un-/plugging monintor should already work after that step
- add configuration for lid open/close functionality (ChatGPT helped with that)
  - overwrite lid status during `logind` phase
    - copy `HandleLid.conf` to `/etc/systemd/logind.conf.d`
    - sets all *HandleLidSwitch...* to ignore
  - handle monitor & lid setup *after* login
    - copy `.xinitrc` in your home directory
    - make sure it is executable; else use `chmod +x .xinitrc` at its location
  - handle monitor & lid setup *at* login
    - also create a similar script for the login manager (optional)
      - copy `90-monitor.conf` to `/etc/lightdm/lightdm.conf.d/90-monitor.conf`
      - copy `display-setup.sh` to `/etc/lightdm/display-setup.sh`
      - make sure the script `.sh` is executable
  - **script adjustments** for `.xinitrx` and `display-setup.sh`
    - logging is commented out
      - has a path hardcoded
      - you need to **change** `<user>` if you want to use logging
    - **verify** what is your correct internal and external screen
      - see your currently connected displays with:
      `xrandr --query | grep " connected" | awk '{print $1}'`
      - replace values for `EXTERNAL_OUTPUT` and `INTERNAL_OUTPUT` if needed
    - last `xrandr` line uses my dual monitor layout with
    `--above $INTERNAL_OUTPUT`

Multi monitor setup with displays *stacked on top of each* other can be tricky.
 I use an UWFHD monitor combined with the laptops FHD screen below.
 This creates a problem with the openbox workarea (eg. breaks window tiling),
 when the *taskbar* is aligned *on top* of the screen. So far I could only
 **fix** this by showing one taskbar at the bottom of the laptop screen.
 Alternativly having screens next to each other also seems to fix it.

- openbox workarea can be checked with: `xprop -root | grep _NET_WORKAREA`
