#!/bin/bash

URL="http://sapia-598834481.eu-west-1.elb.amazonaws.com/"

for i in {1..320}
do
  echo "Request #$i"
  curl -s $URL
  sleep 0.1
done