#!/bin/bash
# /etc/iptables/rules.sh
set -euo pipefail

log() {
  echo "[+] $1"
}

log "清除現有規則"
iptables -F
iptables -X
iptables -t nat -F
iptables -t mangle -F

log "設定預設政策（DROP）白名單策略"
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

log "允許已建立與相關連線"
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

log "允許 loopback"
iptables -A INPUT -i lo -j ACCEPT

log "允許 SSH 連線(22)"
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT

log "允許 ICMP (ping)"
iptables -A INPUT -p icmp -j ACCEPT

# -------------------------------
# libvirt (virbr0) NAT 與轉發
# -------------------------------
log "允許 libvirt VM 透過 virbr0 出網"
iptables -A FORWARD -i virbr0 -j ACCEPT
iptables -A FORWARD -o virbr0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.122.0/24 ! -o virbr0 -j MASQUERADE

# -------------------------------
# docker (docker0) NAT 與轉發
# -------------------------------
log "允許 Docker 容器透過 docker0 出網"
iptables -A FORWARD -i docker0 -j ACCEPT
iptables -A FORWARD -o docker0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE

log "拒絕其他封包前 log 一下（方便 debug）"
iptables -A INPUT -j LOG --log-prefix "DROP_INPUT: " --log-level 4
iptables -A FORWARD -j LOG --log-prefix "DROP_FORWARD: " --log-level 4

log "✅ 防火牆設定完成"
