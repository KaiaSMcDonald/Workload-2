#!/bin/bash


#Define the threshold for each resource 
CPU_Threshold=60 #CPU usage threshold (number as a percent)
Memory_Threshold=60 #Memory usage threshold (number as a percent)
Disk_Threshold=75 #Disk usage threshold (number as a percent)

#Check the CPU usage 
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if (( $(echo "$cpu_usage > $CPU_Threshold" | bc -l) )); then 
    echo "CPU usage is above threshold: ${cpu_usage}%"
    exit 1

else
    echo "CPU usage is within  the range: ${cpu_usage}%"

fi 

#Check the Memory usage 
memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0')
if (( $(echo "$memory_usage > $Memory_Threshold" | bc -l) )); then 
    echo "Memory usage is above threshold: ${memory_usage}%"
    exit 1

else
    echo "Memory usage is within range: ${memory_usage}%"

fi 

#Check Disk usage 
disk_uasge=$(df / | grep / | awk '{ print $5 }' | sed 's/%//')
if [ "$disk_usage" -gt "$Disk_Threshold" ]; then 
   echo "Disk usage is above threshold: ${disk_usage}%"
   exit 1

else
   echo "Disk usage is within the range: ${disk_usage}%"

fi

#All checks have passed 
exit 0
