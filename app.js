const app = require('express')()

app.get('/', (req, res) => {
  res.send("Hello from Kabanero IBM Cloud Pak!");
});
 
module.exports.app = app;
