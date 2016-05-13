# Coffee alarm

A alarm platform

![coffee alarm](https://cloud.githubusercontent.com/assets/141127/15213188/30b954ee-1878-11e6-8fe9-206ebd2bf52d.png)


### # Dependency

- Node.js
- CoffeeScript
- Express.js
- Kue
- Pug
- PM2
- dotenv
- Mongodb
- Mailgun.js
- Nodemailer
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
pm2 start queued/process_nodemailer.coffee
````

### # Todo
- [x] Express.js + Semantic UI
- [x] Mail Queued
- [x] Receiver APIs
- [x] Mongodb
- [x] Pagination
- [x] Search
- [ ] Statistics
- [ ] SMS integration
