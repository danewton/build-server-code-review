#!/bin/bash

. $(dirname $0)/../bin/setenv.sh

if [ "$IS_MVN" == "false" ]; then
 exit 0
fi

if [ "$TYPE" == "pom" ]; then
 exit 0
fi

TEST_DIR="src/test"
if [ ! -d "src/test" ]; then
 exit 0
fi

if [ $(grep -R 'System.err.println' $TEST_DIR | grep -v '.svn' | wc -l) -ne 0 ]; then
  echo "Please replace the System.err.println calls from the $TEST_DIR directory, and use a Logger to write to the application logs instead. If your unit test fails, it'll log to the bamboo log files, and you won't be able to see the issue. And honestly, I don't want to see stack traces from your app within my Bamboo server logs."
  grep -nR 'System.err.println' $TEST_DIR | grep -v '.svn'
#  exit 1
fi


