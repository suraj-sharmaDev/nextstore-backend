const express = require('express');
const cors = require('cors');
const {sequelize} = require('./models');
const createError = require('http-errors');

const {
	order, 
	quote, 
	operations,
	billData
} = require('./routes');

const bodyParser = require("body-parser");
const upload = require("./middleware/fileUpload");

const app = express();
const port = process.env.PORT || 3008;
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));

//create a middleware for each route
const jsonParser = express.json();

app.use('/order', jsonParser, order);
app.use('/quote', jsonParser, quote);
app.use('/operations', jsonParser, operations);
app.use('/bill', upload, billData);

app.get('/', (req, res) => {
	res.send({ path: 404 })
})

//create error 404 error
app.use((req, res, next)=>{
	next(createError(404));
})

app.use((err, req, res, next)=>{
	res.status(err.status || 500);
	res.send(JSON.stringify(err))
})
app.listen(port);