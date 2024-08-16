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

![Screenshot 08-15-2024](https://github.com/KaiaSMcDonald/Workload-2/blob/main/Screenshot%202024-08-15%20at%209.32.34%20AM.png)


This is what the page looks like showing that the code successfully went through the Test stage

![Screenshot 08-15-2024](https://github.com/KaiaSMcDonald/Workload-2/blob/main/Screenshot%202024-08-15%20at%209.29.09%20AM.png)

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

8. Activate Python Virtual Environment
   By running the `python3 - m venv [name-of-environment]` the python environment will be successfully activated
   - A virtual environment is used to hold a particular Python interpreter and software libraries and binaries required to support the application.The benefits of utilizing a virtual environment is that it avoids system pollution and dependency conflicts.

9. Install AWS EB CLI on the Jenkins server
   The commands needed to achieve this is: `$pip install awsebcli
$eb --version`
   The installation of the AWS Elastic Beanstalk will aid in the deployment of the application.

10. Configure AWS CLI
 The command needed to accomplish this is: `$aws configure`
The configurations will include inputting access keys,region, and output format
Altogteher these configurations ensure that requests to other AWS services are authenticated, CLI commands are directed to the right geographical location, and that the output is in a human readable format.

11. Initialize AWS Elastic Beanstalk CLI
The command needed to achieve this is: `eb init`
One of the steps when initializing the AWS EB CLI is selecting "no" for code commit.
This step is very important because it essentially will deploy the application using Elastic Beanstalk CLI commands or automation scripts.

12. Add deploy stage code to Jenkinsfile
    The code that should be added is as follows:
    ```
    stage ('Deploy') {
          steps {
              sh '''#!/bin/bash
              source venv/bin/activate
              eb create [enter-name-of-environment-here] --single
              '''
          }
      }
The syntax is very important! One slight error can make a huge difference in the progression of the application through the pipeline.


Once this code is added to the Jenkinsfile then the file should be pushed to the Github repository. <br>

Afterwards return back to Jenkins to complete a rebuild which should successfully reach the deploy stage.

## System Design Diagram 

![Screenshot 08-15-2024](https://github.com/KaiaSMcDonald/Workload-2/blob/main/Screenshot%202024-08-15%20at%205.35.00%20PM.png)

This diagram displays all the stages, resources and tools used to complete the optimization of this application. It showcases the relationship between the different AWS services and what machines or environments support them.

## Issues/Troubleshooting

Issue #1: I experienced a failure at the test stage for the first build that I did through Jenkins. 
When looking at the error message I received I noticed that the ouput of the code did not display the memory usage and the disk usage.Therefore was issue with the code that contributed to the failure I was experiencing.

To resolve this issue I went back into the terminal and ran the code to see if I would get the same results. Once I noticed that the results were the same I modified the code. 

This is the output I recieved with the old code I wrote within the "system_resources_test.sh" script

![Screenshot 08-15-2024](https://github.com/KaiaSMcDonald/Workload-2/blob/main/Screenshot%202024-08-14%20at%205.18.07%20PM.png)

Afterwards I ran into another issue where my CPU usage would surpass the threshold and present a warning messsage even when it wasn't true. Example down below 

![Screenshot 08-15-2024](https://github.com/KaiaSMcDonald/Workload-2/blob/main/Screenshot%202024-08-15%20at%2010.56.27%20PM.png)

To resolve this issue I removed any where in my code that had '-eq 1'. Which essentially stop comparing the value from  the comparison expression to check and see if it equals to 1. Once I remove that piece of the code I no longer got the warning message.

![Screenshot 08-15-2024](https://github.com/KaiaSMcDonald/Workload-2/blob/main/Screenshot%202024-08-15%20at%2011.00.05%20PM.png)
This is a example of the a part of previous code that included '-eq 1'

Issue #2: Unable to successfully pass through the depoy stage in Jenkins 
After modifying the Jenkinsfile and rebuilding the pipeline I continue to run into the issue of having a failure at the deploy stage 

![Screenshot 08-15-2024](https://github.com/KaiaSMcDonald/Workload-2/blob/main/Screenshot%202024-08-15%20at%2010.49.53%20PM.png)

I've made several attempts to make chnages to the code in order to suceessfully pass through the deploy stage. <br>

I've also tried to look at the logs provided through jenkins to pinpoint the error but they are unavailable. <br>

![Screenshot 08-15-2024](https://github.com/KaiaSMcDonald/Workload-2/blob/main/Screenshot%202024-08-15%20at%207.50.01%20AM.png)

Unfortunately those attempts didn't work so I will continue to do my research to find a resolution to the problem. 

## Optimization 

How is using a deploy stage in the CICD pipeline able to increase efficiency of the buisiness?

The use of the deploy stage in the CI/CD pipeline has many benefits:
1. Fast and Frequent Releases: The process of automating deployment will allow software updates to be moved to production faster. This includes faster bug fixes and release of new features.
2. Resource Optimization: Automating deployment will reduce the time and energy staff and developers put towards manually deploying a application. There will also be a reduction in costs because the cloud resources will be utilized in a more efficient way.
3. Reduce Risk: Automated deployments happen in a controlled environment which decreases the amount of errors or issues that may happen during a manual deployment.
4. Scalability: Automated deployment processes are able to scale in order to manage a increase load as the business grows. Essentially ensuring that the applications and demands are meeting and satisfying the demand.

What issues, if any, can you think of that might come with automating source code to a production environment? How would you address/resolve this?

There are some issues that come with automating source code to a production environment which include:
1. Security Vulnerabilities: Automated deployments can be susceptible to security vulnerabilities if proper checks aren't happening. <br>
   Resolution- Implement security testing such as scanning into the CI/CD pipeline to detect vulnerabilities early.<br>
   
2. Lack of Visibility and Observation: If the proper monitoring and logging isn't implemented it will problematic to diagnose and resolve issues happening after the deployment.<br>
   Ressolution- Implement monitoring tools such as Prometheus and Grafana to monitor and log important events.

## Conclusion

This project provides a great opportunity to understand and witness the benefits of optimizing the deployment process. It also exposes the power behind the AWs CLI tool and how it enables you to utilize different services in one space. Overall developing solutions that incorporates automation is extremely beneficial because it helps improve accuracy and decrease deployment time which are two very key components for a business.

