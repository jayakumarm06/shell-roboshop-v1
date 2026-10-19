#!/bin/bash

user_id=$(id -u)

logs_folder="/var/log/shell-practice"
logs_file="${logs_folder}/${0}.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"



if [ $user_id -ne 0 ]; then
    echo "Plse choose sudo access to.."
    exit 1
fi

mkdir -p $logs_folder

timestamp(){
    date "+%F %T"
}

validate(){

    if  [ $1 -ne 0 ]; then
        echo -e "$(timestamp) [ERROR] ${2}...${R}FAILED${N}" | tee -a $logs_file
        exit 1
    else
        echo -e "$(timestamp) [INFO] ${2}...${G}SUCCESS${N}" | tee -a $logs_file
    fi

}

echo "$(timestamp) [INFO] ===== Script Started Execution =======" | tee -a $logs_file

# &>> $logs_file

dnf module disable nginx -y &>> $logs_file
dnf module enable nginx:1.26 -y &>> $logs_file
dnf install nginx -y &>> $logs_file
validate $? "Installing nginx"

#Enable and start nginx
systemctl enable nginx &>> $logs_file
systemctl start nginx
validate $? "Reload and enable,start the nginx service"


rm -rf /usr/share/nginx/html/* &>> $logs_file
validate $? "Remove the default html page"

# Download aand extract frontend files
curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/frontend-v4.zip &>> $logs_file
cd /usr/share/nginx/html &>> $logs_file
unzip /tmp/frontend.zip &>> $logs_file
validate $? "Create folder app and download the unzip project file"

cd /app &>> $logs_file
npm install &>> $logs_file
validate $? "Go the /app folder and run npm command"

# configure the reverse proxy
cp roboshop.conf /etc/systemd/system/roboshop.conf &>> $logs_file
 #
"""
 #here we enter the roboshop.conf file and update all the services
     **********************************************

"""
# Check syntax and errors
nginx -t | tee -a $logs_file

#restart nginx
systemctl restart nginx
validate $? "Restart nginx service"

curl http://localhost:8080/health  | tee -a $logs_file
curl http://localhost/api/catalogue/health | tee -a $logs_file


#Here SECONDS is built in variables easy to use 
echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ===== Script completed Execution =======" | tee -a $logs_file


