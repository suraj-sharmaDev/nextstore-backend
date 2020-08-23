const express = require('express');
const path = require('path');
const {sequelize} = require('./models');
const createError = require('http-errors');

var {login, address, cart, verification, favourite} = require('./routes');

const app = express();
const port = process.env.PORT || 3000;

//create a middleware for each route
const jsonParser = express.json();
const urlEncoded = express.urlencoded({extended : false});

app.use('/login', jsonParser, login);
app.use('/address', jsonParser, address);
app.use('/cart', jsonParser, cart);
app.use('/verify', jsonParser, verification);
app.use('/favourite', jsonParser, favourite);

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