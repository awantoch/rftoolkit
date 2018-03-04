#!/bin/bash
mkdir -p ~/sdr

echo "INSTALLING GNURADIO AND DEPS"
apt install -yy build-essential kali-linux-sdr python python-pip gnuradio gqrx hackrf\
 libhackrf-dev libhackrf0 automake bison flex g++ git libboost-all-dev libevent-dev\
 libssl-dev pkg-config swig liblog4cpp5-dev
pip install cryptography matplotlib

echo "INSTALLING SCAPY"
cd ~/sdr
if [ ! -d "scapy" ]; then
    git clone https://github.com/secdev/scapy
else
   cd scapy && git pull
fi

echo "INSTALLING RFTAP"
cd ~/sdr
if [ ! -d "gr-rftap" ]; then
    git clone https://github.com/rftap/gr-rftap
    cd gr-rftap
else
    cd gr-rftap && git pull
fi
mkdir -p build
cd build
cmake ..
make
sudo make install
sudo ldconfig

echo "INSTALLING FM RADIO RECEIVER"
cd ~/sdr
mkdir -p fm_rx
cd fm_rx
wget https://raw.githubusercontent.com/rrobotics/hackrf-tests/master/fm_radio/fm_radio_rx.py
wget https://raw.githubusercontent.com/rrobotics/hackrf-tests/master/fm_radio/fm_radio_rx.grc

echo "INSTALLING GR-FOO"
cd ~/sdr
if [ ! -d "gr-foo" ]; then
    git clone https://github.com/bastibl/gr-foo.git
    cd gr-foo && git checkout master
else
    cd gr-foo && git checkout master && git pull
fi
mkdir -p build
cd build
cmake ..
make
sudo make install
sudo ldconfig

echo "INSTALLING GR-IEEE802-11"
cd ~/sdr
grep -q -F 'kernel.shmmax=2147483648' /etc/sysctl.conf || echo 'kernel.shmmax=2147483648' >> /etc/sysctl.conf
sysctl -w kernel.shmmax=2147483648
if [ ! -d "gr-ieee802-11" ]; then
    git clone git://github.com/bastibl/gr-ieee802-11.git
    cd gr-ieee802-11
else
    cd gr-ieee802-11 && git pull
fi
mkdir -p build
cd build
cmake ..
make
sudo make install
sudo ldconfig

echo "INSTALLING GPS SATELLITE SIMULATOR"
cd ~/sdr
if [ ! -d "gps-sdr-sim" ]; then
    git clone https://github.com/osqzss/gps-sdr-sim.git
    cd gps-sdr-sim
else
    cd gps-sdr-sim
    git pull
fi
gcc gpssim.c -lm -O3 -o gps-sdr-sim

