#!/bin/bash

curl -d "\"test content5535353\"" -X POST localhost:8080/test-form
curl -H "Content-Type: application/json" -d "\"test content5535353\"" -X POST localhost:8080/test
curl -H "Content-Type: application/json" -d "\"test content5535353\"" -X POST localhost:8080/test2
curl -H "Content-Type: text/plain" -d "\"test content5535353\"" -X POST localhost:8080/test3

# Deleting a resource
curl -X DELETE localhost:8080/test2

# Upload image files
curl -i -H "Content-Type: image/png" --data-binary @images/Go-Logo_Aqua.png -v localhost:8080/logo
curl -i -H "Content-Type: image/png" --data-binary @images/Golang.png -v localhost:8080/gopher
