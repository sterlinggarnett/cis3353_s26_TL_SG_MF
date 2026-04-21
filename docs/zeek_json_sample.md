# Zeek JSON Log Sample

When you process a PCAP file or monitor a live interface using Zeek with JSON output enabled, Zeek automatically translates its traditional Tab-Separated logs into highly structured JSON files. 

For instance, a connection logged in `conn.log` will be generated with a structure exactly like this:

```json
{
  "ts": 1713634200.123456,
  "uid": "CHhAvVGS1DHF5uNf6",
  "id.orig_h": "192.168.1.50",
  "id.orig_p": 54321,
  "id.resp_h": "104.18.32.7",
  "id.resp_p": 443,
  "proto": "tcp",
  "service": "ssl",
  "duration": 1.4523,
  "orig_bytes": 1420,
  "resp_bytes": 8540,
  "conn_state": "SF",
  "local_orig": true,
  "local_resp": false,
  "missed_bytes": 0,
  "history": "ShADadFf",
  "orig_pkts": 10,
  "orig_ip_bytes": 1940,
  "resp_pkts": 12,
  "resp_ip_bytes": 9180
}
```

### Key Field Breakdown:
* **`ts`**: The epoch timestamp of when the event occurred.
* **`uid`**: A unique Zeek identifier for this specific connection. If this connection appears in a `dns.log` or `http.log`, they will share this exact same `uid`, allowing you to correlate logs in Kibana!
* **`id.orig_h`** & **`id.orig_p`**: The Originating Source IP and Port (e.g. your mesh client).
* **`id.resp_h`** & **`id.resp_p`**: The Responding Destination IP and Port (e.g. an external web server).
* **`proto`** & **`service`**: The Network protocol (TCP) and resolved application service (SSL/HTTPS).
* **`conn_state`**: The state of the connection (`SF` means Normal SYN/FIN completion).

This JSON structure is precisely what Filebeat reads and what Logstash processes before inserting it into Elasticsearch.
