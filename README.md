# Coffee alarm

A alarm platform

![coffee alarm](https://cloud.githubusercontent.com/assets/141127/15178401/ed8fd254-17a7-11e6-9963-30b10309b798.png)

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
- [ ] Pagination
- [ ] SMS integration
- [ ] Search
- [ ] Statistics
