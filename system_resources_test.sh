#!/bin/bash

# Define thresholds
CPU_THRESHOLD=90
MEMORY_THRESHOLD=90
DISK_THRESHOLD=90

# Function to check CPU usage
check_cpu_usage() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if [ -z "$CPU_USAGE" ]; then
        echo "Unable to retrieve CPU usage."
        exit 1
    fi

    if [ "$(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc)" -eq 1 ]; then
        echo "Warning: CPU usage is above threshold: ${CPU_USAGE}%"
        return 1
    else
        echo "CPU usage is within acceptable limits: ${CPU_USAGE}%"
        return 0
    fi
}

# Function to check Memory usage
check_memory_usage() {
    MEMORY_TOTAL=$(free | awk '/^Mem:/ {print $2}')
    MEMORY_USED=$(free | awk '/^Mem:/ {print $3}')
    
    if [ -z "$MEMORY_TOTAL" ] || [ -z "$MEMORY_USED" ]; then
        echo "Unable to retrieve memory usage."
        exit 1
    fi

    MEMORY_USAGE=$(echo "scale=2; $MEMORY_USED * 100 / $MEMORY_TOTAL" | bc)
    
    if [ "$(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc)" -eq 1 ]; then
        echo "Warning: Memory usage is above threshold: ${MEMORY_USAGE}%"
        return 1
    else
        echo "Memory usage is within acceptable limits: ${MEMORY_USAGE}%"
        return 0
    fi
}

# Function to check Disk usage
check_disk_usage() {
    DISK_USAGE=$(df / | awk '/\// {print $5}' | sed 's/%//')
    
    if [ -z "$DISK_USAGE" ]; then
        echo "Unable to retrieve disk usage."
        exit 1
    fi

    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo "Warning: Disk usage is above threshold: ${DISK_USAGE}%"
        return 1
    else
        echo "Disk usage is within acceptable limits: ${DISK_USAGE}%"
        return 0
    fi
}

# Check all resources
check_cpu_usage
CPU_EXIT_CODE=$?

check_memory_usage
MEMORY_EXIT_CODE=$?

check_disk_usage
DISK_EXIT_CODE=$?

# Final exit code
if [ $CPU_EXIT_CODE -eq 0 ] && [ $MEMORY_EXIT_CODE -eq 0 ] && [ $DISK_EXIT_CODE -eq 0 ]; then
    echo "All system resources are within acceptable limits."
    exit 0
else
    echo "Some system resources are above threshold."
    exit 1
fi


