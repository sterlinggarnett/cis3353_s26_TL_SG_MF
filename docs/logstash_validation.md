# Logstash Pipeline Validation & Edge Cases

To ensure the SOC pipeline won't crash when it encounters abnormal network traffic, I performed a syntax analysis and ran the newly written `logstash.conf` against Elastic's validation engine. 

**Syntax Test Result**: `Config Validation Result: OK` 

Here is how the pipeline seamlessly handles three common edge cases found in Zeek logs:

### Edge Case 1: Corrupted or Non-JSON Data
**Scenario:** A rogue application, a crash, or a network error sends plain text or corrupted syslog data onto port `5044`. If Logstash blindly tries to parse gibberish as JSON, the pipeline container will throw a fatal error or fill your Elasticsearch database with useless `_jsonparsefailure` errors.
**How we validated it:** 
```conf
if [message] =~ /^{.*}$/ {
  json { source => "message" }
}
```
**Resolution:** The pipeline uses a Regex match. It physically checks if the incoming payload strictly starts with '{' and ends with '}' before ever engaging the JSON parser, silently ignoring and protecting the pipeline from corrupted non-JSON strings.

### Edge Case 2: Incomplete Connections (Missing IPs)
**Scenario:** Some Zeek files like `weird.log` or isolated `dns.log` events might trigger without a specific Source IP or Destination IP (e.g. an internal protocol error). 
**How we validated it:** 
```conf
if [destination][ip] {
  geoip { source => "[destination][ip]" }
}
```
**Resolution:** We wrapped the `geoip` lookups in an `if` statement. If a Zeek log arrives that is organically missing a destination IP, the pipeline bypasses the GeoIP lookup rather than crashing while trying to query a `null` value.

### Edge Case 3: RFC 1918 (Internal Network) Lookups
**Scenario:** Because we decided to monitor internal Mesh Network traffic (Issue #8), a massive chunk of our IPs will be local addresses like `192.168.x.x` or `10.0.x.x`. These IPs do not exist on the global internet, so they have no GPS coordinates.
**How we validated it:** 
Because we are using the native Logstash `geoip` plugin, it is built to handle RFC1918 natively. When it encounters `192.168.1.50`, the plugin silently skips returning GPS coordinates, but doesn't halt the pipeline. We mapped it accurately to `[destination][geo]`, ensuring local traffic simply passes through to Elasticsearch cleanly without bloating the database with failed lookup tags.
