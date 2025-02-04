#!/bin/bash

# Array of VM IP addresses
vm_ips=("192.168.1.100" "192.168.1.101" "192.168.1.102")  # Add your VM IPs here

# Function to collect CPU info from a VM
get_cpu_info() {
  vm_ip="$1"

  # Use ssh to connect to the VM and run commands
  ssh_command="lscpu"

  # Execute the ssh command and capture the output
  output=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@"$vm_ip" "$ssh_command" 2>/dev/null) # Suppress SSH warnings

  # Check if the ssh command was successful
  if [[ $? -eq 0 ]]; then
      # Extract CPU information using awk
      cpus=$(echo "$output" | awk '/CPU(s):/ {print $2}')
      threads_per_core=$(echo "$output" | awk '/Thread(s) per core:/ {print $4}')
      cores_per_socket=$(echo "$output" | awk '/Core(s) per socket:/ {print $4}')
      sockets=$(echo "$output" | awk '/Socket(s):/ {print $2}')

      # Calculate physical and virtual cores
      physical_cores=$((cores_per_socket * sockets))
      virtual_cores=$((threads_per_core * cores_per_socket * sockets))

      # Display the information
      echo "VM IP: $vm_ip"
      echo "Physical Cores: $physical_cores"
      echo "Virtual Cores: $virtual_cores"
      echo "--------------------"
  else
      echo "Error: Could not connect to $vm_ip or execute command."
      echo "--------------------"
  fi
}

# Loop through the VM IP addresses and collect CPU info
for vm_ip in "${vm_ips[@]}"; do
  get_cpu_info "$vm_ip"
done
