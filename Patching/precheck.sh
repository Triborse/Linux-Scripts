#!/bin/bash

OUTPUT="/home/tulsi/precheck_$(date +"%d-%m-%Y").txt"

# ================= BASIC INFO =================

echo -e "\nDate & Time Information:" >> "$OUTPUT"
date >> "$OUTPUT" 2>&1

echo -e "\nUptime Information:" >> "$OUTPUT"
uptime >> "$OUTPUT" 2>&1

# ================= FILESYSTEM =================

echo -e "\nMounted Filesystems:" >> "$OUTPUT"
df -Th >> "$OUTPUT" 2>&1

# ================= DISK / STORAGE =================

echo -e "\nBlock IDs Information:" >> "$OUTPUT"
blkid >> "$OUTPUT" 2>&1

echo -e "\nDisk Partition Information:" >> "$OUTPUT"
fdisk -l >> "$OUTPUT" 2>&1

echo -e "\nBlock Storage Information:" >> "$OUTPUT"
lsblk >> "$OUTPUT" 2>&1

echo -e "\nVolume Groups Information:" >> "$OUTPUT"
vgdisplay >> "$OUTPUT" 2>&1

echo -e "\nLogical Volume Information:" >> "$OUTPUT"
lvdisplay >> "$OUTPUT" 2>&1

echo -e "\nMultipathing Information:" >> "$OUTPUT"
multipath -ll >> "$OUTPUT" 2>&1

# ================= NETWORK =================

echo -e "\nNetwork Interfaces:" >> "$OUTPUT"
ip addr show >> "$OUTPUT" 2>&1

echo -e "\nRouting Table Information:" >> "$OUTPUT"
ip route show >> "$OUTPUT" 2>&1

echo -e "\nOpen Ports Information:" >> "$OUTPUT"
ss -tulnp >> "$OUTPUT" 2>&1

# ================= SYSTEM =================

echo -e "\nSystem Memory:" >> "$OUTPUT"
free -m >> "$OUTPUT" 2>&1

echo -e "\nCPU Information:" >> "$OUTPUT"
lscpu >> "$OUTPUT" 2>&1

echo -e "\nTop Resource Utilization:" >> "$OUTPUT"
top -b -n 1 >> "$OUTPUT" 2>&1

# ================= PROCESSES =================

echo -e "\nRunning Processes:" >> "$OUTPUT"
ps -ef >> "$OUTPUT" 2>&1

echo -e "\nTop Processes by Memory:" >> "$OUTPUT"
ps aux --sort=-%mem | head -10 >> "$OUTPUT" 2>&1

echo -e "\nTop Processes by CPU:" >> "$OUTPUT"
ps aux --sort=-%cpu | head -10 >> "$OUTPUT" 2>&1

# ================= SERVICES =================

echo -e "\nService Status:" >> "$OUTPUT"
systemctl list-units --type=service --state=running >> "$OUTPUT" 2>&1

# ================= GRUB =================

echo -e "\nGRUB Configuration:" >> "$OUTPUT"
cat /etc/default/grub >> "$OUTPUT" 2>&1

echo -e "\nKernel Version:" >> "$OUTPUT"
uname -r >> "$OUTPUT" 2>&1

# ================= OS INFO =================
echo -e "\nOS Release Information:" >> "$OUTPUT"
cat /etc/os-release >> "$OUTPUT" 2>&1

echo -e "\nLogged In Users:" >> "$OUTPUT"
who >> "$OUTPUT" 2>&1

echo -e "\nLast Reboot History:" >> "$OUTPUT"
last reboot | head -5 >> "$OUTPUT" 2>&1

# ================= DONE =================

echo -e "\nPrecheck completed successfully!" >> "$OUTPUT"

