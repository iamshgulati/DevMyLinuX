#!/bin/bash

clear

# Default values
init=0
script_action="test"
iso_directory="$HOME/Downloads"
iso_name=arch
drive_name=sda

args="$(getopt -o 'ia:f:d:' --long initialize,action:,file:,drive: --name "$0" -- "$@")"

if [ $? -ne 0 ]; then
	printf "Usage: %s: [-i|--initialize] [-a|--action value] [-f|--file value] [-d|--drive value]\n" $0 >&2
	exit 1
fi

eval set -- "$args"
unset args

while [ $# -gt 0 ]; do
  case $1 in
  -i | --initialize)
    init=1
    ;;
  -a | --action)
    script_action="$2"
    shift
    ;;
  -f | --file)
    iso_name="$2"
    shift
    ;;
  -d | --drive)
    drive_name="$2"
    shift
    ;;
  --)
    shift
    break
    ;;
  -*)
    echo "$0: Error - Unrecognized option $1" 1>&2
    exit 1
    ;;
  *)
    echo "Internal error" >&2
    exit 1
    ;;
  ?)
    printf "Usage: %s: [-i] [-a value] [-f value] [-d value]\n" $0
    exit 2
    ;;
  esac
  shift
done
shift $(($OPTIND - 1))

if [[ ! -z $* ]]; then
  printf "Unused arguments: %s" "$*"
  echo
  echo
fi

if [[ $init -ne 1 ]]; then
  lsblk
  echo

  read -p "Enter the action[test|write][$script_action]: " script_action_input
  if [[ ! -z $script_action_input ]]; then
    script_action=$script_action_input
  fi
  read -p "Enter the initial name of iso[$iso_name]: " iso_name_input
  if [[ ! -z $iso_name_input ]]; then
    iso_name=$iso_name_input
  fi
  read -p "Enter the name of flash drive[$drive_name]: " drive_name_input
  if [[ ! -z $drive_name_input ]]; then
    drive_name=$drive_name_input
  fi
  
  echo
fi

if [[ ! -z $iso_directory && ! -z $iso_name ]]; then
  iso_file="$(find "$iso_directory" -name "$iso_name*.iso" -printf "%f\n" | head -n 1)"
fi

echo "Run mode: $script_action"
echo "Image dir: $iso_directory"
echo "Image file: $iso_file"
echo "Drive name: $drive_name"
echo

if [[ $script_action == "write" && ! -z $iso_file && ! -z $drive_name ]]; then
  if [[ $(findmnt -M /dev/${drive_name}1) ]]; then
    sudo umount /dev/${drive_name}1
  fi
  sudo dd if=/dev/zero of=/dev/$drive_name bs=4096 count=4096
  sudo wipefs -af /dev/$drive_name
  sudo parted --script -a optimal /dev/$drive_name \
    mklabel gpt \
    mkpart primary fat32 0% 100% \
    name 1 ${iso_name^^}
  sudo parted /dev/$drive_name 'unit GiB print'
  gdisk -l /dev/$drive_name
  echo
  sudo mkfs.vfat -F32 -n ${iso_name^^} /dev/${drive_name}1
  lsblk /dev/$drive_name
  echo

  sudo dd bs=4M if=$iso_file of=/dev/$drive_name status=progress oflag=sync

  echo
  lsblk /dev/$drive_name
  echo
fi
