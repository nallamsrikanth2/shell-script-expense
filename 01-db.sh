USERID=$(id -u)
TIMESTAP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$TIMESTAP-$SCRIPT_NAME.log


R="[e\31m"
G="[e\32m"
Y="[e\33m"
N="[e\0m"

if [ $USERID -ne 0 ]
then
    echo -e "$R please run script the inside server $N"
    exit 1
else
    echo -e "$G you are a root server $N"
fi

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$R $2 .. failure $N"
        exit 1
    else    
        echo -e "$G $2 ..success $N"
    fi
}

dnf install mysql-server -y
VALIDATE $? "install mysql-server"

systemctl enable mysqld
VALIDATE $? "enable mysqld"

systemctl start mysqld
VALIDATE $? "start the mysqld"

mysql -h "db.nsrikanth.online" -uroot -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1
else
    echo -e "$Y setup already root password $N"
fi

