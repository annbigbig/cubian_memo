#!/bin/bash
# ============ Set your network parameters here ===================================================
iptables=/sbin/iptables
loopback=127.0.0.1
local=10.1.1.160
lan=10.1.1.0/24
# =================================================================================================
$iptables -t filter -F
$iptables -t filter -A INPUT -i lo -s $loopback -d $loopback -p all -j ACCEPT
$iptables -t filter -A INPUT -i eth0 -s $local -d $local -p all -j ACCEPT
$iptables -t filter -A INPUT -d $local -p tcp --dport 36000 --syn -m state --state NEW -j ACCEPT
$iptables -t filter -A INPUT -d $local -p tcp --dport 80 --syn -m state --state NEW -m limit --limit 10/s --limit-burst 40 -j ACCEPT
$iptables -t filter -A INPUT -d $local -p tcp --dport 80 --syn -m state --state NEW -j DROP
#$iptables -t filter -A INPUT -d $local -p tcp --dport 443 --syn -m state --state NEW -m limit --limit 10/s --limit-burst 40 -j ACCEPT
#$iptables -t filter -A INPUT -d $local -p tcp --dport 443 --syn -m state --state NEW -j DROP
$iptables -t filter -A INPUT -p icmp --icmp-type 8 -m recent --name icmp_db --update --second 60 --hitcount 6 -j DROP
$iptables -t filter -A INPUT -p icmp --icmp-type 8 -m recent --set --name icmp_db
$iptables -t filter -A INPUT -s $lan -d $local -p icmp -j ACCEPT
$iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$iptables -t filter -P INPUT DROP
$iptables -t filter -L -n --line-number
# =================================================================================================

