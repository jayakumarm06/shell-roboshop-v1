#!/bin/bash

user_id=$(id -u)

logs_folder="/var/log/shell-practice"
logs_file="${logs_folder}/${0}.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


echo "++++++++++++++++++++++"
# 06-user.sh
# user_component=$(basename "$0" | cut -d'.' -f1 | cut -d'-' -f2)
# echo "filename User:$user_component"
user_component="user"
echo "+++++++++++++++++++++++"
## Accessing the variables from roboshop-v1 to mongodb

source ./roboshop-v1.sh 
source ./01-mongodb.sh 
source ./02-redis.sh

echo "Hosted Zone Id:$hosted_zone_id" 
echo "Domain name:$domain_name"
echo "Mongodb filename:$mongodb_component"
echo "redis filename:$redis_component"


# for zone_id in $(aws route53 list-hosted-zones --output json | jq -r '.HostedZones[] | [.Id | sub("/hostedzone/"; ""), .Name] | @tsv' | while IFS=$'\t' read -r zone_id zone_name); do
#     echo "Checking Hosted Zone: $zone_name ($zone_id)"
    
#     # Add your condition and query here
#     if [[ "$zone_name" == *"mongodb"* ]] && [[ "$zone_name" == *"redis"* ]]; then
#         aws route53 list-resource-record-sets --hosted-zone-id "$zone_id" --output json \
#             | jq --arg query "mongodb" '.ResourceRecordSets[] | select(.Name | contains($query)) | {ZoneId: "'"$zone_id"'", Name: .Name, Type: .Type}'
#     fi
# done



## 



if [ $user_id -ne 0 ]; then
    echo "Plse choose sudo access to.."
    exit 1
fi

mkdir -p $logs_folder


#######################################################


# timestamp(){
#     date "+%F %T"
# }

# validate(){

#     if  [ $1 -ne 0 ]; then
#         echo -e "$(timestamp) [ERROR] ${2}...${R}FAILED${N}" | tee -a $logs_file
#         exit 1
#     else
#         echo -e "$(timestamp) [INFO] ${2}...${G}SUCCESS${N}" | tee -a $logs_file
#     fi

# }

# echo "$(timestamp) [INFO] ===== Script Started Execution =======" | tee -a $logs_file

# # &>> $logs_file

# dnf module disable nodejs -y &>> $logs_file
# dnf module enable nodejs:24 -y &>> $logs_file
# dnf install nodejs -y &>> $logs_file
# validate $? "Installing nodesjs"

# useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
# validate $? "Create a user for application"

# mkdir /app &>> $logs_file
# curl -L -o /tmp/user.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/user-v4.zip &>> $logs_file
# cd /app &>> $logs_file
# unzip /tmp/user.zip &>> $logs_file
# validate $? "Create folder app and download the unzip project file"

# cd /app &>> $logs_file
# npm install &>> $logs_file
# validate $? "Go the /app folder and run npm command"


# cp user.service /etc/systemd/system/user.service &>> $logs_file
#  #
# """
#  #here we enter the user service file and update redis and mongodb
#      **********************************************

# """
# # Check syntax and errors
# sshd -t | tee -a $logs_file

# systemctl daemon-reload 
# systemctl enable user &>> $logs_file
# systemctl start user
# validate $? "Reload and enable,start the user service"

# curl http://localhost:8080/health  | tee -a $logs_file

# #Here SECONDS is built in variables easy to use 
# echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
# echo "$(timestamp) [INFO] ===== Script completed Execution =======" | tee -a $logs_file


