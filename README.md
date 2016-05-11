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
npm install coffee-script -g
npm install pm2 -g
npm install
````

### # Run
````shell
NODE_ENV=production npm start
````

### # Deploy Coffee alarm Cluster
````
git pull & pm2 restart process.yml
````

### # Start Mail Queued
````shell
pm2 start queued/process_mail.coffee
````
