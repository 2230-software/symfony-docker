FROM nginx:1.17.8

#COPY docker/nginx/nginx.conf  /etc/nginx/
#COPY docker/nginx/default.conf /etc/nginx/conf.d/
RUN apt update && apt install less nano -y
#RUN echo "upstream php-upstream { server symfony:9000; }" > /etc/nginx/conf.d/upstream.conf

EXPOSE 80
EXPOSE 443
