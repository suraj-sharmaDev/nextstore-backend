const express = require('express');
const { sequelize } = require('../models');
const router = express.Router();

router.get('/', async (req, res, next) => {
    //get shops with some filters
    let error = true;
    let status = null;
    try {
        status = await sequelize.query('exec spGetAppConfig')
            .spread((value, message) => {
                //since the return data will be string and not parsed
                //lets parse it
                return value;
            });
        error = false;
    } catch (err) {
        error = true;
        console.log(err);
    }
    if (error) {
        res.send({ error: true, message: 'db_error' });
    } else {
        res.send({ error: false, entity: status });
    }
})

router.put('/', async (req, res, next) => {
    //update coupon details
    let error = true;
    let status = null;
    try {
        status = await sequelize.query(
            'exec spUpdateAppConfig :json',
            {
                replacements: {
                    json: JSON.stringify(req.body)
                }
            }).spread((value, message) => {
                //since the return data will be string and not parsed
                //lets parse it
                return value[0];
            });
        error = false;
    } catch (err) {
        error = true;
        status = err;
        console.log(err);
    }
    if (error) {
        res.send({ error: true, message: status });
    } else {
        res.send({ error: false, entity: status });
    }
});

module.exports = router;