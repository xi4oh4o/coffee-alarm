# Coffee alarm

A alarm platform

- Node.js
- CoffeeScript
- Express.js
- dotenv
- kue
- Pug
- Mongodb
- Mailgun.js
- Semantic UI

### # Install
````shell
npm install -g coffee-script
npm install
````

### # Run
````shell
NODE_ENV=production npm start
````

### # Deploy
````shell
npm install pm2 -g
pm2 start process.yml
````

### # Start & Stop PM2 Cluster
````shell
pm2 start all
pm2 stop all
````
