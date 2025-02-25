# Stage 1: Build Stage
FROM node:18-alpine as build-stage

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the application (adjust npm run build command as per your application)
RUN npm run build --prod

# Stage 2: Production Stage
FROM nginx:1.21.6-alpine

# Copy built artifacts from  the build stage to Nginx's html directory
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Replace Nginx default port 80 with 8080
RUN sed -i 's/listen       80;/listen       8080;/g' /etc/nginx/conf.d/default.conf

# Expose port 8080 (this is not necessary for Cloud Run, but for local testing)
EXPOSE 8080

# Command to start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
