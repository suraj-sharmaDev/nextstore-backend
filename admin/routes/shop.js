const express = require('express');
const { sequelize } = require('../models');
const router = express.Router();

router.get('/:page?', async(req, res, next) => {
    let error = true;
    let status = null;
    let page = req.params.page ? req.params.page : 1;
    try {
        status = await sequelize.query(
            'exec spGetShopsWithFilter :json, :page',
            {
                replacements: {
                    json: JSON.stringify(req.query),
                    page: page
                }
            }).spread((value, message) => {
                //since the return data will be string and not parsed
                //lets parse it
                return value;
            });
        error = false;
    } catch (err) {
        error = true;
        console.log(err);
    }
    res.send(status);
})

module.exports = router;