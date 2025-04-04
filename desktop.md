# Notes for BL Boron Desktop

## what is what

We have `openbox`, `LightDM`, `tint2`, `jgmenu`,  `blob`.
 As well as `Appearance`, `Customize look and feel`, multiple *edit* options
 for the previously mentions programs and basically direct access
 to **all** config files through the menu.

- **openbox** = window manager
- **jgmenu** = menu
- **tint2** = taskbar
- **picom** = compositor
- **keybindings**
  - `xbindkeys` for regular keybinds
  - within `bl-rc.xml`  for openbox keybindings
- **run** = `gmrun` started with `alt`+`f2`
- **alt menu** = `dmenu` started with `alt`+`f3`
- **BLOB Themes Manager**
  - exchanges a *whole collection* of settings
    - themes: openbox, gtk, icons, jgmenu
    - configurations: wallpaper, conky, tint2, dmenu, terminal, compositor
    - lightdm login screen
    - certain X files
  - stored in `~/.config/blob`

### menu

- basic help with editing the jgmenu and openbox menus:
 `Menu > Help & Resources > Bunsen Help Files > How to edit menu`
- `Menu > User Settings > jgmenu` gives access to help and configuration options:
- menu content is set with `~/.config/jgmenu/prepend.csv`
- menu settings are set with `~/.config/jgmenu/jgmenurc`
- Comprehensive help is provided by the commands `man jgmenu` and `man jgmenututorial`

### taskbar

- configuration in `¨/.config/tint2`
- different themes in `Menu > User Settings > Tint2 > Tint2 Manager`
- directly open end edit default themes with
 `Menu > Preferences > Tint2 > Edit Tint2s`
- there is a GUI with previews `tint2conf`

### windows & themes

- many settings changes require `openbox --reconfigure`
- GTK themes: `Menu > User Settings > Appearance`
  - program `lxappearance`
  - same as `Customize Look and Feel`
  - stuff *inside* the windows
- openenbox themes: `Menu > User Settings > Openbox > obconf - GUI Config tool`
  - title bars, borders, decorations
- font: best way to change in `~/.config/fontconfig/fonts.conf`
  - `Menu > User Settings > Font Configuration`
  - instead of GTK, openbox and within apps
  - refresh fonts `sudo fc-cache -fr`
- icons in panel
  - set `launcher_icon_theme` in `~/.config/tint2/tin2rc`
  - icon names you can get from *Appearance*
- icons in menu
- synchronize `jgmenu` with openbox: `Menu > jgmenu > Sync Theme w. Openbox`
- **default themes** are installed in `/usr/share/themes`
  - copy them to `~/.local/share/themes` => place for downloaded themes too
  - prevents against package upgrades
  - same goes for *fonts* `~/.local/share/fonts` and *icons* `~/.local/share/icons`
- **run** window is `gmrun`
- **alternatives menu** is `dmenu`

## setting up environment

### get more apps

Complete the basic system with some more apps and tools. Run
 `sudo apt install chromium build-essential git clang valgrind`

### manpages

Only the basic app is installed. Run
 `sudo apt install manpages manpages-dev` to get everything needed.

### editor(s)

BunsenLabs Boron comes with `geany` (nice for power efficiency on battery) and
 a specialversion of vim-tiny preinstalled as `vi`. installing regular `vim`
 packages gives acces to regular vim and also regular vim-tiny.

Some sources on `vim` and `geany`:

- [opensource](https://opensource.com/article/19/3/getting-started-vim)
- [freecodecamp](https://www.freecodecamp.org/news/vim-beginners-guide/)
- [markdown in vim](https://codeinthehole.com/tips/writing-markdown-in-vim/)
- [syntax highlighting in geany](https://stackoverflow.com/questions/14769358/custom-syntax-highlighting-in-geany)
- [geany themes](https://github.com/geany/geany-themes/tree/master/colorschemes)

### help menu

Definitely have a look at the `help` section of the menu. Check the
 [bunsenlabs forum](https://forums.bunsenlabs.org/) and play around.

Some notes from working through the getting start part of the forum:

- sessions: default bunsenlab session and clean non-boron openbox session
- defaults configuration files are stored in `/usr/share/bunsen/skel`
- big assortment of bunsenlabs scrips `/usr/bin/bl-*`
- autostart items in
  - `~/.config/bunsen/autostart`
  - as well as via XDG autostart
  - xdg .desktop files in `/etc/xdg/autostart/` and `~/.config/autostart`
  - check with `bl-xdg-autostart --list`
- *post install settings and tweaks* has some practical information on window
 related settings
