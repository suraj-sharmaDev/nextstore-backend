const express = require('express');
const cors = require('cors');
const {sequelize} = require('./models');
const createError = require('http-errors');

const {merchant, login, shop, service, category, product} = require('./routes');

const app = express();
const port = process.env.PORT || 3007;
app.use(cors());
//create a middleware for each route
const jsonParser = express.json();
const urlEncoded = express.urlencoded({extended : false});

app.use('/merchant', jsonParser, merchant);
app.use('/login', jsonParser, login);
app.use('/shop', jsonParser, shop);
app.use('/service', jsonParser, service);
app.use('/category', jsonParser, category);
app.use('/product', jsonParser, product);

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