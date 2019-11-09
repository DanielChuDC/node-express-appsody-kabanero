const app = require('express')()

app.get('/', (req, res) => {
  res.send("Hello from Kabanero IBM Cloud Pak Application 6006!");
});
 
module.exports.app = app;
