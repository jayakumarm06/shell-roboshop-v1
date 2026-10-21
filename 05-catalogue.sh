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

dnf module disable nodejs -y &>> $logs_file
dnf module enable nodejs:24 -y &>> $logs_file
dnf install nodejs -y &>> $logs_file
validate $? "Installing nodesjs"


useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "Create a user for nodesjs"

# mkdir /app &>> $logs_file
# curl -L -o /tmp/catalogue.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/catalogue-v4.zip &>> $logs_file
# cd /app &>> $logs_file
# unzip /tmp/catalogue.zip &>> $logs_file
# validate $? "Create folder app and download the unzip project file"

# cd /app &>> $logs_file
# npm install &>> $logs_file
# validate $? "Go the /app folder and run npm command"


# cp catalogue.service /etc/systemd/system/catalogue.service &>> $logs_file
#  #
# """
#  #here we enter the catalogue service file and update mongodb
#      **********************************************

# """
# # Check syntax and errors
# sshd -t | tee -a $logs_file

# cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $logs_file

# dnf install mongodb-mongosh -y &>> $logs_file
# validate $? "Install mongodb client"

# # Load the data only once 
# mongosh --host <MONGODB-SERVER-IPADDRESS> </app/db/master-data.js &>> $logs_file
# validate $? "Load data on mongodb"

# systemctl daemon-reload 
# systemctl enable catalogue &>> $logs_file
# systemctl start catalogue
# validate $? "Reload and enable,start the catalogue service"

# curl http://localhost:8080/health  | tee -a $logs_file

#Here SECONDS is built in variables easy to use 
echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ===== Script completed Execution =======" | tee -a $logs_file


