const app = require('express')()

app.get('/', (req, res) => {
  res.send("Hello from Kabanero IBM Cloud Pak Application 2019!");
});
 
module.exports.app = app;
