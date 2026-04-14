#!/bin/bash
# CONNECTING TO HOST INTERFACE

sudo docker run --rm \
--network host \
--cap-add=NET_ADMIN \
--cap-add=NET_RAW \
-v /storage/PCAP/zeek_logs:/data/zeek_logs \
-w /data/zeek_logs \
zeek/zeek \
zeek -i eth0 LogAscii::use_json=T
