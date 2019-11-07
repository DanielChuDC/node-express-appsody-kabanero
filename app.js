const app = require('express')()

app.get('/', (req, res) => {
  res.send("Hello from Hello World!");
});
 
module.exports.app = app;
