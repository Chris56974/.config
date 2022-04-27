# My Notes on Arch

These are just some notes I took to help remember some things about my system.

## SSH

When I sign in, my `~/.zprofile` runs startx which triggers xinit
My xinitrc then creates an ssh-agent using DWM in `/home/cj/.config/x11/xinitrc`.
So use `ssh-add` or `ssh-add ~/.ssh/id_ed25519` to add keys.

## Programs

Programs that I install with pacman have their binaries
put in /usr/bin/ and their other resources in /usr/share/
other resources like man files

Programs that I install by hand (via make install) should have
their binary executables in /usr/local/bin/ with other resources
that they use in /usr/local/share

All shell scripts that you can execute are in ~/.local/bin.

## Grub

You can set environment variables for grub in /etc/default/grub and then create a config from it using the grub-mkconfig command. I had to set nvidia-drm.modeset=1 as a kernel parameter.

```bash
# This will make a grub config using /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
```

## Display

To prevent screen tears I had to install nvidia-settings and do the following...

1. Start nvidia-settings with sudo
2. Click on X Server Display Configuration
3. Click on "advanced" at the bottom
4. Click on the "Full Composition Pipeline" checkbox for both monitors
5. Save it to a file @ `/etc/X11/xorg.conf.d/20-nvidia.conf`

I also had to go to my .xprofile and run

```bash
xrandr --dpi 192 --output HDMI-0 --rotate left --left-of DP-0
```

And to ~/.config/x11/xresources
```
!! Set a default font and font size as below:
*.font: monospace:size=18

!! Make the applications bigger
Xft.dpi: 192
```

## Fonts

Fonts that I install via pacman go in `/usr/share/fonts` (preferred).
Fonts that I install manually go in `/usr/share/local/fonts`.

freetype is a program that renders fonts via fontconfig's configuration.
fontconfig is a program that tells applications what fonts are available on the system.

Fonts that I add manually to /usr/share/local/fonts can be used right away
by the terminal and any other program that loads fonts directly (fc-list).
Applications that rely on fontconfig to grab fonts will not see those fonts
though until I run the fc-cache command down below.

```bash
fc-list # show all system fonts
sudo fc-cache -fv # search in font directories and add fonts
```

https://github.com/Allaman/nvim
