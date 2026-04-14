# Suburban-SOC Network Pipeline

This repository contains the configuration files and documentation for the end-to-end Zeek and ELK network packet analysis pipeline built for the openWrt SOC project.

## Contents
* `/configs/filebeat.yml`: The shipper agent configuration.
* `/configs/logstash.conf`: The data parser and forwarder.
* `/docs/Zeek_ELK_Pipeline.md`: The complete guide to recreating the architecture.

## Architecture
Raw PCAP ➔ Zeek (JSON logs) ➔ Filebeat ➔ Logstash ➔ Elasticsearch ➔ Kibana
