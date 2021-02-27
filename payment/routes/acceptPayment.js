const express = require('express');
const {sequelize} = require('../models');

const router = express.Router();

router.get('/', async(req, res, next)=>{
    res.send({hello: 'world'});
})

module.exports = router;