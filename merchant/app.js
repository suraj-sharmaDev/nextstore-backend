const express = require('express');
const path = require('path');
const {sequelize} = require('./models');
const createError = require('http-errors');

const {merchant, shop, category, product} = require('./routes');

const app = express();
const port = process.env.PORT || 3001;

//create a middleware for each route
const jsonParser = express.json();
const urlEncoded = express.urlencoded({extended : false});

app.use('/merchant', jsonParser, merchant);
app.use('/shop', jsonParser, shop);
app.use('/category', jsonParser, category);
app.use('/product', jsonParser, product);

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