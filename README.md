Fluffy Palm TLS Tester
================

./checkServer.sh <serverName or IP> <port>
  
./checkServer.sh www.google.com 443

Filter out only allowed Ciphers

./checkServer.sh www.google.com 443 |grep YES
