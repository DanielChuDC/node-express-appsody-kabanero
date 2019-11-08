const app = require('express')()

app.get('/', (req, res) => {
  res.send("Hello from Kabanero IBM Cloud Pak Application 2002!");
});
 
module.exports.app = app;
