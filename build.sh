#!/bin/sh
#
# Build a Docker image suitable for use as part of a project's software 
# development infrastructure (vscode-server).
#

# First step: Ensure that the distribution container is up-to-date and then
# we perform our first round of installations; we cannot proceed to the next 
# step until the curl package has been installed.
apt-get update && apt-get install -y \
  gpg curl git ca-certificates bash procps

# Second step: Pull the latest repository key(s), verify and then add them to
# the system keyring for future updates.
curl "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor > "microsoft.gpg";
install -o root -g root -m 644 "microsoft.gpg" "/etc/apt/keyrings/microsoft-archive-keyring.gpg";

# Lastly, we must write the repository configuration out to a file that 
# apt-get shall read upon the next update.
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > \
  /etc/apt/sources.list.d/vscode.list';

# Speaking of updates: this is our last system update before we begin install
# of the packages that we wrote this repository for!
apt-get update && apt-get install -y \
  code
