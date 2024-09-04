# Frontend Dockerfile

# Use the official Nginx image as a base image
FROM nginx:alpine

# Copy the static files to the appropriate directory
COPY . /usr/share/nginx/html

# Expose the port Nginx is running on
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
