# base image
FROM nginx:alpine

# copy the source code to the default nginx directory
COPY ./ /usr/share/nginx/html/

# expose port 8080 for web traffic
EXPOSE 8080

# start nginx web server
CMD ["nginx", "-g", "daemon off;"]
