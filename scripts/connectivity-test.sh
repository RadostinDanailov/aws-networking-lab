#!/usr/bin/env bash
ALB_DNS="$1"

echo "ALB DNS: $ALB_DNS"
echo "Curl test:"
curl -s "http://$ALB_DNS" || echo "Curl failed"

echo
echo "Traceroute to google.com:"
traceroute google.com || echo "Traceroute not installed"

echo
echo "Ping google.com:"
ping -c 4 google.com || echo "Ping failed"
