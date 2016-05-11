# Coffee alarm

A alarm platform

![coffee alarm](https://cloud.githubusercontent.com/assets/141127/15173468/c90ff83c-178e-11e6-851a-803c33a34686.png)

### # Dependency

- Node.js
- CoffeeScript
- Express.js
- dotenv
- kue
- Pug
- Mongodb
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
pm2 start queued/process_mail.coffee
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
