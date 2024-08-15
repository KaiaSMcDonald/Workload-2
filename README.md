# Optimizing the Deployment process of a Web Application <br>
## Purpose <br>
<p> This project focused on and how AWS CLI can help optimize the deploying process of a web application. Originally without the use of AWS CLI it was necessary to manually input code as a zip file to successfully deploy a web application. However by implementing AWS CLI that step is no longer essential. AWS CLI is a command line interface that allows you to control many AWS services such as AWS Elastic Beanstalk. Therefore it eliminates the need to navigate through your AWS console and set configurations that will enable you to successful deploy a web application. Overall you are able to pass through the different stages of the CI/CD pipeline within one terminal. This particular optimization will provide many benefits that will drive growth and make improvements to many areas of a company. </p> <br>
<p> The steps displayed down below showcase what was done to optimize the deployment process of a web application</p>

## Steps <br>
1. Cloning the repository to a personal repository on my Github account
By doing this step we are able to make contributions and customize without altering the original repository.
- First, on the EC2 instance create a new directory using `mkdir` command and then `cd` so you are in the directory you just created.
- Next, run 'git init', following that check which branch you are in within you directory using `git branch`
- After, run `git pull` plus the url of the original repository you are trying to add to your personal repository
- Following that, run `git remote add origin` plus the url of the personal repository you created in your Github account
- Lastly, run `git branch -M main` to rename the branch you are in, then run `git push -u origin main` <br> <br>
These steps will successfully allow you to take the original repository and clone it to your personal repository on you Github account

2.Create AWS Access Keys 
-Navigate to the AWS servce: IAM (search for this in the AWS console)
- Click on "Users" on the left side navigation panel
- Click on your User Name
- Underneath the "Summary" section, click on the "Security credentials" tab
-  Scroll down to "Access keys" and click on "Create access key" <br> <br>
(The AWS Access Keys will help grants programmatic access to AWS resources)

3. Create a t2.micro EC2
- This EC2 is what the Jenkins Server will run on and the Jenkins Server is important because it automates the development process of a application

4. Create a Bash script named "system_resources_test.sh"
- The role of this script is to check for system resources like (CPU,Memory,and Disk) and make sure it shows whether any resource exceeds a certain threshold.
```
#!/bin/bash

# Define thresholds
CPU_THRESHOLD=90
MEMORY_THRESHOLD=90
DISK_THRESHOLD=90

# Function to check CPU usage
check_cpu_usage() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if ! [[ $CPU_USAGE =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "Error: CPU usage is not a valid number: ${CPU_USAGE}"
        exit 1
    fi

    if (( "$(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc)" )); then
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
    
    if (( "$(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc)" )); then
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
```
The beginning part of the script defines the threshold percentages for CPU, Memory, and Disk. If the usage for any of the resources surpass these values there will be a alert/warning. <br>
Next is the <b> Function to Check the CPU Usage </b> : This section retreives cpu usage, validate cpu usage, and compare the cpu usage with the threshold. <br>
After that is the <b> Function to Check the Memory Usage </b> : This section retreives memory usage, validate memory usage, calculate memory usage and compare with the threshold. <br>
Following that is the <b> Function to Check Disk Usage </b> : This section retreives disk usage, validate disk usage, and compare the disk usage with the threshold. <br>
Next All the resources are checked <br>
Finally the last part of the script checks if all resources are within the threshold or exceeds the threshold. If the usage is below the threshold the script will print a message and exit with a code 0 (success). If the usage is above the threshold the script will print a message and exit with a code 1 (failure).<br>

5. Jenkins Build and Test There are three stages in total the Checkout SCM, Build, and Test.

The Checkout SCM stage is cloning and colleccting the git repository to start the build.
The Build stage is where all the dependencies needed to test the logical code are downloaded and installed.
The test stage ensures that all the functions and features for the application are working correctly.




This is what the page looks like showing that the code successfully went through the Test stage



This shows that the code went through all the stages successfully

6. Install AWS CLI on the Jenkins Server
   The following commands will successfully install AWS CLI
   ```
   $curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    $unzip awscliv2.zip
    $sudo ./aws/install
    $aws --version
   
   ```
   By installing AWS CLI within the terminal I am able to deploy this application using a AWS resource known as AWS Elastic Beanstalk. I do not need to navigate to my AWS console to access Elastic Beanstalk.


 7. Switch to Jenkins user 
   Next I will switch to the Jenkins user by using the `sudo su - jenkins` will allow me to load the user environment and make any changes that will allow the code to successfully go through all the stages in Jenkins without stepping out of the terminal.

8. Activate Python 
   

