#### legacy: synaptics ***deprecated***

- sources
  - [archlinux](https://wiki.archlinux.org/title/Touchpad_Synaptics)
  - [thelinuxcode-touchpad](https://thelinuxcode.com/enable-disable-touchpad-laptop-keyboard/)
  - [baeldung-touchpad](https://www.baeldung.com/linux/enable-disable-touchpad)
  - [baeldung-gestures](https://www.baeldung.com/linux/touchpad-gestures)
  - [important](https://howchoo.com/linux/the-perfect-almost-touchpad-settings-on-linux-2/)
- something is set in **autostart**
  - change `syndaemon` there
  - and remove `synclient` as well => add stuff to own config file
- **default config file** located in `/usr/share/X11/xorg.conf.d/70-synaptics.conf`
  - gets overwritten by distribution or program updates
  - create a **custom** file in: `/etc/X11/xorg.conf.d/`
- possible values can be found in `man 4 synaptics`
- there is useful CLI tool to test synaptics configuration: `synclient`
  - use `synclient -l` to see all possible options
  - using this only temporarilty changes settings
  - still need to store them in a file
- **palm detection** for synaptics has been brokern in the kernel since 2013
  - use **syndaemon** as a workaround instead
  - disable touchpad when keyboard is being used
  - per default it seems to run with `syndaemon -i .5 -K -t -R -d`
  - `syndaemon` is running but **not working**
- **natural scrolling** can be enabled
  - switching `VertScrollDelta` values to negativ
  - same can be done for horizontal scroll
  - just needs to be enabled first!
  