# Pashani VPN Gateway

A Linux-based Wi-Fi gateway that shares an existing Hiddify-managed VLESS VPN tunnel with devices that cannot run the required VPN client themselves, such as smart TVs and game consoles.

**Status:** working prototype / documented field implementation. On the original Linux Mint 22.3 setup, a Hisense VIDAA TV connected and its observed public IPv4 matched the VPN egress IPv4 observed on the laptop. DNS leak prevention, IPv6 leak prevention, a kill switch, reboot recovery and production hardening have not been demonstrated and are not claimed.

## Topology

```text
Android hotspot / upstream Wi-Fi
              |
           wlp13s0
       Linux Mint 22.3
              |
      Hiddify VLESS tunnel
             tun0
              |
       IPv4 forwarding
        + nftables NAT
              |
             ap0
      hostapd + dnsmasq
              |
        Pashani-VPN SSID
              |
       Hisense VIDAA TV
              |
        VPN public egress
```

## Components

| Component | Role |
|---|---|
| Hiddify | Existing VLESS VPN connection |
| iw / iproute2 | Wireless interface, addressing and routing |
| hostapd | Wi-Fi access point |
| dnsmasq | DHCP and DNS service for clients |
| nftables | IPv4 NAT and firewall integration |
| sysctl | IPv4 forwarding |
| Bash | AP startup and shutdown automation |

## Tested interface layout

| Interface | Role | Observed details |
|---|---|---|
| wlp13s0 | Upstream Wi-Fi client | Connected to Android hotspot |
| tun0 | Hiddify tunnel | 172.19.0.1/28 |
| ap0 | Virtual access point | 192.168.50.1/24 |

Hiddify reported a default route via 172.19.0.2 on tun0 in routing table 2022. This is installation-specific; inspect your own policy rules and routes.

## Hardware constraint

The tested Intel Wireless-AC 3165 / iwlwifi setup exposed a single-channel concurrency constraint for managed and AP virtual interfaces. The upstream was initially on 5 GHz (5805 MHz / channel 161), and configuring the AP on that channel failed. The working startup script therefore expects upstream Wi-Fi on 2.4 GHz (2412–2462 MHz) and derives the AP channel from the upstream frequency. This is an observed constraint of the tested adapter/driver/regulatory setup, not a universal rule.

## Quick start

These are example files; review and adapt them before use.

1. Install and configure Hiddify separately. Connect the VPN and confirm that tun0 exists.
2. Check that your adapter supports concurrent managed and AP interfaces: `iw list`.
3. Connect upstream Wi-Fi to a 2.4 GHz network.
4. Copy and review:
   - `config/hostapd.conf.example` → `/etc/hostapd/pashani-test.conf`
   - `config/dnsmasq.conf.example` → `/etc/dnsmasq-pashani.conf`
   - `config/nftables.conf.example` → `/etc/pashani-gw.nft`
5. Replace the example Wi-Fi passphrase with a strong unique value.
6. Install scripts:
   ```bash
   sudo install -m 0755 scripts/pashani-ap-up /usr/local/sbin/pashani-ap-up
   sudo install -m 0755 scripts/pashani-ap-down /usr/local/sbin/pashani-ap-down
   ```
7. Start with `sudo pashani-ap-up`; stop with `sudo pashani-ap-down`.

## Operational checks

```bash
iw dev
iw dev wlp13s0 link
ip -br addr
ip rule
ip route show table 2022
sysctl net.ipv4.ip_forward
sudo tail -n 100 /var/log/hostapd-pashani.log
sudo tail -n 100 /var/log/dnsmasq-pashani.log
```

## Validation and limitations

In the original test, the TV connected and streaming applications worked. The public IPv4 observed from the TV matched the VPN egress IPv4 previously observed on the laptop. This supports the conclusion that the TV's tested IPv4 traffic used the same public egress. It does not prove DNS privacy, IPv6 protection, absence of split tunnelling or kill-switch behaviour.

- Hiddify must be connected before AP startup.
- The supplied script expects upstream 2.4 GHz Wi-Fi.
- Wi-Fi channel support depends on hardware and regulatory settings.
- The nftables example adds a dedicated NAT table; it is not a complete host firewall policy.
- VPN-disconnect behaviour has not been hardened or validated as a kill switch.
- IPv6 handling is incomplete and not validated.
- Review firewall changes carefully. Do not globally flush nftables on a host running Docker, libvirt, LXC or other network services.

See [architecture](docs/architecture.md), [installation](docs/installation.md), [testing](docs/testing-and-validation.md) and [troubleshooting](docs/troubleshooting.md).

## License

MIT. See [LICENSE](LICENSE).
