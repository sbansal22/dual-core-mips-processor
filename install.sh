#!/bin/bash
# Bash script to install verilog dependencies to run dual core MIPS processor

# MARS mips - Already contained within the bin folder
#xdg-open https://softpedia-secure-download.com/dl/382c0bb581a99bbd0c9cd908bd84452c/5f9f6dc0/100178356/software/programming/Mars45.jar

# Install Verilog
sudo apt-get install autoconf -y
sudo apt install gperf -y
sudo apt-get install flex -y
sudo apt-get install bison -y
git clone git://github.com/steveicarus/iverilog.git
cd ~
cd iverilog
git checkout --track -b v11-branch origin/v11-branch
git pull
sudo chmod +x autoconf.sh
sh autoconf.sh
./configure
make
make install
cd ~

# verilator
apt-get install verilator -y

# gtkwave
sudo apt install gtkwave -y

# java
sudo apt install openjdk-8-jre -y