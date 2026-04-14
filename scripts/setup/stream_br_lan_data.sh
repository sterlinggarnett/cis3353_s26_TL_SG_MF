#!/bin/bash
# Stream bat0 data from remote router

ssh root@10.18.81.1 "tcpdump -i br-lan -s 0 -U -w -" | docker run -i --rm -v /storage/PCAP/zeek_logs:/data/zeek_logs -w /data/zeek_logs zeek/zeek zeek -C -r - LogAscii::use_json=T
