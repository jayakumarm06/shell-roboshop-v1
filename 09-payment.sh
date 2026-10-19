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

dnf install python3.14 python3.14-pip -y &>> $logs_file
validate $? "Installing python and pip"

# creata a appication user
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "Create a user for application"

mkdir /app &>> $logs_file
curl -L -o /tmp/payment.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/payment-v4.zip &>> $logs_file
cd /app &>> $logs_file
unzip /tmp/payment.zip &>> $logs_file
validate $? "Create folder app and download the unzip project file"

cd /app &>> $logs_file
#creata a virtual environment for this project and install requirments file to this virtual environment
python3.14 -m venv /app/.venv &>> $logs_file
/app/.venv/bin/pip install -r requirements.txt &>> $logs_file 
validate $? "Creata Virtual environment and install requirments"

# configure sytemd service and for particular user
cp payment.service /etc/systemd/system/payment.service &>> $logs_file
 #
"""
 #here we enter the payment service file and update cart ,user ,rabbitmq
     **********************************************

"""
# Check syntax and errors
sshd -t | tee -a $logs_file



systemctl daemon-reload 
systemctl enable payment &>> $logs_file
systemctl start payment
validate $? "Reload and enable,start the payment service"

curl http://localhost:8080/health  | tee -a $logs_file

#Here SECONDS is built in variables easy to use 
echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ===== Script completed Execution =======" | tee -a $logs_file


