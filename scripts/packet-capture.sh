#!/usr/bin/env bash
IFACE="${1:-eth0}"
sudo tcpdump -i "$IFACE" port 80 -nn
