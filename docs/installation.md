# Installation

Manual deployment based on the tested Linux Mint 22.3 setup. Adapt paths and interface names to your host.

## Prerequisites

- Linux with `iw`, `iproute2`, `nftables`, `hostapd`, `dnsmasq`, `nmcli` and `sysctl`.
- Hiddify installed and configured independently.
- Connected Hiddify tunnel exposed as `tun0`.
- Wi-Fi adapter capable of concurrent managed and AP virtual interfaces.
- Upstream 2.4 GHz Wi-Fi for the supplied startup script.

## 1. Inspect adapter and connection

```bash
iw list
iw dev
iw dev wlp13s0 link
```

Check supported interface combinations, channel limits and regulatory restrictions.

## 2. Connect Hiddify

Connect upstream Wi-Fi and start Hiddify. Confirm:

```bash
ip link show tun0
ip rule
ip route show table 2022
```

Names may differ on other installations.

## 3. Install example configuration

Review and copy:
- `config/hostapd.conf.example` to `/etc/hostapd/pashani-test.conf`
- `config/dnsmasq.conf.example` to `/etc/dnsmasq-pashani.conf`
- `config/nftables.conf.example` to `/etc/pashani-gw.nft`

Set a unique Wi-Fi passphrase. Keep the resulting private config out of Git.

## 4. Install scripts

```bash
sudo install -m 0755 scripts/pashani-ap-up /usr/local/sbin/pashani-ap-up
sudo install -m 0755 scripts/pashani-ap-down /usr/local/sbin/pashani-ap-down
```

Restrict access to the hostapd configuration because it contains the Wi-Fi passphrase.

## 5. Start and verify

```bash
sudo pashani-ap-up
iw dev ap0 info
ip addr show ap0
sysctl net.ipv4.ip_forward
```

Connect a client and confirm it receives an address from the configured DHCP range.

## 6. Stop

```bash
sudo pashani-ap-down
```

The shutdown script removes the AP interface and stops processes referenced by project PID files. The nftables table is intentionally not flushed. Remove it manually only after confirming it is no longer needed.
