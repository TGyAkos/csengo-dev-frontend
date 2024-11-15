FROM node:16    
WORKDIR /app
RUN npm install -g vite
COPY . .    
RUN yarn install

# vite default port
EXPOSE 5173    
CMD ["yarn", "run", "dev"]
