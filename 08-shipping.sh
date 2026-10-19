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

dnf module enable maven:3.9 -y &>> $logs_file
dnf install maven java-25-openjdk-devel -y &>> $logs_file
validate $? "Installing maven and java"

echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f /usr/bin/java)))" > /etc/profile.d/java.sh &>> $logs_file
source /etc/profile.d/java.sh | tee -a $logs_file
echo $JAVA_HOME | tee -a $logs_file
validate $? "java path to tell maven"


useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "Create a user for application"

mkdir /app &>> $logs_file
curl -L -o /tmp/shipping.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/shipping-v4.zip &>> $logs_file
cd /app &>> $logs_file
unzip /tmp/shipping.zip &>> $logs_file
validate $? "Create folder app and download the unzip project file"

cd /app &>> $logs_file
mvn clean package &>> $logs_file
mv target/shipping.jar shipping.jar
validate $? "Go the /app folder,run mvn command and move the jar files outside the folder (means:/app)"

# Load master data
dnf install mysql -y &>> $logs_file
validate $? "Install mysql client"

# Load the cities data into the database
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $logs_file
validate $? "Load cities data on mysql database"

# Load the app user data into the database
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $logs_file
validate $? "Load user data on mysql database"

# create a system user and service
cp shipping.service /etc/systemd/system/shipping.service &>> $logs_file
 #
"""
 #here we enter the shipping service file and update cart ,mysql
     **********************************************

"""
# Check syntax and errors
sshd -t | tee -a $logs_file



systemctl daemon-reload 
systemctl enable shipping &>> $logs_file
systemctl start shipping
validate $? "Reload and enable,start the shipping service"

curl http://localhost:8080/health  | tee -a $logs_file

#Here SECONDS is built in variables easy to use 
echo "$(timestamp) [INFO] Script completed in $SECONDS seconds"
echo "$(timestamp) [INFO] ===== Script completed Execution =======" | tee -a $logs_file


