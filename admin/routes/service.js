const express = require('express');
const {sequelize} = require('../models');
const router = express.Router();

router.get('/', (req, res, next)=>{
    res.send(__dirname+'../../assets');
})

module.exports = router;