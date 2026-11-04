# Troubleshooting

## tun0 is missing

Connect Hiddify first, then check `ip link show tun0` and `ip -br addr`. The tunnel name may differ on another installation.

## Upstream Wi-Fi is not connected or not 2.4 GHz

The script expects `wlp13s0` to be connected at 2412–2462 MHz. Reconnect to a supported 2.4 GHz upstream network.

## AP creation fails with Invalid argument

Inspect `iw list`, `iw dev` and `iw dev wlp13s0 link`. The tested Intel Wireless-AC 3165 setup had a single-channel concurrency limitation. Driver, firmware, regulatory domain and hardware affect support.

## hostapd fails

Inspect `/var/log/hostapd-pashani.log`. Check interface name, nl80211 support, channel, regulatory domain and passphrase configuration.

## Client receives no IP address

Inspect `/var/log/dnsmasq-pashani.log`, run `pgrep -a dnsmasq`, and check `ip addr show ap0`. Ensure the DHCP pool belongs to `192.168.50.0/24` and no other DHCP server is bound to the AP interface.

## Client gets an IP but cannot reach the internet

Check:

```bash
sysctl net.ipv4.ip_forward
ip rule
ip route show table 2022
sudo nft list table ip pashani_gw
```

The example NAT rule does not override a host firewall's forward-chain policy. Inspect the full ruleset and Hiddify integration before changing anything. Avoid global firewall flushes on hosts running Docker, libvirt, LXC or other network services.

## VPN disconnects while AP is active

This prototype has not demonstrated a kill switch. Stop the AP or disconnect downstream clients while investigating. Do not assume traffic is blocked from using the ordinary upstream route.
