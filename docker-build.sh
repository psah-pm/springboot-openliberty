docker build -t liberty .
docker run -p 9080:9080 -p 9443:9443 --name liberty liberty