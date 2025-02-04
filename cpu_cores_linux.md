# cpu_cores

## Linux VM

1. Using lscpu:

The lscpu command provides detailed information about the CPU architecture, including the number of cores.

Bash
```
lscpu
```
Sample Output:
```
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    2
Core(s) per socket:    4
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 158
Model name:            Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz
Stepping:              10
CPU MHz:               2900.000
BogoMIPS:              5800.00
Hypervisor vendor:     VMware
Virtualization type:   full
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              16384K
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca avx avx2
```
...
In this output:

CPU(s): Shows the total number of logical processors (virtual cores). In this case, 8.
Thread(s) per core: Shows the number of threads per physical core. Here, 2 (meaning hyper-threading is enabled).  
Core(s) per socket: Shows the number of physical cores per socket. Here, 4.
Socket(s): Shows the number of CPU sockets. 

Here, 1.
To calculate:

Physical Cores: Core(s) per socket x Socket(s) = 4 x 1 = 4
Virtual Cores: CPU(s) = 8 (or Thread(s) per core x Core(s) per socket x Socket(s) = 2 x 4 x 1 = 8)

2. Using /proc/cpuinfo:

The /proc/cpuinfo file contains detailed information about each logical processor.

Bash
```
cat /proc/cpuinfo
```
Sample Output (truncated):

```
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 158
model name      : Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz
...
core id         : 0
physical id     : 0
siblings        : 2
...

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 158
model name      : Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz
...
core id         : 0
physical id     : 0
siblings        : 2
...
```
In this output:

Each "processor" entry represents a logical core. Count the number of "processor" entries to get the total number of logical cores.
The "core id" shows which physical core the logical processor belongs to. Count the unique "core id" values to get the number of physical cores.
The "siblings" value indicates the number of threads per core.

3. Using nproc:

The nproc command simply prints the number of available processors (logical cores).

Bash
```
nproc
```
Sample Output:
```
8
```
Important Notes:

Virtualization: If you're on a virtual machine (VM), the number of physical cores you see might be the number of cores allocated to your VM, not the total number of physical cores on the host machine.
Hyper-threading: Hyper-threading allows a single physical core to handle multiple threads concurrently, making it appear as multiple logical cores to the operating system.  
VMware: In the lscpu output, "Hypervisor vendor: VMware" indicates that this is a virtual machine running on VMware.
By using these commands and interpreting their output, you can determine the number of physical and virtual CPU cores available to your Linux VM.
