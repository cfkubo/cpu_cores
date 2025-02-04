# Array of VM IP addresses
$vm_ips = @("192.168.1.100", "192.168.1.101", "192.168.1.102") # Add your VM IPs here

# Function to collect CPU info from a VM
function Get-VMCPUInfo {
  param(
    [string]$vm_ip
  )

  try {
    # Use Invoke-Command to connect to the VM and run WMIC
    $wmic_output = Invoke-Command -ComputerName $vm_ip -ScriptBlock {
      wmic CPU Get NumberOfCores,NumberOfLogicalProcessors /Format:List
    } -ErrorAction Stop # Stop if there's an error

    # Parse the WMIC output (handle multiple CPUs if present)
    $cpu_info = $wmic_output | ForEach-Object {
        if ($_ -match "^NumberOfCores=(.*)$") {
            $cores = $Matches[1]
        }
        if ($_ -match "^NumberOfLogicalProcessors=(.*)$") {
            $logical_processors = $Matches[1]
        }

        if ($cores -and $logical_processors){ #output for each CPU
          [PSCustomObject]@{
              Cores = $cores
              LogicalProcessors = $logical_processors
          }
          $cores = $null
          $logical_processors = $null
        }
    }

    # Calculate total cores (handling multiple CPUs)
    $total_physical_cores = ($cpu_info | Measure-Object -Property Cores -Sum).Sum
    $total_virtual_cores = ($cpu_info | Measure-Object -Property LogicalProcessors -Sum).Sum

    # Display the information
    Write-Host "VM IP: $vm_ip"
    Write-Host "Physical Cores: $total_physical_cores"
    Write-Host "Virtual Cores: $total_virtual_cores"
    Write-Host "--------------------"

  }
  catch {
    Write-Host "Error: Could not connect to $vm_ip or execute command: $_"
    Write-Host "--------------------"
  }
}

# Loop through the VM IP addresses and collect CPU info
foreach ($vm_ip in $vm_ips) {
  Get-VMCPUInfo $vm_ip
}
