#!/bin/bash
#Erick Prieto Ruiz.
#Check if the names of files and directories are valid for One Drive.
#use ./check_one_drive_names.sh /Directory/name
#2024-Jul-06
#TODO subfix and final period, special requirments 
#https://support.microsoft.com/en-us/office/onedrive-can-rename-files-with-invalid-characters-99333564-c2ed-4e78-8936-7c773e958881#bkmk_manualrename

# Function to check if a name is invalid according to OneDrive restrictions
is_invalid_name() {
  local name="$1"
  # Check for invalid characters
  if [[ "$name" =~ [\/\\:*?\"\<\>\|] ]]; then
    return 0
  fi
  # Check for invalid names
  case "$name" in
    "CON"|"PRN"|"AUX"|"NUL"|"COM1"|"COM2"|"COM3"|"COM4"|"COM5"|"COM6"|"COM7"|"COM8"|"COM9"|"LPT1"|"LPT2"|"LPT3"|"LPT4"|"LPT5"|"LPT6"|"LPT7"|"LPT8"|"LPT9")
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Function to check all files and directories recursively
check_names() {
  local path="$1"
  for item in "$path"/*; do
    if [ -e "$item" ]; then
      local base_name
      base_name=$(basename "$item")
      if is_invalid_name "$base_name"; then
        echo "Invalid name: $item"
      fi
      if [ -d "$item" ]; then
        check_names "$item"
      fi
    fi
  done
}

# Main script
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

check_names "$1"
