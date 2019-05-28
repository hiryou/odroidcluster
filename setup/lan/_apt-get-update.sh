#!/usr/bin/env bash
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi

echo
echo "[*] Updating apts.. "
sleep 1
apt-get update
dpkg --configure -a
if [[ $? -ne 0 ]]; then
    echo "Failed half way. Restart this node then re-run this setup."
    exit 1
fi

echo
echo "[*] Upgrading apts.. "
sleep 1
echo "Y" | apt-get upgrade
if [[ $? -ne 0 ]]; then
    echo "Failed half way. Restart this node then re-run this setup."
    exit 1
fi

echo
echo "[*] Auto-removing apts.. "
sleep 1
echo "Y" | apt autoremove

rm /var/lib/dpkg/lock
rm /var/cache/apt/archives/lock
