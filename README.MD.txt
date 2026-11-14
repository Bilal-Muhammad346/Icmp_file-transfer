ICMP File Transfer Lab — Python & Scapy

Overview

This project explores ICMP packet handling in a controlled cybersecurity lab using Kali Linux, Windows 10, Python, and Scapy.

Objectives

- Understand ICMP Echo Request packets.
- Learn how Python and Scapy handle network packets.
- Observe custom ICMP identifiers and payloads.
- Understand the security risks of covert channels over ICMP.
- Explore methods for detecting suspicious ICMP traffic.

Lab Environment

- Sender: Kali Linux
- Receiver: Windows 10
- Language: Python
- Library: Scapy
- Test program: C calculator application

Workflow

1. Prepare the lab environments.
2. Generate and inspect ICMP packets.
3. Observe packet identifiers and payloads.
4. Examine receiver-side packet handling.
5. Analyze network traffic and document the results.

Security Considerations

ICMP can be abused to conceal data transfer inside network traffic. Unexpected ICMP payload sizes, unusual packet patterns, and repeated custom identifiers may warrant investigation.

Defensive Recommendations

- Monitor ICMP traffic using Wireshark or an appropriate IDS.
- Apply firewall rules to restrict unnecessary ICMP traffic.
- Investigate unusual outbound ICMP patterns.
- Use endpoint monitoring and network logs to support investigations.

Disclaimer

This project is intended for authorized cybersecurity education and controlled lab testing only. Do not use these techniques on systems or networks without permission.