<h1 align="center">
  <br>
  <img src="https://raw.githubusercontent.com/shubhamgulati91/archify-effortlessly/master/arch-logo.png" alt="ArchLinux Logo" width="800">
  <br>DevMyLinuX
  <h4 align="center">A comprehensive instruction manual to install <a href="https://www.archlinux.org" target="_blank">Arch Linux</a> effort-lessly.
  <br>Easy AF. Highly Detailed. Throughly Tested.
  <br><br>60 min read  •  Shubham Gulati
  <br><br><a href="https://shubhamgulati91.github.io/archify-effortlessly" target="_blank">https://shubhamgulati91.github.io/archify-effortlessly</a>
  </h4>
</h1>

<p align="center">
  <!-- <a href="https://badge.fury.io/js/archify-effortlessly" target="_blank">
    <img src="https://badge.fury.io/js/archify-effortlessly.svg"
         alt="Gemfury">
  </a> -->
  <a href="https://gitter.im/archify-effortlessly/lobby" target="_blank"><img src="https://badges.gitter.im/shubhamgulati91/archify-effortlessly.png" alt="Gitter"></a>
  <a href="https://saythanks.io/to/shubhamgulati91" target="_blank">
      <img src="https://img.shields.io/badge/SayThanks.io-%E2%98%BC-1EAEDB.svg" alt="SayThanks">
  </a>
  <a href="https://www.paypal.me/shubhamgulati91" target="_blank">
    <img src="https://img.shields.io/badge/$-donate-ff69b4.svg?maxAge=2592000&amp;style=flat" alt="Paypal">
  </a>
</p>

<p align="center">
  <a href="#key-features">KEY FEATURES</a> •
  <a href="#how-to-use">HOW TO USE</a> •
  <a href="#download">DOWNLOAD</a> •
  <a href="#credits">CREDITS</a> •
  <a href="#related">RELATED</a> •
  <a href="#license">LICENSE</a>
</p>

<p align="center">
<img src="https://pbs.twimg.com/media/DjJGrjcUYAAv6JF.jpg" alt="ArchLinux Screenshot" width="600">
<br></p>

## KEY FEATURES

* Easy AF
  - Includes remote installation instructions.
* Minimal Mistakes
  - Copy-Paste instructions from manual to remote session.
* Automated
  - Most commands are one-liner.
  - Minimal manual intervention needed.
* Minimal Packages - Maximal Tunings
  - GNOME DE.
  - Fully customized ZSH.
  - Power saving tunings.

## HOW TO USE

To use this manual, you'll need [Git Bash](https://git-scm.com) and two computers.
This manual is optimized especially for following hardware.
```
ASUS Zenbook Pro UX501VW
Intel® HM170 Chipset
Intel® Core™ i7-6700HQ Processor
16GB DDR4 2133 MHz SDRAM
15.6" 16:9 IPS UHD (3840 x 2160) Display
Intel HD 530 4GB VRAM
NVIDIA® GeForce® GTX 960M with 4GB GDDR5 VRAM
512GB Samsung PCIE x4 m.2 SSD
```


## DOWNLOAD

[https://www.archlinux.org/download/](https://www.archlinux.org/download/)


#### CREATE BOOTABLE USB

Save script to a sh file and execute.
```sh
./create-bootable-drive.sh
```
```sh
./create-bootable-drive.sh -i -a write -f arch -d sda
```


#### CONFIGURE BIOS

```
Restore default config from BIOS menu.
Disable Secure Boot.
Save settings and reboot.
```


#### CHECK BOOT MODE

If UEFI mode is enabled on an UEFI motherboard, Archiso will boot Arch Linux accordingly via systemd-boot. To verify this, use the command:
```sh
efivar -l
```
Alternatively, you can list the efivars directory with:
```sh
ls /sys/firmware/efi/efivars
```
If the directory does not exist, the system may be booted in BIOS or CSM mode. Refer to your motherboard's manual for details.


## CONNECT TO INTERNET

#### WIRELESS CONNECTION

To connect to a network, using wireless network interface, use the command:
```sh
wifi-menu -o
```

#### WIRED CONNECTION

The installation image automatically enables the dhcpcd daemon on boot for wired network devices.


#### CHECK INTERNET CONNECTIVITY

Now let’s ping Google to see if we are connected:
```sh
ping -c 3 google.com
```
If you can see the ping, it’s time to proceed.


## START INSTALLATION REMOTELY

You can launch an SSH server and continue your installation remotely from another computer. In order to do that:

Set a root password using:
```sh
passwd
```
Now check that "PermitRootLogin yes" is present (and uncommented) in:
```sh
/etc/ssh/sshd_config
```
This setting allows root login with password authentication on the SSH server.

Now, start the openssh daemon using:
```sh
systemctl start sshd.service
```
Figure out your IP using:
```sh
ip a
```
Use bash shell to SSH to your installation disk from another computer and continue the installation as usual.
```sh
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.0.xxx
```

# BEGIN INSTALLATION


#### SELECT KEYMAP

For convenience, localectl can be used to set console keymap. It will change the KEYMAP variable in /etc/vconsole.conf and also set the keymap for current session:
```sh
localectl --no-convert set-keymap us
echo
localectl status
```
The "--no-convert" option can be used to prevent "localectl" from automatically changing the Xorg keymap to the nearest match.


#### CONFIGURE HARDWARE CLOCK

Use systemd-timesyncd to ensure that your system clock is accurate. To start it:
```sh
timedatectl set-ntp true
```


#### PARTITION SCHEME

When recognized by the live system, disks are assigned to a block device such as /dev/sda or /dev/nvme0n1. To identify these devices, use lsblk. Results ending in rom, loop or airoot may be ignored.

To identify the attached storage devices:
```sh
lsblk
```
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0         7:0    0 462.5M  1 loop /run/archiso/sfs/airootfs
sda           8:0    1  14.8G  0 disk
├─sda1        8:1    1   573M  0 part /run/archiso/bootmnt
└─sda2        8:2    1    64M  0 part
nvme0n1     259:0    0   477G  0 disk
├─[...]
```

Suggested UEFI GPT Scheme:
```
Number  Start    End      Size     File system     Name  Flags
 1      0.00GiB  1.00GiB  1.00GiB  fat32           BOOT  boot, esp
 2      1.00GiB  81.0GiB  80.0GiB  ext4            ROOT
 3      81.0GiB  105GiB   24.0GiB  linux-swap(v1)  SWAP
 4      105GiB   477GiB   372GiB   ext4            HOME
```

#### CREATE, FORMAT AND MOUNT NEW PARTITIONS

As soon as you know the alias of your hard drive, use "GNUParted" partitioning tool to create new partitions:
```sh
wipefs -af /dev/nvme0n1
parted --script -a optimal /dev/nvme0n1 \
    mklabel gpt \
    mkpart primary fat32 1MiB 1025MiB \
    set 1 boot on \
    name 1 BOOT \
    mkpart primary ext4 1025MiB 81GiB \
    name 2 ROOT \
    mkpart primary linux-swap 81GiB 105GiB \
    name 3 SWAP \
    unit GiB \
    mkpart primary ext4 105GiB 100% \
    name 4 HOME
echo
parted /dev/nvme0n1 'unit GiB print'
gdisk -l /dev/nvme0n1
echo
mkfs.ext4 -F -L ROOT /dev/nvme0n1p2
mount -t ext4 /dev/nvme0n1p2 /mnt
mkfs.vfat -F32 -n BOOT /dev/nvme0n1p1
mkdir -p /mnt/boot
mount -t vfat /dev/nvme0n1p1 /mnt/boot
mkswap -L SWAP /dev/nvme0n1p3
swapon /dev/nvme0n1p3
mkfs.ext4 -F -L HOME /dev/nvme0n1p4
mkdir -p /mnt/home
mount -t ext4 /dev/nvme0n1p4 /mnt/home
lsblk /dev/nvme0n1
echo
```

#### MATCH THE PARTITIONS AND MOUNTPOINTS
```
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0  477G  0 disk
├─nvme0n1p1 259:1    0    1G  0 part /mnt/boot
├─nvme0n1p2 259:2    0   80G  0 part /mnt
├─nvme0n1p3 259:3    0   24G  0 part [SWAP]
└─nvme0n1p4 259:4    0  372G  0 part /mnt/home
```


#### [RECOMMENDED] CONFIGURE MIRRORLIST

Packages to be installed must be downloaded from mirror servers, which are defined in /etc/pacman.d/mirrorlist. On the live system, all mirrors are enabled, and sorted by their synchronization status and speed at the time the installation image was created.
The higher a mirror is placed in the list, the more priority it is given when downloading a package. You may want to edit the file accordingly, and move the geographically closest mirrors to the top of the list, although other criteria should be taken into account.
This file will later be copied to the new system by pacstrap, so it is worth getting right.

To download data from the fastest mirrors:


#### [RECOMMENDED] FETCH MIRRORS WITH REFLECTOR

To install Reflector:
```sh
pacman -Sy --noconfirm reflector rsync curl
cp -v /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector --country India --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
chmod +r /etc/pacman.d/mirrorlist
```


## INSTALL BASE SYSTEM

The following command installs all packages contained in the "base" and "base-devel" package-group of the Arch Linux installer.
```sh
pacstrap /mnt base base-devel linux linux-firmware intel-ucode nano zsh bash-completion reflector pacman-contrib
```


## GENERATE FSTAB

Fstab is a system configuration file and is used to tell the Linux kernel which partitions (file systems) to mount and where on the file system tree.

Now generate a new fstab file with:
```sh
rm /mnt/etc/fstab && genfstab -U -p /mnt >> /mnt/etc/fstab
```


## CHROOT INTO SYSTEM

Now we are going to enter the installed system without rebooting and start a terminal session from there. Use the command:
```sh
arch-chroot /mnt /bin/bash
```


#### CONFIGURE LOCALE

We need to set the locale for the freshly installed system.
```sh
sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
```


#### CONFIGURE TIMEZONE

Link the preferred time zone to your localtime.
For example, I get the list of zones with 'tzselect' and choose Asia/Kolkata.
```sh
timedatectl set-timezone Asia/Kolkata
```
Configure systemd-timesyncd:
```sh
sed -i -e 's/^#NTP=.*/NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org/' /etc/systemd/timesyncd.conf
sed -i -e 's/^#FallbackNTP=.*/FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org/' /etc/systemd/timesyncd.conf
```
Enable the service:
```sh
systemctl enable systemd-timesyncd.service
```


#### CONFIGURE HARDWARE CLOCK

It is recommended to adjust the time skew, and set the time standard to UTC:
```sh
hwclock --systohc --utc
```


#### CONFIGURE HOSTNAME

Create the hostname file "/etc/hostname":
```sh
echo zenbook-pro > /etc/hostname
```
Configure hosts:
```sh
echo "" >> /etc/hosts
echo '127.0.0.1       zenbook-pro.localdomain localhost zenbook-pro' >> /etc/hosts
echo '::1             zenbook-pro.localdomain localhost zenbook-pro' >> /etc/hosts
echo '127.0.1.1       zenbook-pro.localdomain localhost zenbook-pro' >> /etc/hosts
```


#### CONFIGURE MULTILIB

If you are running a 64-bit system then you need to enable the multilib repository as follows:
```sh
sed -i '/^#\[multilib\]/s/^#//' /etc/pacman.conf
sed -i "$(( `grep -n "^\[multilib\]" /etc/pacman.conf | cut -f1 -d:` + 1 ))s/^#//" /etc/pacman.conf
```
And update the system.
```sh
pacman -Syyu
```

#### SET ROOT PASSWORD

Set the root password with:
```sh
passwd
```


#### ADD NEW USER

Create a new user, and add the user to "users", and "wheel" group. Use the command:
```sh
useradd -m -g users -G wheel,lp,rfkill,sys,storage,power,audio,disk,input,kvm,video,scanner -s /bin/zsh shubham -c "Shubham Gulati"
```
Set password for the new user:
```sh
passwd shubham
```

#### CONFIGURE SUDOERS

To run commands as sudo, you need to provide the user privilage specification in "/etc/sudoers".

Allow all permissions to users in wheel group with:
```sh
sed -i '/^# %wheel ALL=(ALL) ALL/s/^# //' /etc/sudoers
echo "" >> /etc/sudoers
echo 'Defaults !requiretty, !tty_tickets, !umask' >> /etc/sudoers
echo 'Defaults visiblepw, path_info, insults, lecture=always' >> /etc/sudoers
echo 'Defaults loglinelen=0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth' >> /etc/sudoers
echo 'Defaults passwd_tries=3, passwd_timeout=1' >> /etc/sudoers
echo 'Defaults env_reset, always_set_home, set_home, set_logname' >> /etc/sudoers
echo 'Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"' >> /etc/sudoers
echo 'Defaults timestamp_timeout=15' >> /etc/sudoers
echo 'Defaults passprompt="[sudo] password for %u: "' >> /etc/sudoers
echo 'Defaults lecture=never' >> /etc/sudoers
```


#### INSTALL MICROCODE UPDATES

If you have an Intel CPU, install the "intel-ucode" package, and enable microcode updates to avoid freezes.
```sh
pacman -S --noconfirm intel-ucode
```
To enable microcode updates for "systemd-boot" boot loader, just add a "initrd /intel-ucode.img" as first initrd entry in boot entry config file after installing boot loader.

NOTE: The installation drive is assumed to be GPT-partioned, and have the EFI System Partition (parted type ESP, formatted with FAT32) mounted at /boot.



#### INSTALL BOOTLOADER

To install the bootloader:
```sh
bootctl --path=/boot install
```

#### ADD BOOT ENTRY

Now we will create the Arch Linux boot entry:
```sh
nano /boot/loader/entries/arch.conf
```
[ADVANCED POWER SAVINGS] Enter the following configuration to the "arch.conf" file.
```
title		Arch Linux
linux		/vmlinuz-linux
initrd		/intel-ucode.img
initrd		/initramfs-linux.img
options		root=/dev/nvme0n1p2 rw resume=/dev/nvme0n1p3 i915.enable_guc=3 i915.enable_psr=2 i915.enable_fbc=1 i915.enable_dc=2 drm.vblankoffdelay=1 i915.enable_rc6=1 i915.lvds_downclock=1 i915.semaphores=1 acpi_osi=! acpi_osi="Windows 2015" acpi_backlight=native pcie_aspm=force pcie_aspm.policy=powersupersave nmi_watchdog=0 elevator=noop splash quiet loglevel=3 rd.systemd.show_status=false rd.udev.log-priority=3
```
Now configure boot loader to boot using the above configuration:
```sh
nano /boot/loader/loader.conf
```
Clear anything that is written in the file and enter the following:
```
timeout		0
editor		yes
console-mode	keep
auto-entries	1
auto-firmware   1
default		arch
```

[ALTERNATE LEGACY CONFIG] Enter the following configuration to the "arch.conf" file.
```
title		Arch Linux
linux		/vmlinuz-linux
initrd		/intel-ucode.img
initrd		/initramfs-linux.img
options		root=/dev/nvme0n1p2 rw resume=/dev/nvme0n1p3 i915.preliminary_hw_support=1 intel_idle.max_cstate=1 i915.enable_execlists=0 acpi_osi= acpi_backlight=native elevator=noop splash quiet vga=current loglevel=3 rd.systemd.show_status=false rd.udev.log-priority=3 nmi_watchdog=0
```



## INSTALL DESKTOP ENVIRONMENT


#### XORG

[https://wiki.archlinux.org/index.php/Xorg](https://wiki.archlinux.org/index.php/Xorg)

Xorg is the public, open-source implementation of the X window system version 11.

```sh
pacman -S --noconfirm xorg-server xorg-xbacklight xbindkeys xorg-xev xorg-xinit xorg-xinput xorg-twm xorg-xclock xterm xdotool

```

#### WAYLAND

[https://wiki.archlinux.org/index.php/Wayland](https://wiki.archlinux.org/index.php/Wayland)

Wayland is a protocol for a compositing window manager to talk to its clients, as well as a library implementing the protocol.

```sh
pacman -S --noconfirm weston xorg-server-xwayland
```

#### DESKTOP ENVIRONMENT

Install GNOME Desktop environment with:
```sh
pacman -S --noconfirm gnome gnome-extra gnome-software gnome-initial-setup gnome-menus deja-dup gedit-plugins gpaste gnome-tweak-tool gnome-power-manager gnome-themes-standard fprintd nautilus-share
```

#### GNOME DISPLAY MANAGER

Enable GDM:
```sh
systemctl enable gdm.service
```

#### CONFIGURE NETWORK

#### NETWORKMANAGER

[https://wiki.archlinux.org/index.php/Networkmanager](https://wiki.archlinux.org/index.php/Networkmanager)

NetworkManager is a program for providing detection and configuration for systems to automatically connect to network. NetworkManager's functionality can be useful for both wireless and wired networks.
```sh
pacman -S --noconfirm dnsmasq networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc network-manager-applet nm-connection-editor gnome-keyring
```
```sh
systemctl disable dhcpcd.service
```
```sh
systemctl enable NetworkManager.service
```

We are now finally ready to boot in to the glory that Arch Linux is.
But before rebooting, install Web Browser to get access to the installation manual out of the box:
```sh
sudo pacman -S --noconfirm chromium firefox
```

#### UNMOUNT PARTITIONS

Exit from the chroot environment:
```sh
exit
```
Partitions will be unmounted automatically by systemd on shutdown. You may however unmount manually as a safety measure:
```sh
umount -R /mnt/boot /mnt/home /mnt
swapoff -a
```

## REBOOT SYSTEM

Shut down and reboot the system:
```sh
systemctl reboot
```
Remove the installation media.

If something goes wrong at this point, use the installation media to remount partitions and chroot into the installed system.
```
wifi-menu -o
```
```
passwd
```
```
systemctl start sshd.service
```
```
ip a
```
```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.0.xxx
```
```
mount -t ext4 /dev/nvme0n1p2 /mnt
mount -t vfat /dev/nvme0n1p1 /mnt/boot
mount -t ext4 /dev/nvme0n1p4 /mnt/home
```
```
lsblk /dev/nvme0n1
```
```
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0  477G  0 disk
├─nvme0n1p1 259:1    0    1G  0 part /mnt/boot
├─nvme0n1p2 259:2    0   80G  0 part /mnt
├─nvme0n1p3 259:3    0   24G  0 part [SWAP]
└─nvme0n1p4 259:4    0  372G  0 part /mnt/home
```
```
arch-chroot /mnt /bin/bash
```


#### LOGIN TO NEW USER
You can log into your new installation as root or with newly created user, using the password you specified with passwd.
```sh
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null shubham@192.168.0.xxx
```


#### CONFIGURE XINITRC
```sh
cp -fv /etc/X11/xinit/xinitrc /home/shubham/.xinitrc
sed -i '/^twm.*/s/^/# /' /home/shubham/.xinitrc
sed -i '/^xclock.*/s/^/# /' /home/shubham/.xinitrc
sed -i '/^xterm.*/s/^/# /' /home/shubham/.xinitrc
sed -i '/^exec.*/s/^/# /' /home/shubham/.xinitrc
echo -e "" >> /home/shubham/.xinitrc
echo -e "exec gnome-session" >> /home/shubham/.xinitrc
sudo chmod +x ~/.xinitrc
```

#### CONFIGURE ZSH

[https://wiki.archlinux.org/index.php/Zsh](https://wiki.archlinux.org/index.php/Zsh)

Zsh is a powerful shell that operates as both an interactive shell and as a scripting language interpreter.
```sh
sudo pacman -S --noconfirm zsh git
```
Install oh-my-zsh:
```sh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### CONFIGURE BASH

Inject pre-configured dotfiles:
```sh
sudo pacman -S --noconfirm git colordiff
mkdir -p /tmp && cd /tmp
git clone https://github.com/helmuthdu/dotfiles
cp -v dotfiles/.bashrc dotfiles/.dircolors dotfiles/.dircolors_256 /home/shubham/
rm -rf dotfiles && cd ~
```

#### GIT
```sh
sudo pacman -S --noconfirm git
git config --global user.name "Shubham Gulati" && git config --global user.email "john.doe@example.com"
git config --global credential.helper cache store
```

#### SSH

[https://wiki.archlinux.org/index.php/Ssh](https://wiki.archlinux.org/index.php/Ssh)

Secure Shell (SSH) is a network protocol that allows data to be exchanged over a secure channel between two computers.

OpenSSH is already installed and enabled at this point. Configure sshd:
```sh
sudo sed -i '/Port 22/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/Protocol 2/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/HostKey \/etc\/ssh\/ssh_host_rsa_key/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/HostKey \/etc\/ssh\/ssh_host_dsa_key/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/KeyRegenerationInterval/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/ServerKeyBits/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/SyslogFacility/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/LogLevel/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/LoginGraceTime/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/PermitRootLogin/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/HostbasedAuthentication no/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/StrictModes/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/RSAAuthentication/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/PubkeyAuthentication/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/IgnoreRhosts/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/PermitEmptyPasswords/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/AllowTcpForwarding/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/AllowTcpForwarding no/d' /etc/ssh/sshd_config
sudo sed -i '/X11Forwarding/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/X11Forwarding/s/no/yes/' /etc/ssh/sshd_config
sudo sed -i -e '/\tX11Forwarding yes/d' /etc/ssh/sshd_config
sudo sed -i '/X11DisplayOffset/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/X11UseLocalhost/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/PrintMotd/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/PrintMotd/s/yes/no/' /etc/ssh/sshd_config
sudo sed -i '/PrintLastLog/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/TCPKeepAlive/s/^#//' /etc/ssh/sshd_config
sudo sed -i '/the setting of/s/^/#/' /etc/ssh/sshd_config
sudo sed -i '/RhostsRSAAuthentication and HostbasedAuthentication/s/^/#/' /etc/ssh/sshd_config
```

#### YAY - AUR HELPER

Install an AUR helper, YAY, to start using Arch User Repository.

Create a temporary working directory and navigate to it:
```sh
sudo pacman -S --noconfirm git
mkdir -p /tmp/yay_install
cd /tmp/yay_install
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
rm -rf /tmp/yay_install
```

#### BASH TOOLS

[https://wiki.archlinux.org/index.php/Bash](https://wiki.archlinux.org/index.php/Bash)
```sh
sudo pacman -S --noconfirm bc rsync mlocate bash-completion pkgstats
```

#### (UN)COMPRESS TOOLS

[https://wiki.archlinux.org/index.php/P7zip](https://wiki.archlinux.org/index.php/P7zip)
```sh
sudo pacman -S --noconfirm zip unzip unrar p7zip lzop cpio zziplib
```

#### AVAHI

[https://wiki.archlinux.org/index.php/Avahi](https://wiki.archlinux.org/index.php/Avahi)

Avahi is a free Zero Configuration Networking (Zeroconf) implementation, including a system for multicast DNS/DNS-SD discovery. It allows programs to publish and discovers services and hosts running on a local network with no specific configuration.

```sh
sudo pacman -S --noconfirm avahi nss-mdns
sudo systemctl enable avahi-daemon.service
```

#### ALSA

[https://wiki.archlinux.org/index.php/Alsa](https://wiki.archlinux.org/index.php/Alsa)

The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component intended to replace the original Open Sound System (OSSv3) for providing device drivers for sound cards.
```sh
sudo pacman -S --noconfirm alsa-utils alsa-plugins
```

#### PULSEAUDIO

[https://wiki.archlinux.org/index.php/Pulseaudio](https://wiki.archlinux.org/index.php/Pulseaudio)

PulseAudio is the default sound server that serves as a proxy to sound applications using existing kernel sound components like ALSA or OSS
```sh
sudo pacman -S --noconfirm pulseaudio pulseaudio-alsa
```

#### NTFS/FAT/exFAT/F2FS

[https://wiki.archlinux.org/index.php/File_Systems](https://wiki.archlinux.org/index.php/File_Systems)

A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device.
```sh
sudo pacman -S --noconfirm ntfs-3g dosfstools exfat-utils f2fs-tools fuse fuse-exfat autofs mtpfs
```

#### SYSTEMD-TIMESYNCD

[https://wiki.archlinux.org/index.php/Systemd-timesyncd](https://wiki.archlinux.org/index.php/Systemd-timesyncd)

A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device.
```sh
sudo timedatectl set-ntp true
```


#### TOUCHPAD DRIVER
```sh
sudo pacman -S --noconfirm xf86-input-libinput mousetweaks
```
For touchpad tap-to-click use:

[https://wiki.archlinux.org/index.php/Libinput#Common_options](https://wiki.archlinux.org/index.php/Libinput#Common_options)


#### FONT CONFIGURATION

[https://wiki.archlinux.org/index.php/Font_Configuration](https://wiki.archlinux.org/index.php/Font_Configuration)

Fontconfig is a library designed to provide a list of available fonts to applications, and also for configuration for how fonts get rendered.
```sh
sudo pacman -S --noconfirm --asdeps --needed cairo fontconfig freetype2
```

#### [NOT RECOMMENDED] CONFIGURE GPU DRIVERS

###### CHECK CARDS

If you do not know what graphics card you have, find out by issuing:
```sh
lspci -k | grep -A 2 -E "(VGA|3D)"
```
For the system I'm using to generate this guide, I use NVIDIA driver. You can use the output from the above command to determine what driver you need.


#### NVIDIA CARDS

###### [REQUIRED] BUMBLEBEE (NVIDIA)
```sh
sudo pacman -S --needed xf86-video-intel bumblebee nvidia nvidia-settings lib32-virtualgl lib32-nvidia-utils mesa lib32-mesa-libgl lib32-mesa-demos mesa-demos libva-vdpau-driver nvidia-libgl lib32-opencl-nvidia lib32-mesa-vdpau
```
Add username to bumblebee group:
```sh
sudo gpasswd -a shubham bumblebee
```
Enable bumblebee service:
```sh
sudo systemctl enable bumblebeed.service
```

###### [NOT RECOMMENDED] OTHER OPEN SOURCE DRIVERS
```sh
sudo pacman -S xf86-video-nonveau mesa libva-vdpau-driver lib32-mesa lib32-libva-vdpau-driver
```

###### [NOT RECOMMENDED] NVIDIA PROPRIETARY DRIVERS
```sh
sudo pacman -S nvidia nvidia-libgl lib32-nvidia-libgl
```

#### [NOT REQUIRED] INTEL CARDS

Open Source GPU Drivers:
```sh
sudo pacman -S xf86-video-intel mesa libva-intel-driver lib32-mesa lib32-libva-intel-driver
```

#### [NOT REQUIRED] ATI CARDS

Open Source GPU Drivers:
```sh
sudo pacman -S xf86-video-ati mesa libva-vdpau-driver lib32-mesa lib32-libva-vdpau-driver
```
Proprietary GPU Drivers (available only on AUR at the time of writing):
```sh
sudo yay -S catalyst catalyst-libgl lib32-catalyst-libgl
```

#### [RECOMMENDED] ADDITIONAL FIRMWARE
```sh
yay -S --noconfirm wd719x-firmware aic94xx-firmware
sudo mkinitcpio -p linux
```




## CONFIGURE SYSTEM

#### CONNECT TO INTERNET

Connect to wired or wireless network


#### RE-OPEN INSTALL MANUAL FROM BROWSER TO CONTINUE

Install Web Browser:
```sh
sudo pacman -S --noconfirm chromium firefox
```


#### CONFIGURE SYSTEM SETTINGS

Configure basic system preferences such as privacy and power settings.


#### CONFIGURE KEYBOARD SHORTCUTS

Home folder
```
Super+E
```
Hide All Normal Windows
```
Super+D
```
Terminal
```
gnome-terminal

Super+T
```
Terminal
```
gnome-terminal

Ctrl+Alt+T
```


#### INSTALL FONTS AND THEMES

Install better system fonts:
```sh
sudo pacman -S --noconfirm ttf-ubuntu-font-family noto-fonts ttf-liberation adobe-source-code-pro-fonts ttf-dejavu opendesktop-fonts
```
Install Shell & Icon Themes
```sh
yay -S --noconfirm mojave-gtk-theme mojave-ct-icon-theme
sudo pacman -S --noconfirm arc-gtk-theme
```
Add font configuration to "~/.config/fontconfig/fonts.conf"
```sh
mkdir -p ~/.config/fontconfig/
nano ~/.config/fontconfig/fonts.conf
```
Add following code to fonts.conf
```xml
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
 <match target="font">
  <edit mode="assign" name="rgba">
   <const>rgb</const>
  </edit>
 </match>
 <match target="font">
  <edit mode="assign" name="hinting">
   <bool>true</bool>
  </edit>
 </match>
 <match target="font">
  <edit mode="assign" name="hintstyle">
   <const>hintslight</const>
  </edit>
 </match>
 <match target="font">
  <edit mode="assign" name="antialias">
   <bool>true</bool>
  </edit>
 </match>
  <match target="font">
    <edit mode="assign" name="lcdfilter">
      <const>lcddefault</const>
    </edit>
  </match>
</fontconfig>
```
In order to enable “Infinality mode” in plain vanilla freetype2:
```sh
sudo sed -i '/^#export FREETYPE_PROPERTIES=.*/s/^#//' /etc/profile.d/freetype2.sh
```
Then create the following symbolic links in /etc/fonts/conf.d if they aren’t already present:
```sh
cd /etc/fonts/conf.d
sudo rm ./10-hinting-slight.conf
sudo ln -s ../conf.avail/10-hinting-slight.conf
sudo ln -s ../conf.avail/10-sub-pixel-rgb.conf
sudo ln -s ../conf.avail/11-lcdfilter-default.conf
cd ~
```

#### GNOME SHELL CONNECTION

Install the browser-shell connector:
```sh
sudo pacman -S --noconfirm chrome-gnome-shell
```
Use web browser and go to:

[https://extensions.gnome.org/](https://extensions.gnome.org/)

Choose "Allow and remember" when prompted for shell integration permission.


#### CHANGE LOOK AND FEEL

Install and enable [User Themes](https://extensions.gnome.org/extension/19/user-themes/) extension.

Configure appreance from GNOME Tweak Tool:
```
Applications		to		Mojave-dark
Cursor			to		Adwaita (default)
Icons			to		Mojave-CT
Shell			to		Mojave-dark
```
Open Gnome Tweak Tool, goto fonts tab and change the following options:
```
Interface Text		to		Ubuntu Regular			10
Documents Text      	to		Ubuntu Regular			10
Monospace Text		to		Ubuntu Mono Regular		10
Legacy Window Titles   	to		Ubuntu Bold			10
Hinting			to		Slight
Antialiasing		to		Subpixel (rgba)
Sacling Factor		to		1.00
```


#### GNOME SHELL EXTENSIONS

Install and configure extensions:

[Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)

[Caffeine](https://extensions.gnome.org/extension/517/caffeine/)

[Dynamic Top Bar](https://extensions.gnome.org/extension/885/dynamic-top-bar/) - transparency level 0.30

[NetSpeed](https://extensions.gnome.org/extension/104/netspeed/)

[Refresh Wifi Connections](https://extensions.gnome.org/extension/905/refresh-wifi-connections/)

[Todo.txt](https://extensions.gnome.org/extension/570/todotxt/)

[Media player indicator](https://extensions.gnome.org/extension/55/media-player-indicator/)


#### CONFIGURE SWAPPINESS

Swap storage is slow. SSD writes are precious. So let us set the swappiness to "1" which technically almost disables your swap, but still makes it accessible for hibernation.
```sh
sudo /bin/sh -c 'echo "vm.swappiness=1" >> /etc/sysctl.d/99-sysctl.conf'
sudo sysctl vm.swappiness=1
```

## POWER ENHANCEMENTS

[http://arter97.blogspot.com/2018/08/saving-power-consumption-on-laptops.html?m=1](http://arter97.blogspot.com/2018/08/saving-power-consumption-on-laptops.html?m=1)

#### TL;DR
```sh
sudo nano /boot/loader/entries/arch.conf
```
Set kernel options to:
```
options		root=/dev/nvme0n1p2 rw resume=/dev/nvme0n1p3 i915.enable_guc=3 i915.enable_psr=2 i915.enable_fbc=1 i915.enable_dc=2 drm.vblankoffdelay=1 i915.enable_rc6=1 i915.lvds_downclock=1 i915.semaphores=1 acpi_osi=! acpi_osi="Windows 2015" acpi_backlight=native pcie_aspm=force pcie_aspm.policy=powersupersave nmi_watchdog=0 elevator=noop splash quiet loglevel=3 rd.systemd.show_status=false rd.udev.log-priority=3
```

#### INSTALL LATEST KERNEL
```sh
sudo pacman -Sy linux
```

#### INSTALL LATEST FIRMWARE
```sh
sudo pacman -Sy intel-ucode linux-firmware
```

#### [EXPERIMENTAL] CONFIGURE i915
```sh
sudo nano /boot/loader/entries/arch.conf
```
Add kernel options:
```
i915.enable_guc=3 i915.enable_psr=2 i915.enable_fbc=1 i915.enable_dc=2 i915.enable_rc6=1 i915.lvds_downclock=1 i915.semaphores=1

```
Or, alternatively:
```sh
sudo /bin/sh -c 'echo "options i915 enable_guc=3 enable_psr=2 enable_fbc=1 enable_dc=2" >> /etc/modprobe.d/i915.conf'
```
```sh
sudo systemctl reboot
```
Verify:
```sh
dmesg | grep GuC
dmesg | grep HuC
dmesg | grep psr
```
```
[drm] HuC: Loaded firmware i915/kbl_huc_ver02_00_1810.bin (version 2.0)
[drm] GuC: Loaded firmware i915/kbl_guc_ver9_39.bin (version 9.39)
i915 0000:00:02.0: GuC firmware version 9.39
i915 0000:00:02.0: GuC submission enabled
i915 0000:00:02.0: HuC enabled
Setting dangerous option enable_psr - tainting kernel
```

#### [EXPERIMENTAL] ADJUSTING DRM VBLANK OFF DELAY
```sh
sudo nano /boot/loader/entries/arch.conf
```
Add kernel options:
```
drm.vblankoffdelay=1
```

#### [EXPERIMENTAL] TRICKING THE BIOS

```sh
sudo nano /boot/loader/entries/arch.conf
```
Add kernel options:
```
acpi_osi=! acpi_osi="Windows 2015" acpi_backlight=native
```

#### [EXPERIMENTAL] ENABLE ASPM
```sh
sudo nano /boot/loader/entries/arch.conf
```
Add kernel options:
```
pcie_aspm=force pcie_aspm.policy=powersupersave
```

#### TLP

[https://wiki.archlinux.org/index.php/Tlp](https://wiki.archlinux.org/index.php/Tlp)

TLP is an advanced power management tool for Linux. It is a pure command line tool with automated background tasks and does not contain a GUI.

```sh
sudo pacman -S --noconfirm tlp tlp-rdw ethtool smartmontools x86_energy_perf_policy
```
Modify TLP configuration:
```sh
sudo nano /etc/default/tlp
```
Enable TLP Service on boot
```sh
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket
```

#### [EXPERIMENTAL] REMOVE DEVICES AT BOOT AND RESUME

Type 'lsusb' and 'lsusb -v' to see USB devices.
```sh
sudo lsusb -v
```
In my case, "ID 04f2:b3fd" is a webcam and "ID 8087:0a2b" is a Bluetooth adapter, which I know I won't be using.

```sh
sudo nano /etc/remove-unused-usb-devices.sh
```
```
#!/bin/bash

exec > /dev/kmsg 2>&1

sleep 3
find /sys -name idProduct | while read file; do
  if cat $file | grep -q 'b3fd\|0a2b'; then
    echo Removing $(dirname $file)
    echo 1 > $(dirname $file)/remove
  fi
done
```
```sh
sudo chmod 755 /etc/remove-unused-usb-devices.sh
```
The part you need to change is at "grep -q '562e\|0a2b'".
The syntax is simple, just append new devices followed by "\|":
grep -q '0000\|1111\|2222\|3333\|4444'

Now, for it to execute upon reboot, let's use crontab:
```sh
sudo pacman -S --noconfirm cronie
```
```sh
sudo crontab -e
```
```
@reboot /etc/remove-unused-usb-devices.sh
```
If you need to access those blacklisted USB devices, just remove the script and suspend/resume your laptop.

Now we need to execute the script upon resume. Let's write a systemd service for that:
```sh
sudo nano /lib/systemd/system/remove-unused-usb-devices-upon-resume.service
```
```
[Unit]
Description=Remove Unused USB Devices Upon Resume
Before=sleep.target
StopWhenUnneeded=yes

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStop=/etc/remove-unused-usb-devices.sh

[Install]
WantedBy=sleep.target
```
```sh
sudo systemctl enable --now remove-unused-usb-devices-upon-resume.service
```
You can validate whether it works by checking kernel log with dmesg:
```
[10838.133311] Removing /sys/devices/pci0000:00/0000:00:14.0/usb1/1-5
[10838.296408] usb 1-5: USB disconnect, device number 2
[10838.310044] Removing /sys/devices/pci0000:00/0000:00:14.0/usb1/1-6
[10838.454298] usb 1-6: USB disconnect, device number 3
```

#### [EXPERIMENTAL] DISABLE UNUSED PCIe PERIPHERALS
```sh
sudo lspci | grep -v 00:
```
In my case, 01:00.0 is dGPU Card, 02:00.0 is a PCIe microSD reader, 03:00.0 is Wi-Fi Card, and 04:00.0 is a NVMe SSD.

Disabling PCIe peripherals is a more straight forward process. We can just disable loading of a device driver that is responsible for such device.
```sh
sudo lspci -v
```
'lspci -v' will print out which kernel modules are responsible for each devices.
```sh
sudo /bin/sh -c 'echo "#  Disable Bluetooth" >> /etc/modprobe.d/50-disable-bluetooth.conf'
sudo /bin/sh -c 'echo "blacklist bluetooth" >> /etc/modprobe.d/50-disable-bluetooth.conf'
sudo /bin/sh -c 'echo "blacklist btusb" >> /etc/modprobe.d/50-disable-bluetooth.conf'
sudo /bin/sh -c 'echo "# Disable Webcam" >> /etc/modprobe.d/50-disable-webcam.conf'
sudo /bin/sh -c 'echo "blacklist uvcvideo" >> /etc/modprobe.d/50-disable-webcam.conf'
```
The first two lines disable bluetooth and the last disables the webcam.

#### [EXPERIMENTAL] DISABLE dGPU
```sh
sudo pacman -S --noconfirm dkms bbswitch
sudo /bin/sh -c 'echo "# Disable Alternate Driver" >> /etc/modprobe.d/50-disable-dGPU.conf'
sudo /bin/sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/50-disable-dGPU.conf'
sudo /bin/sh -c 'echo "# Disable Original Driver" >> /etc/modprobe.d/50-disable-dGPU.conf'
sudo /bin/sh -c 'echo "blacklist nvidia" >> /etc/modprobe.d/50-disable-dGPU.conf'
sudo /bin/sh -c 'echo "blacklist nvidia_drm" >> /etc/modprobe.d/50-disable-dGPU.conf'
sudo /bin/sh -c 'echo "options bbswitch load_state=0 unload_state=0" >> /etc/modprobe.d/bbswitch.conf'
```

#### POWERTOP
```sh
sudo pacman -S --noconfirm powertop
```
Create a new systemd service:
```sh
sudo nano /etc/systemd/system/powertop.service
```
```
[Unit]
Description=PowerTOP Tunings

[Service]
ExecStart=/usr/bin/powertop --auto-tune
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```
Save and enable it with:
```sh
sudo systemctl enable --now powertop.service
```
See power statistics using powertop
```sh
sudo powertop
```
Confirm Idle Stats:
```
Package		-> C8(pc8) - C10(pc10)
Core		-> C7 (cc7)
GPU		-> RC6
CPU [0-7]	-> C8 - C10
```

#### CPU/HDD TEMPERATURE
```sh
sudo pacman -S --noconfirm lm_sensors hddtemp
sensors
sudo hddtemp /dev/nvme0n1
```

#### CONFIGURE PERIODIC TRIM FOR SSD

To verify TRIM support, run:
```sh
lsblk -D
```
And check the values of DISC-GRAN and DISC-MAX columns. Non-zero values indicate TRIM support.

The "util-linux" package provides "fstrim.service" and "fstrim.timer" systemd unit files. Enabling the timer will activate the service weekly. The service executes fstrim on all mounted filesystems on devices that support the discard operation.

Enable the periodic trim service with:
```sh
sudo systemctl enable --now fstrim.timer
```

#### [RECOMMENDED] CONFIGURE BLUETOOTH

[https://wiki.archlinux.org/index.php/Bluetooth](https://wiki.archlinux.org/index.php/Bluetooth)

Bluetooth is a standard for the short-range wireless interconnection of cellular phones, computers, and other electronic devices. In Linux, the canonical implementation of the Bluetooth protocol stack is BlueZ.
```sh
sudo pacman -S --noconfirm bluez bluez-utils bluez-libs pulseaudio-alsa pulseaudio-bluetooth
sudo systemctl enable --now bluetooth.service
```
Enable auto connection
adding the following lines to:
```sh
sudo /bin/sh -c 'echo "" >> /etc/pulse/default.pa'
sudo /bin/sh -c 'echo "### Automatically switch to newly-connected devices" >> /etc/pulse/default.pa'
sudo /bin/sh -c 'echo "load-module module-switch-on-connect" >> /etc/pulse/default.pa'
```
By default, your Bluetooth adapter will not power on after a reboot. Now you just need to add the line AutoEnable=true in /etc/bluetooth/main.conf at the bottom in the Policy section:
```sh
sudo sed -i 's/^#AutoEnable=.*/AutoEnable=true/' /etc/bluetooth/main.conf
```
If PulseAudio fails when changing the profile to A2DP while using GNOME with GDM, you need to prevent GDM from starting its own instance of PulseAudio.

Prevent Pulseaudio clients from automatically starting a server if one isn't running by adding the following lines to:
```sh
sudo mkdir -p /var/lib/gdm/.config/pulse
sudo touch /var/lib/gdm/.config/pulse/client.conf
sudo /bin/sh -c 'echo "autospawn = no" >> /var/lib/gdm/.config/pulse/client.conf'
sudo /bin/sh -c 'echo "daemon-binary = /bin/true" >> /var/lib/gdm/.config/pulse/client.conf'
```
Prevent systemd from starting Pulseaudio anyway with socket activation:
```sh
sudo mkdir -p /var/lib/gdm/.config/systemd/user
sudo ln -s /dev/null /var/lib/gdm/.config/systemd/user/pulseaudio.socket
```
Restart, and check that there is no Pulseaudio process for the gdm user.


#### REMOVE GNOME GAMES
```sh
sudo pacman -Rnsc --noconfirm four-in-a-row five-or-more gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-tetravex gnome-taquin swell-foop hitori iagno quadrapassel lightsoff tali
```

#### FIX NOISE IN HEADPHONES
```sh
sudo /bin/sh 'echo "options snd-hda-intel model=dell-headset-multi" >> /etc/modprobe.d/alsa-base.conf'
```

#### VIPER4LINUX

Follow the guide to install Viper4Linux.

[https://github.com/L3vi47h4N/Viper4Linux](https://github.com/L3vi47h4N/Viper4Linux)

To start Viper after login:
```sh
echo '' >> ~/.bash_profile
echo 'viper start &' >> ~/.bash_profile
```

#### CUPS

[https://wiki.archlinux.org/index.php/Cups](https://wiki.archlinux.org/index.php/Cups)

CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS X and other UNIX-like operating systems.

```sh
sudo pacman -S --noconfirm cups cups-pdf gutenprint ghostscript gsfonts foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds libcups system-config-printer hplip
sudo systemctl enable --now org.cups.cupsd.service
```

#### NFS

[https://wiki.archlinux.org/index.php/Nfs](https://wiki.archlinux.org/index.php/Nfs)

NFS allowing a user on a client computer to access files over a network in a manner similar to how local storage is accessed.
```sh
sudo pacman -S --noconfirm nfs-utils
```
```sh
sudo systemctl enable rpcbind
sudo systemctl enable nfs-client.target
sudo systemctl enable remote-fs.target
```

#### [OPTIONAL] CONFIGURE USB MODEM

[https://wiki.archlinux.org/index.php/USB_3G_Modem](https://wiki.archlinux.org/index.php/USB_3G_Modem)

A number of mobile telephone networks around the world offer mobile internet connections over UMTS (or EDGE or GSM) using a portable USB modem device.
```sh
sudo pacman -S --noconfirm usbutils usb_modeswitch modemmanager
sudo systemctl enable ModemManager.service
```

#### SPEED-UP APP STARTUP

Speed up application startup:
```sh
mkdir -p ~/.compose-cache
sudo systemctl enable --now accounts-daemon
sudo /bin/sh -c 'echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.d/99-sysctl.conf'
```

#### CONFIGURE ADDITIONAL FN KEY SHORTCUTS

Install and check output of acpi_listen:
```sh
sudo pacman -S --noconfirm acpid
sudo systemctl enable --now acpid.service
acpi_listen
```
```sh
xev -event keyboard
```
Temporary bug fix
```sh
sudo pacman -U https://archive.archlinux.org/packages/x/xkeyboard-config/xkeyboard-config-2.28-1-any.pkg.tar.xz
```
Create new keyboard symbols
```sh
mkdir -p $HOME/.xkb/symbols
sudo nano $HOME/.xkb/symbols/custom
```
```
partial alphanumeric_keys
xkb_symbols "fn" {
    include "inet(evdev)"
    key <I171>   {      [ End                   ]       };
    key <I172>   {      [ Next, Next            ]       };
    key <I173>   {      [ Home                  ]       };
    key <I174>   {      [ Prior, Prior          ]       };
};
```
Backup existing keyboard map
```sh
mkdir -p $HOME/.xkb/keymap
setxkbmap -print > $HOME/.xkb/keymap/xkbbase
```
```sh
cp $HOME/.xkb/keymap/xkbbase $HOME/.xkb/keymap/xkbcustom
```
Add custom(fn) to xkb_symbols in the new xkbcustom keymap
```
xkb_keymap {
	xkb_keycodes  { include "evdev+aliases(qwerty)"	};
	xkb_types     { include "complete"	};
	xkb_compat    { include "complete"	};
	xkb_symbols   { include "pc+us+inet(evdev)+custom(fn)"	};
	xkb_geometry  { include "pc(pc105)"	};
};
```
Create and enable systemd service to set keyboard map at start of X session
```sh
sudo nano /etc/systemd/system/xkbcomp.service
```
```
[Unit]
Description=Set xkbd map
After=xinitrc.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/xkbcomp -I$HOME/.xkb $HOME/.xkb/keymap/xkbcustom $DISPLAY

[Install]
WantedBy=xinitrc.target
```
Enable the service
```sh
sudo systemctl enable xkbcomp.service
```
```sh
nano ~/.xsession
```
```sh
if [ -d $HOME/.xkb/keymap ]; then
  setxkbmap -print | \
    sed -e '/xkb_symbols/s/"[[:space:]]/+custom(fn)&/' > $HOME/.xkb/keymap/xkbcustom
  xkbcomp -w0 -I$HOME/.xkb -R$HOME/.xkb keymap/xkbcustom $DISPLAY
fi
```


#### INSTALL PACKAGE CLEANER
```sh
sudo pacman -S --noconfirm pacman-contrib
```
```sh
sudo systemctl enable --now paccache.timer
```


## LEARN BASICS OF PACKAGE INSTALLERS

To get started with Arch Linux you need to know how to use "Pacman" and "AUR".

## PACMAN

#### INSTALL PACKAGES

###### SEARCH PAGKAGE
```sh
pacman -Ss <package>
```

###### DETAILS OF UNINSTALLED PACKAGE
```sh
pacman -Si <package>
```

###### INSTALL PACKAGE
```sh
sudo pacman –S <package list>
```

###### DETAILS OF INSTALLED PACKAGE
```sh
pacman -Qi <package>
```

###### LIST OUTDATED PACKAGES
```sh
pacman -Qu
```

###### UPDATE PACKAGES DATABASE
```sh
sudo pacman -Sy
```

#### UPGRADE PACKAGES
```sh
sudo pacman -Syu
```

###### CHECK STORAGE CONSUMPTION
```sh
pacsysclean
```

###### FOREIGN PACKAGES FOR REMOVAL

These packages do not exist on arch repositories and should me removed.
```sh
pacman -Qm
```

###### ORPHANED PACKAGES

Lists orphaned packages, ie. unrequired packages installed as dependency.
```sh
pacman -Qdt
```

#### REMOVE PACKAGES

###### REMOVE ONLY THE PACKAGE
```sh
sudo pacman –R <package list>
```
###### REMOVE PACKAGE WITH DEPENDENCIES AND CONFIGURATIONS
```sh
sudo pacman –Rns <package list>
```
###### RECURSIVELY REMOVE PACKAGE WITH DEPENDENCIES AND CONFIGURATIONS
```sh
sudo pacman –Rnsc <package list>
```
###### FORCE REMOVE PACKAGE IRRESPECTIVE OF DEPENDENCIES
```sh
sudo pacman -Rdd <package list>
```

Learn more about Pacman on the wiki page at:

[https://wiki.archlinux.org/index.php/pacman](https://wiki.archlinux.org/index.php/pacman)



## YAY - AUR HELPER

Most functions are similar to pacman.

#### INSTALL PACKAGES FROM AUR
```sh
yay -S
```

#### UPGRADE DATABASE AND PACKAGES FROM AUR
```sh
yay -Syu --devel --needed
```


# INSTALL APPS

## ACCESSORIES APPS

#### MAKE TERMINAL COOL
```sh
sudo pacman -S --noconfirm fortune-mod cowsay lolcat cmatrix
```
Have some fun with:
```sh
cowsay -l
```
```sh
fortune | cowsay
```
```sh
fortune | lolcat
```
```sh
cowsay $(fortune -o) | lolcat
```
```sh
cmatrix | lolcat
```

#### ACCESSORIES
```sh
sudo pacman -S --noconfirm synapse terminator
sudo pacman -S --noconfirm catfish
```

## OFFICE APPS

#### TEXLIVE

Install LaTeX Environment:
```sh
sudo pacman -S --noconfirm texlive-core texlive-bin texlive-latexextra
```
Install LaTeX IDE
```sh
yay -S --noconfirm texworks
```
Add "ModernCV" class for Resume
```sh
curl -L -O http://mirrors.ctan.org/macros/latex/contrib/moderncv.zip
unzip moderncv.zip && rm moderncv.zip && cd moderncv
sudo mkdir -p /usr/local/share/texmf-dist/tex/latex/moderncv/
sudo cp *.sty *.cls -t /usr/local/share/texmf-dist/tex/latex/moderncv/ && cd .. && rm -rf moderncv
```
Rebuild latex package cache
```sh
sudo mktexlsr
```
Check if "ModernCV" class is correctly installed with:
```sh
kpsewhich moderncv.cls
```

#### LIBREOFFICE

[https://wiki.archlinux.org/index.php/LibreOffice](https://wiki.archlinux.org/index.php/LibreOffice)
```sh
sudo pacman -S --noconfirm libreoffice-fresh
```

## SYSTEM TOOLS

#### FIREWALL

Blocking every request incoming to your system is nice to keep everything safe. I recommend you to install the UFW firewall:
```sh
sudo pacman -S --noconfirm gufw
sudo ufw enable
sudo systemctl enable --now ufw
sudo ufw default deny
sudo ufw logging off
sudo ufw status
```

#### ANTIVIRUS
```sh
sudo pacman -S --noconfirm clamav
sudo systemctl enable --now clamav-daemon.service
sudo systemctl enable --now clamav-freshclam.service
sudo freshclam
```

#### BLOCK ADWARE
```sh
yay -S --noconfirm hosts-update
```
```sh
sudo sed -i 's/^127.0.0.1.*/127.0.0.1       zenbook-pro.localdomain localhost zenbook-pro/' /etc/hosts.local
sudo sed -i 's/^::1.*/::1             zenbook-pro.localdomain localhost zenbook-pro/' /etc/hosts.local
sudo sed -i "$(( `grep -n "^::1" /etc/hosts | cut -f1 -d:` + 1 )) i\127.0.1.1       zenbook-pro.localdomain localhost zenbook-pro" /etc/hosts.local
sudo hosts-update
```

#### HTOP - INTERACTIVE PROCESS VIEWER
```sh
sudo pacman -S --noconfirm htop
```

#### MONITOR NETWORK
```sh
sudo pacman -S --noconfirm netdata nload
sudo systemctl enable --now netdata.service
```

#### VIRTUAL MACHINE
```sh
yay -S --noconfirm vmware-workstation12
```

#### DOCKER
```sh
sudo pacman -S --noconfirm docker
```
```sh
sudo gpasswd -a shubham docker
```

#### WINE
```sh
sudo pacman -S --noconfirm icoutils wine wine_gecko wine-mono winetricks
```

#### INTERNET APPS

#### WEB BROWSERS
```sh
sudo pacman -S --noconfirm chromium
```
```sh
sudo pacman -S --noconfirm firefox
```
```sh
yay -S --noconfirm google-chrome tor-browser
```

#### DOWNLOAD/FILE-SHARE
```sh
sudo pacman -S --noconfirm transmission-gtk
sed -i -e 's/^"blocklist-enabled":.*/"blocklist-enabled": true/' /home/shubham/.config/transmission/settings.json
sed -i -e 's/^www\.example\.com\/blocklist/list\.iblocklist\.com\/\?list=bt_level1&fileformat=p2p&archiveformat=gz/' /home/shubham/.config/transmission/settings.json
```

#### EMAIL CLIENTS
```sh
sudo pacman -S --noconfirm evolution
```
```sh
sudo pacman -S --noconfirm thunderbird
```

#### INSTANT MESSAGING CLIENTS
```sh
sudo pacman -S --noconfirm telegram-desktop
```
```sh
yay -S --noconfirm skypeforlinux-stable-bin
```

#### DESKTOP SHARING
```sh
sudo pacman -S --noconfirm remmina
```
```sh
yay -S --noconfirm teamviewer
```


#### GRAPHICS APPS

#### IMAGE VIEWERS/EDITORS
```sh
sudo pacman -S --noconfirm shotwell gimp imagemagick gthumb
```

#### 3D GRAPHICS
```sh
sudo pacman -S --noconfirm blender inkscape
```

#### SKTECHING
```sh
sudo pacman -S --noconfirm mypaint
```
```sh
yay -S --noconfirm pencil
```

#### PUBLISHING
```sh
sudo pacman -S --noconfirm scribus
```


#### AUDIO

#### AUDIO PLAYERS
```sh
sudo pacman -S --noconfirm rhythmbox grilo grilo-plugins libgpod libdmapsharing gnome-python python-mako
```
```sh
yay -S --noconfirm spotify
```

#### AUDIO CODECS
```sh
sudo pacman -S --noconfirm gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
```

#### AUDIO EDITORS
```sh
sudo pacman -S --noconfirm audacity easytag soundconverter
```


#### VIDEO

#### MULTIMEDIA CODECS
```sh
sudo pacman -S --noconfirm gstreamer flashplugin pepper-flash faac faad2 libdca libmad libmpeg2 x264 x265 libfdk-aac libquicktime
```
```sh
yay -S --noconfirm chromium-widevine
```

#### VIDEO CODECS
```sh
sudo pacman -S --noconfirm ffmpeg ffmpegthumbnailer ffmpegthumbs
```

#### VIDEO PLAYERS
```sh
sudo pacman -S --noconfirm vlc gnome-mplayer mplayer
```
```sh
yay -S --noconfirm --nedit popcorntime-ce
```

#### VIDEO EDITORS
```sh
sudo pacman -S --noconfirm handbrake
```


#### FILE SYSTEMS
```sh
sudo pacman -S --noconfirm btrfs-progs dosfstools e2fsprogs exfat-utils f2fs-tools gpart jfsutils mtools ntfs-3g reiserfsprogs xfsprogs
```


#### MORE PACKAGES
```sh
sudo pacman -S --noconfirm gparted screenfetch dconf-editor bleachbit hdparm dstat seahorse simplescreenrecorder dmenu elinks alacarte speedtest-cli simple-scan deja-dup
```


#### DEVELOPMENT

#### VISUAL CODE STUDIO
```sh
sudo pacman -S --noconfirm code
```

#### ATOM
```sh
sudo pacman -S --noconfirm atom
```

#### GEANY
```sh
sudo pacman -S --noconfirm geany
```

#### EMACS
```sh
sudo pacman -S --noconfirm emacs
```

#### GVIM
```sh
sudo pacman -Rns --noconfirm vim
```
```sh
sudo pacman -S --noconfirm gvim ctags
```

#### MELD
```sh
sudo pacman -S --noconfirm meld
```

#### SUBLIME TEXT 3
```sh
yay -S --noconfirm sublime-text-dev
```

#### OPENJDK 8
```sh
sudo pacman -Rnsc --noconfirm jdk
```
```sh
sudo pacman -S --noconfirm jdk8-openjdk
```

#### OPENJDK 10
```sh
sudo pacman -Rnsc --noconfirm jdk
```
```sh
sudo pacman -S --noconfirm jdk10-openjdk
```

#### ORACLE JDK
```sh
sudo pacman -Rnsc --noconfirm jdk7-openjdk jdk8-openjdk jdk9-openjdk jdk10-openjdk
```
```sh
yay -S --noconfirm jdk
```

#### CONFIGURE JDK

Check the installation with:
```sh
sudo ls /usr/lib/jvm
```
List compatible Java environments installed
```sh
archlinux-java status
```
Change the default Java environment
```sh
sudo archlinux-java set java_environment_name
```
Unset the default Java environment
```sh
sudo archlinux-java unset
```

#### SPRING TOOL SUITE
```sh
yay -S --noconfirm spring-tool-suite
```

#### NETBEANS
```sh
sudo pacman -S --noconfirm netbeans
```

#### ECLIPSE
```sh
sudo pacman -S --noconfirm eclipse-jee
```

#### ANDROID-TOOLS
```sh
sudo pacman -S --noconfirm android-tools
```


#### ANDROID STUDIO
```sh
yay -S --noconfirm android-sdk android-sdk-platform-tools android-sdk-build-tools android-platform
sudo gpasswd -a shubham sdkusers
sudo chown -R :sdkusers /opt/android-sdk/
sudo chmod -R g+w /opt/android-sdk/
sudo /bin/sh -c 'export ANDROID_HOME=/opt/android-sdk >> /home/shubham/.bashrc'
yay -S --noconfirm android-studio
```

#### JETBRAINS TOOLBOX
```sh
yay -S --noconfirm jetbrains-toolbox
```

#### INTELLIJ IDEA
```sh
sudo pacman -S --noconfirm intellij-idea-community-edition
```

#### INTELLIJ IDEA ULTIMATE EDITION
```sh
yay -S --noconfirm intellij-idea-ultimate-edition
```

#### MONODEVELOP
```sh
sudo pacman -S --noconfirm monodevelop monodevelop-debugger-gdb
```

#### QT CREATOR
```sh
sudo pacman -S --noconfirm qtcreator
```

#### MYSQL WORKBENCH
```sh
sudo pacman -S --noconfirm mysql-workbench
```

#### NODEJS
```sh
sudo pacman -S --noconfirm nodejs
```

#### MICROSOFT VISUAL STUDIO CODE
```sh
yay -S --noconfirm visual-studio-code-bin
```

#### GIT GUI-s
```sh
sudo pacman -S --noconfirm gitg qgit
```

#### KDIFF3
```sh
yay -S --noconfirm kdiff3
```

#### REGEXXER
```sh
yay -S --noconfirm regexxer
```

#### POSTMAN
```sh
yay -S --noconfirm postman-bin
```

#### GITKRAKEN
```sh
yay -S --noconfirm gitkraken
```


#### WEBSERVERS

#### LAMP - APACHE, MariaDB & PHP
```sh
sudo pacman -S --noconfirm apache php php-apache php-mcrypt php-gd
```
Complete following steps:
```
INSTALL_MARIADB
INSTALL_ADMINER
SYSTEMCTL ENABLE HTTPD.SERVICE
CONFIGURE_PHP_APACHE
CONFIGURE_PHP "MARIADB"
CREATE_SITES_FOLDER
```

#### LAPP - APACHE, POSTGRESQL & PHP
```sh
sudo pacman -S --noconfirm apache php php-apache php-pgsql php-gd
```
Complete following steps:
```
INSTALL_POSTGRESQL
INSTALL_ADMINER
sudo systemctl enable --now httpd.service
CONFIGURE_PHP_APACHE
CONFIGURE_PHP "POSTGRESQL"
CREATE_SITES_FOLDER
```

#### LEMP - NGINX, MariaDB & PHP
```sh
sudo pacman -S --noconfirm nginx php php-mcrypt php-fpm
```
Complete following steps:
```
INSTALL_MARIADB
sudo systemctl enable --now nginx.service
sudo systemctl enable --now php-fpm.service
CONFIGURE_PHP_NGINX
CONFIGURE_PHP "MARIADB"
```

#### LEPP - NGINX, POSTGRESQL & PHP
```sh
sudo pacman -S --noconfirm nginx php php-fpm php-pgsql
```
Complete following steps:
```
INSTALL_POSTGRESQL
sudo systemctl enable --now nginx.service
sudo systemctl enable --now php-fpm.service
CONFIGURE_PHP_NGINX
CONFIGURE_PHP "POSTGRESQL"
```

#### ADMINER
```sh
yay -S --noconfirm adminer
```
Check config:
```sh
cat /etc/httpd/conf/httpd.conf | grep Adminer
```
If config, does not contain Adminer:
```sh
echo -e '\n# Adminer Configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
```

#### MARIA-DB
```sh
sudo pacman -S --noconfirm mariadb
sudo /usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mysqld.service
sudo /usr/bin/mysql_secure_installation
```

#### POSTGRESQL
```sh
sudo pacman -S --noconfirm postgresql
sudo mkdir -p /var/lib/postgres
sudo chown -R postgres:postgres /var/lib/postgres
systemd-tmpfiles --create postgresql.conf
sudo passwd postgres
su - postgres -c "initdb --locale ${LOCALE}.UTF-8 -D /var/lib/postgres/data"
sudo systemctl enable --now postgresql.service
sudo pacman -S --noconfirm postgis
yay -S --noconfirm pgrouting
```

#### CONFIGURE PHP

If new file exists:
```sh
-f /etc/php/php.ini.pacnew
```
```sh
mv -v /etc/php/php.ini /etc/php/php.ini.pacold
mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
```
For MariaDB:
```sh
sudo sed -i '/mysqli.so/s/^;//' /etc/php/php.ini
sudo sed -i '/mysql.so/s/^;//' /etc/php/php.ini
sudo sed -i '/skip-networking/s/^/#/' /etc/mysql/my.cnf
```
For PostgreSQL:
```sh
sudo sed -i '/pgsql.so/s/^;//' /etc/php/php.ini
```

Finally:
```sh
sudo sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
sudo sed -i '/gd.so/s/^;//' /etc/php/php.ini
sudo sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
```

#### CONFIGURE PHP APACHE

If new file exixts:
```sh
/etc/httpd/conf/httpd.conf.pacnew
```
```sh
mv -v /etc/httpd/conf/httpd.conf.pacnew /etc/httpd/conf/httpd.conf
```
Check if php is disabled:
```sh
cat /etc/httpd/conf/httpd.conf | grep php5_module.conf
```
If disabled, enable with:
```sh
echo -e 'application/x-httpd-php5                php php5' >> /etc/httpd/conf/mime.types

sudo sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
sudo sed -i -e 's/LoadModule mpm_event_module modules\/mod_mpm_event.so/LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so/' /etc/httpd/conf/httpd.conf
sudo sed -i -e 's/DirectoryIndex\ index.html/DirectoryIndex\ index.html\ index.php/' /etc/httpd/conf/httpd.conf
```

#### CONFIGURE PHP NGINX

Check if new file exists:
```sh
/etc/nginx/nginx.conf.pacnew
```
If file exists:
```sh
mv -v /etc/nginx/nginx.conf.pacnew /etc/nginx/nginx.conf
```
```sh
sudo sed -i -e '/location ~ \.php$ {/,/}/d' /etc/nginx/nginx.conf
sudo sed -i -e '/pass the PHP/a\        #\n        location ~ \.php$ {\n            fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;\n            fastcgi_index  index.php;\n            root           /srv/http;\n            include        fastcgi.conf;\n        }' /etc/nginx/nginx.conf
```

#### CREATE SITES FOLDER
```sh
sudo sed -i -e 's/public_html/Sites/' /etc/httpd/conf/extra/httpd-userdir.conf  
sudo /bin/sh -c 'mkdir -p ~/Sites'
sudo /bin/sh -c 'chmod o+x ~/ && chmod -R o+x ~/Sites'
```


## CLEAN ORPHAN PACKAGES
```sh
sudo pacman -Rsc --noconfirm $(pacman -Qqdt)
```

## RECONFIGURE SYSTEM

#### HOSTNAME

[https://wiki.archlinux.org/index.php/HOSTNAME](https://wiki.archlinux.org/index.php/HOSTNAME)

A host name is a unique name created to identify a machine on a network.Host names are restricted to alphanumeric characters.\nThe hyphen (-) can be used, but a host name cannot start or end with it. Length is restricted to 63 characters.
```sh
sudo hostnamectl set-hostname
```

#### TIMEZONE

[https://wiki.archlinux.org/index.php/Timezone](https://wiki.archlinux.org/index.php/Timezone)

In an operating system the time (clock) is determined by four parts: Time value, Time standard, Time Zone, and DST (Daylight Saving Time if applicable).
```sh
sudo timedatectl set-timezone Asia/Kolkata
```

#### HARDWARE CLOCK TIME

[https://wiki.archlinux.org/index.php/Internationalization](https://wiki.archlinux.org/index.php/Internationalization)

This is set in /etc/adjtime. Set the hardware clock mode uniformly between your operating systems on the same machine. Otherwise, they will overwrite the time and cause clock shifts (which can cause time drift correction to be miscalibrated).
```sh
sudo timedatectl set-local-rtc false
```
```sh
sudo timedatectl set-ntp true
```

#### EXTRA

#### BROWSER PROFILE SYNC DAEMON
```sh
yay -S --noconfirm profile-sync-daemon
```
```sh
psd
```
```sh
sed -i 's/^#USE_BACKUPS=.*/USE_BACKUPS="yes"/' /home/shubham/.config/psd/psd.conf
sed -i '/^#BACKUP_LIMIT/s/^#//' /home/shubham/.config/psd/psd.conf
```
```sh
systemctl --user enable --now psd.service
```

#### CHECK BOOT PERFORMANCE
```sh
systemd-analyze
systemd-analyze blame
systemd-analyze critical-chain
systemd-analyze plot > plot.svg
```
Clean systemd journal files manually using journalctl utility to limit its size to [size]MiB. You can specify your own parameters. For example, I prefer to keep it to 100MiB

Journal files are located at /var/log/journal/
```sh
journalctl --vacuum-size=100M
```

## THE END


## CREDITS

This manual refers to several articles and open source packages.

- [Arch Wiki - Installation Guide](https://wiki.archlinux.org/index.php/installation_guide)
- [Arch Wiki - General Recommendations](https://wiki.archlinux.org/index.php/General_recommendations)
- [Arch Wiki - Asus Zenbook Pro UX501](https://wiki.archlinux.org/index.php/ASUS_Zenbook_Pro_UX501)
- [Arter97's Blog - Power Saving Tunings](http://arter97.blogspot.com/2018/08/saving-power-consumption-on-laptops.html)
- [Archlinux Ultimate Install](https://github.com/helmuthdu/aui)
- [Viper4Linux](https://github.com/L3vi47h4N/Viper4Linux)

## RELATED

- [Git Create](https://github.com/shubhamgulati91/create-git-repos-from-cli) - Create Git Repos From Cli
- [Resume](https://github.com/shubhamgulati91/resume) - Resume in LaTeX using ModernCV

## SUPPORT

<a href="https://www.buymeacoffee.com/shubhamgulati" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>&nbsp;&nbsp;&nbsp; OR &nbsp;&nbsp;&nbsp;<a href="https://www.patreon.com/shubhamgulati">
	<img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>

## You may also like...

- [Git Create](https://github.com/shubhamgulati91/create-git-repos-from-cli) - Create Git Repos From Cli
- [Resume](https://github.com/shubhamgulati91/resume) - Resume in LaTeX using ModernCV

## LICENSE

GPL-3.0

---

> [shubhamgulati.com](https://www.shubhamgulati.com) &nbsp;&middot;&nbsp;
> GitHub [@shubhamgulati91](https://github.com/shubhamgulati91) &nbsp;&middot;&nbsp;
> Twitter [@shubhamgulati91](https://twitter.com/shubhamgulati91)
