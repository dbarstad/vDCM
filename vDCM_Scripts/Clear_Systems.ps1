#!/bin/bash

rm -f /netboot/vDCM_Scripts/dnsmasq.leases

systemctl restart dnsmasq
