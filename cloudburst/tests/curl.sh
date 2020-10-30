#!/bin/bash
echo "POST Test"
curl --data "param1=value1&param2=value2" http://localhost/demo/test
echo "PUT Test"
curl -X PUT -d arg=val -d arg2=val2 http://localhost/demo/test
