# Security Policy

This repository documents a networking prototype. It is not a hardened VPN appliance and does not currently claim DNS leak prevention, IPv6 leak prevention or kill-switch enforcement.

Do not publish VPN profiles, VLESS URIs, passwords, tokens or private deployment details in public issues. Report suspected vulnerabilities privately to the repository maintainer through GitHub.

Use unique Wi-Fi credentials and keep them out of Git. Review firewall changes before applying them. Do not assume downstream traffic remains protected if the VPN tunnel disconnects. Validate DNS and IPv6 behaviour independently before relying on this gateway for sensitive traffic.
