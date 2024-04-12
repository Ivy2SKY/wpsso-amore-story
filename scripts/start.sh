#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
BUILD_JAR=$(ls /home/ssm-user/story-sso/build/libs/storysso-1.0.jar)
JAR_NAME=$(basename $BUILD_JAR)
echo "> build 파일명: $JAR_NAME" >> /home/ssm-user/story-sso/deploy.log
echo "> debugging : $BUILD_JAR" >> /home/ssm-user/story-sso/deploy.log

echo "> build 파일 복사" >> /home/ssm-user/story-sso/deploy.log
DEPLOY_PATH=/home/ssm-user/story-sso/build/libs/
# cp $BUILD_JAR $DEPLOY_PATH

echo "> 현재 실행중인 애플리케이션 pid 확인" >> /home/ssm-user/story-sso/deploy.log
CURRENT_PID=$(pgrep -f $JAR_NAME)
echo "> debugging : $JAR_NAME"    >> /home/ssm-user/story-sso/deploy.log

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다." >> /home/ssm-user/story-sso/deploy.log
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo "> DEPLOY_PATH, JAR_NAME : $DEPLOY_PATH$JAR_NAME" >> /home/ssm-user/story-sso/deploy.log

echo "> DEPLOY_JAR 배포"    >> /home/ssm-user/story-sso/deploy.log

chmod 755 $DEPLOY_JAR
#nohup java -jar $DEPLOY_JAR >> /home/ssm-user/story-sso/deploy.log 2>/home/ssm-user/story-sso/deploy_err.log &
nohup java -Dspring.profiles.active=stage -jar $DEPLOY_JAR 1>/dev/null 2>&1 &