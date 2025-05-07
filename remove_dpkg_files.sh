#!/bin/bash

# This is a little script to help me clean up some leftover XFCE files after I
# uninstalled the desktop environment, ran cleanup, etc. using APT commands

# List all XFCE packages that are still in dpkg and capture output in text file
dpkg -l | grep xfce > dpkg-xfce.txt

# Use awk to extract only the second column, which contains the package names,
# save output to a new file
awk '{print $2}' dpkg-xfce.txt > pkg-names.txt

# Iterate over list of package names, uninstall each one with dpkg;
# "IFS= " preserves leading/trailing whitespace, since the package names are
# only separated by newlines; "read -r pkg" reads text line by line and stores
# each entry in "pkg"
while IFS= read pkg; do
  sudo dpkg --remove "$pkg"
  echo "{$pkg} has been uninstalled."
done < pkg-names.txt

# Verify whether packages were successfully uninstalled
echo "Checking for any remaining XFCE files in dpkg..."
dpkg -l | grep xfce

# Clean up
echo "Cleaning up temporary text files..."
rm ./dpkg-xfce.txt ./pkg-names.txt
