# Architecture

## Data path

1. The laptop joins an upstream Android hotspot through `wlp13s0`.
2. Hiddify establishes the VLESS tunnel exposed as `tun0`.
3. A virtual AP interface named `ap0` is created on the same physical Wi-Fi adapter.
4. `hostapd` advertises the downstream SSID.
5. `dnsmasq` provides DHCP and DNS service.
6. IPv4 forwarding and a dedicated nftables NAT rule translate downstream traffic out through `tun0`.

## Address plan

- AP gateway: `192.168.50.1/24`
- Example DHCP pool: `192.168.50.20-192.168.50.200`
- Tunnel address observed in the tested setup: `172.19.0.1/28`

Hiddify reported a default route via `172.19.0.2` on `tun0` in routing table 2022. Hiddify policy routing is installation-specific; inspect `ip rule` and `ip route show table 2022` on your host.

## Wireless concurrency

The tested Intel Wireless-AC 3165 / `iwlwifi` combination exposed a single-channel concurrency limitation. The upstream and AP virtual interfaces needed to share a channel. The working procedure moved upstream Wi-Fi to 2.4 GHz and derived the AP channel from its frequency. Other adapters may behave differently; inspect `iw list` and the regulatory domain.

## Firewall boundary

The nftables example creates a dedicated IPv4 NAT table and does not flush the system firewall. It is not a complete firewall policy. Existing forward-chain rules must permit traffic. Review firewall managers and Hiddify rules before deployment.
