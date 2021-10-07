#!/bin/bash

curl -d "\"test content5535353\"" -X POST localhost:8080/test-form
curl -H "Content-Type: application/json" -d "\"test content5535353\"" -X POST localhost:8080/test
curl -H "Content-Type: application/json" -d "\"test content5535353\"" -X POST localhost:8080/test2
curl -X DELETE localhost:8080/test2

