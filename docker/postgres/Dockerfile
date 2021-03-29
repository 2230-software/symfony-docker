FROM postgres:latest

RUN apt update
RUN apt install wget -y
RUN wget -O pgfutter https://github.com/lukasmartinelli/pgfutter/releases/download/v1.2/pgfutter_linux_amd64
#./pgfutter --dbname dw --host dw --user dw_user --pass dw_pass --schema pymes --table aux csv aux.csv 

RUN chmod +x pgfutter
