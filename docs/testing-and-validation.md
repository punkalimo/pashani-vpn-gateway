# Testing and validation

## Demonstrated result

In the original test, a Hisense VIDAA TV connected to the Pashani-VPN access point and streaming applications operated. The public IPv4 observed from the TV matched the VPN egress IPv4 previously observed from the laptop.

This supports matching observed IPv4 egress for that test. It does not prove DNS leak prevention, IPv6 protection, kill-switch behaviour or every traffic path.

## Repeatable checklist

### Interfaces and routing

```bash
iw dev
iw dev wlp13s0 link
ip -br addr
ip rule
ip route
ip route show table 2022
```

### AP and DHCP

- [ ] `ap0` exists and reports `type AP`.
- [ ] Expected SSID is visible.
- [ ] Client can associate and authenticate.
- [ ] Client receives an address in the DHCP range.
- [ ] Client receives gateway and DNS settings of `192.168.50.1`.

### IPv4 egress

1. Record laptop public IPv4 while Hiddify is connected.
2. Check public IPv4 from the downstream client.
3. Compare results and record date, client and tunnel state.

### Further tests before sensitive use

- [ ] Verify downstream DNS resolver and egress behaviour.
- [ ] Check IPv6 connectivity and leaks; this prototype does not provide comprehensive IPv6 leak protection.
- [ ] Disconnect Hiddify while a client is active and observe whether traffic can leave through the ordinary upstream route. Do not claim a kill switch unless independently verified.
- [ ] Test recovery after upstream Wi-Fi interruption.
- [ ] Test AP restart and system reboot.
- [ ] Confirm Docker, libvirt, LXC and other host networking continue to work.

Capture sanitized outputs of `iw list`, `iw dev`, `ip addr`, `ip rule`, `ip route show table 2022` and relevant logs. Never publish credentials, VLESS URIs or private configuration.
