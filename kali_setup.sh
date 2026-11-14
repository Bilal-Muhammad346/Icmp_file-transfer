#kali:

cat > calc.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>

int main() {
    int a, b, choice;
    printf("=== DUMMY CALCULATOR ===\n");
    printf("Enter first number: ");
    scanf("%d", &a);
    printf("Enter second number: ");
    scanf("%d", &b);
    printf("1. Add\n2. Subtract\n3. Multiply\n4. Divide\nChoice: ");
    scanf("%d", &choice);
    
    switch(choice) {
        case 1: printf("Result: %d\n", a+b); break;
        case 2: printf("Result: %d\n", a-b); break;
        case 3: printf("Result: %d\n", a*b); break;
        case 4: printf("Result: %d\n", a/b); break;
    }
    system("pause");
    return 0;
}
EOF
----------------------------------

# Compile for Windows (64-bit)
x86_64-w64-mingw32-gcc calc.c -o calculator.exe

-----------------------------------

cat > icmp_sender.py << 'EOF'
#!/usr/bin/env python3
from scapy.all import *
import sys
import time

def send_file(target_ip, file_path):
    # Read file as bytes
    with open(file_path, 'rb') as f:
        data = f.read()
    
    file_size = len(data)
    print(f"[+] File size: {file_size} bytes")
    
    # Send filename first (as ICMP packet)
    filename = file_path.split('/')[-1].encode()
    pkt = IP(dst=target_ip)/ICMP(type="echo-request", id=1234)/filename
    send(pkt, verbose=0)
    print(f"[+] Sent filename: {file_path}")
    time.sleep(0.5)
    
    # Send file size
    size_pkt = IP(dst=target_ip)/ICMP(type="echo-request", id=1235)/str(file_size).encode()
    send(size_pkt, verbose=0)
    print(f"[+] Sent file size")
    time.sleep(0.5)
    
    # Chunk size (max ICMP payload ~1400 bytes to be safe)
    chunk_size = 1300
    chunks = [data[i:i+chunk_size] for i in range(0, len(data), chunk_size)]
    total_chunks = len(chunks)
    
    print(f"[+] Sending {total_chunks} chunks...")
    
    for i, chunk in enumerate(chunks):
        # Create ICMP packet with chunk data
        pkt = IP(dst=target_ip)/ICMP(type="echo-request", id=1236, seq=i)/chunk
        send(pkt, verbose=0)
        print(f"    Chunk {i+1}/{total_chunks} sent ({len(chunk)} bytes)")
        time.sleep(0.1)  # Small delay to avoid flooding
    
    # Send completion signal
    done_pkt = IP(dst=target_ip)/ICMP(type="echo-request", id=1237)/b"TRANSFER_COMPLETE"
    send(done_pkt, verbose=0)
    print(f"[+] Transfer complete!")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: sudo python3 {sys.argv[0]} <target_ip> <file_path>")
        sys.exit(1)
    
    target_ip = sys.argv[1]
    file_path = sys.argv[2]
    send_file(target_ip, file_path)
EOF




sudo python3 icmp_sender.py <windows-ip> calculator.exe
