const express = require('express');
const path = require('path');
const createError = require('http-errors');

const {shop} = require('./routes');

const app = express();
const port = process.env.PORT || 3003;

//create a middleware for each route
const jsonParser = express.json();

app.use('/shop', jsonParser, shop);

app.get('/', (req, res)=>{
	res.send({path: 404})
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