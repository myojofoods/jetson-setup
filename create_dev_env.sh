#!/bin/bash

#update-------------------------------------------------------------
sudo apt update 
sudo apt upgrade -y

#SDcard settings----------------------------------------------------
echo ""
echo ">>> Installing utils for external sdcard (format: exfat)"
sudo apt install -y exfat-fuse exfat-utils

#python settings----------------------------------------------------
echo ""
echo ">>> Setting python3 as default"
cd /usr/bin
sudo unlink python
sudo ln -s python3 python

#UnixBench----------------------------------------------------------
echo ""
echo ">>> Downloading UnixBench"
cd ~
git clone https://github.com/kdlucas/byte-unixbench

#jetsonUtilities----------------------------------------------------
echo ""
echo ">>> Installing jetsonUtilities"
cd ~
git clone https://github.com/jetsonhacks/jetsonUtilities
cd jetsonUtilities
python jetsonInfo.py

#Jetson stats-------------------------------------------------------
echo ""
echo ">>> Installing Jetson stats (launch with jtop)"
sudo apt install python-pip
sudo pip install -U pip
sudo pip install jetson-stats
echo ">>> Reboot to enable jetson-stats"

#jetson thermal monitor---------------------------------------------
echo ""
echo ">>> Installing jetson thermal monitor "
#Usage: cd ~/jetson-thermal-monitor/ -> python jetson_temp_monitor.py
cd ~
sudo apt install -y python3-pip libfreetype6-dev python3-numpy python3-matplotlib
git clone https://github.com/tsutof/jetson-thermal-monitor

#Desktop env--------------------------------------------------------
echo ""
echo ">>> Setting for remote desktop environment"
sudo apt install -y xrdp
echo lxsession > ~/.xsession
echo ">>> Set IP address manually and after chaging the IP adress, you can connect this device from remote desktop."

#Docker-Compose settings--------------------------------------------
echo ""
echo ">>> Setup pip and docker compose"
sudo apt install -y curl python3-testresources
curl -kL https://bootstrap.pypa.io/get-pip.py | python3
python3 -m pip install --user docker-compose

echo '' >> ~/.bashrc
echo '#added for docker compose' >> ~/.bashrc
echo 'PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
source ~/.bashrc
sudo gpasswd -a $USER docker
echo ">>> Please re-login to enable group settings"

#setting sudoers for app--------------------------------------------
cat << EOF

>>> Edit sudoers for easy access to jetson_clocks and nvpmodel for application.
>>> Use visudo and write following settings.
**************************************************************
# Easy access to jetson_clocks and nvpmodel for application
%sudo   ALL=NOPASSWD: /usr/bin/jetson_clocks
%sudo   ALL=NOPASSWD: /usr/sbin/nvpmodel
%sudo   ALL=NOPASSWD: /sbin/ifconfig
%sudo   ALL=NOPASSWD: /sbin/sysctl
**************************************************************
EOF
read -r -p "Press [Enter] if it's done."

#setting env for app--------------------------------------------
cat << EOF

>>> Add following settings to ~/.profile for application.
>>> Please replace <> with appropriate settings (Refer to jtop command).
**************************************************************"
# added for application
sudo nvpmodel -m <JETSON_CLOCKS_MODE>
sudo jetson_clocks

export L4T_CONTAINER_VERSION=<L4T_CONTAINER_VERSION>
export CUDA_ARCH_VERSION=<CUDA_ARCH_VERSION>
export TENSORRT_VERSION=<TENSORRT_VERSION>
**************************************************************"
EOF
read -r -p "Press [Enter] if it's done."


#VS Code------------------------------------------------------------
cat << EOF

>>> Setup vscode from here
https://code.visualstudio.com/#alt-downloads

EOF


read -r -p "Press [Enter] key to finish."
