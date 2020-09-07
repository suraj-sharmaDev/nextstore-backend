const express = require('express');
const path = require('path');
const {sequelize} = require('./models');
const createError = require('http-errors');

const {order, quote, operations} = require('./routes');

const app = express();
const port = process.env.PORT || 3002;

//create a middleware for each route
const jsonParser = express.json();

app.use('/order', jsonParser, order);
app.use('/quote', jsonParser, quote);
app.use('/operations', jsonParser, operations);

app.get('/', (req, res)=>{
	sequelize.sync()
	.then(()=>res.json(result))
	.catch(err=>res.json(err))
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