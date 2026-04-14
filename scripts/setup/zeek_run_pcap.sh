#!/bin/bash
# Zeek RUN command

docker run --rm \
-v /storage/PCAP:/data \
-w /data/zeek_logs \
zeek/zeek \
zeek -r /data/http.pcap LogAscii::use_json=T
