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

dnf install golang -y &>> $logs_file
validate $? "Installing golang package"

# creata a appication user
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "Create a application user"

mkdir /app &>> $logs_file
curl -L -o /tmp/dispatch.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/dispatch-v4.zip &>> $logs_file
cd /app &>> $logs_file
unzip /tmp/dispatch.zip &>> $logs_file
validate $? "Create folder app and download the unzip project file"

cd /app &>> $logs_file
go build -o dispatch  &>> $logs_file
validate $? "downalod and install all libraries"

# configure sytemd service and for particular user
cp dispatch.service /etc/systemd/system/dispatch.service &>> $logs_file
 #
"""
 #here we enter the dispatch service file and update rabbitmq
     **********************************************

"""
# Check syntax and errors
sshd -t | tee -a $logs_file

# Load and start service
systemctl daemon-reload 
systemctl enable dispatch &>> $logs_file
systemctl start dispatch
validate $? "Reload and enable,start the dispatch service"


#Here SECONDS is built in variables easy to use 
echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ===== Script completed Execution =======" | tee -a $logs_file


