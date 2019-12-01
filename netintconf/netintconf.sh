#!/bin/bash
subnet="192.168.1."
startaddr=2
endaddr=255
counter=1

echo "network:" >> configuration.yaml
echo "    ethernets:" >> configuration.yaml
echo "        eno1:" >> configuration.yaml
echo "            addresses:" >> configuration.yaml
while [ $startaddr -lt $endaddr ]; do
	echo "            - $subnet$startaddr/24" >> configuration.yaml
	startaddr=$(( startaddr+1 ))
done
echo "            dhcp4: false" >> configuration.yaml
echo "            gateway4: 192.168.1.1" >> configuration.yaml
echo "            nameservers:" >> configuration.yaml
echo "                addresses:" >> configuration.yaml
echo "                - 8.8.8.8" >> configuration.yaml
echo "                search:" >> configuration.yaml
echo "                - localhost" >> configuration.yaml
echo "    version: 1" >> configuration.yaml
