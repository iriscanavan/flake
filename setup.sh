#!/usr/bin/env bash

read -p "STOP! Did you grant Full Disk Access for Terminal in System Settings?
^C to terminate if you have not, press return to continue"

echo -n Password: 
read -s password
echo

# nix-darwin
nix run --extra-experimental-features "nix-command flakes" \
	nix-darwin -- switch --flake .#m1

# yabai: enable non-Apple-signed arm64e binaries for Apple Silicon
echo $password | sudo -S nvram boot-args=-arm64e_preview_abi

# Change login shell to bash for iris
echo $password | sudo -S chsh -s /bin/bash iris

# prompt next steps: Partially disable SIP in recovery
printf "\nBoot in to recovery and run\
	\n$ csrutil enable --without fs --without debug --without nvram\n\n"

printf "done!\n\n"

read -p "Press return to poweroff"

echo $password | sudo -S shutdown -h now
