#!/usr/bin/env bash
set -u
echo "== Pashani VPN Gateway diagnostics =="

for cmd in ip iw nft sysctl; do
  command -v "$cmd" >/dev/null 2>&1 || echo "MISSING: $cmd"
done

echo
echo "-- Interfaces --"
ip -br link 2>&1 || true
ip -br addr 2>&1 || true

echo
echo "-- Upstream Wi-Fi --"
iw dev wlp13s0 link 2>&1 || true

echo
echo "-- AP interface --"
iw dev ap0 info 2>&1 || true

echo
echo "-- IPv4 forwarding --"
sysctl net.ipv4.ip_forward 2>&1 || true

echo
echo "-- Policy rules --"
ip rule 2>&1 || true

echo
echo "-- Hiddify table 2022 --"
ip route show table 2022 2>&1 || true

echo
echo "-- Project NAT table --"
nft list table ip pashani_gw 2>&1 || true

echo
echo "Diagnostics complete. Redact sensitive details before sharing output."
