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
