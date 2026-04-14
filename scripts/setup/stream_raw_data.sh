#!/bin/bash
# FOR STREAMING RAW DATA

sudo tcpdump -i eth0 -s 0 -U -w - | \
sudo docker run -i --rm \
-v /storage/PCAP/zeek_logs:/data/zeek_logs \
-w /data/zeek_logs \
zeek/zeek \
zeek -r - LogAscii::use_json=T
