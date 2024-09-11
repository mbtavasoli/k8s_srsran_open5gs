#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <pcap_file>"
    exit 1
fi

INTERFACE="n3"       # Change this to your desired network interface
PCAP_FILE=$1  # Change this to the path of your pcap file

tcpreplay -i $INTERFACE -l 10 --timer=nano $PCAP_FILE 2>/dev/null