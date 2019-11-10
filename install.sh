#!/bin/bash
echo "This will fully reset linux"
echo "Ensure ethernet is connected"
read -p "Are you positive?" -n 1 -r Reply
echo
if [[ $Reply =~ ^[Yy]$ ]]
then
  (
  echo d
  echo 6
  echo d
  echo 5
  echo n
  echo 5
  echo
  echo +8G
  echo t
  echo 5
  echo 19
  echo n
  echo 6
  echo
  echo
  echo w
  ) | fdisk /dev/sda
  partprobe
  fdisk -l /dev/sda
  mkswap -L "archSwap" /dev/sda5
  swapon /dev/sda5
  free -m
  (
  echo y
  ) | mkfs.ext4 -L "archRoot" /dev/sda6
  mount /dev/sda6 /mnt
  pacstrap /mnt base base-devel linux linux-firmware
  mkdir -p /mnt/boot/efi
  mount /dev/sda2 /mnt/boot/efi
  genfstab -p /mnt >> /mnt/etc/fstab
  cat /mnt/etc/fstab
  mkdir /mnt/scripts
  cp *.sh /mnt/scripts
  arch-chroot /mnt /scripts/PostChroot.sh
fi
