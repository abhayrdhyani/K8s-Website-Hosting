# Use the official Nginx image as a parent
FROM nginx:alpine

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom Nginx configuration file into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Copy all your frontend static files to the Nginx public directory
# This includes index.html, tropical_1.mp3, and any future CSS/JS files
COPY . /usr/share/nginx/html

# Expose port 80 - the port Nginx is listening on
EXPOSE 80

# Command to start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]



#Explanation of this Dockerfile:

#FROM nginx:alpine: We're using a lightweight Nginx image.
#RUN rm /etc/nginx/conf.d/default.conf: Removes Nginx's default config.
#COPY nginx.conf /etc/nginx/nginx.conf: Copies your custom Nginx configuration.
#COPY . /usr/share/nginx/html: Copies everything from your frontend directory (index.html, tropical_1.mp3, etc.) into the Nginx serving directory.
#EXPOSE 80: Informs Docker that Nginx will listen on port 80.
#CMD ["nginx", "-g", "daemon off;"]: Starts Nginx in the foreground, which is necessary when running in Docker.