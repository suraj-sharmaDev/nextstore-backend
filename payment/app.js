const express = require("express");
const cors = require("cors");
const createError = require("http-errors");

const {
  acceptPayment
} = require("./routes");

const bodyParser = require("body-parser");
const app = express();
const port = process.env.PORT || 3011;
app.use(cors());

//create a middleware for each route
const jsonParser = express.json();
app.use(bodyParser.urlencoded({ extended: false }));

app.use('/acceptPayment', jsonParser, acceptPayment);

app.get("/", (req, res) => {
  res.send({ path: 404 });
});

//create error 404 error
app.use((req, res, next) => {
  next(createError(404));
});

app.use((err, req, res, next) => {
  res.status(err.status || 500);
  res.send(JSON.stringify(err));
});

app.listen(port);
