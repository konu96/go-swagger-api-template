runcmd:
  - hostnamectl set-hostname webserver
  - sudo yum update --security -y
  - sudo yum install -y mysql
  - cp  -p /etc/localtime /etc/localtime.org
  - ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime