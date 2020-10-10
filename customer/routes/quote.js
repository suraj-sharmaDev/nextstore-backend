const express = require('express');
const { sequelize } = require('../models');
const router = express.Router();

router.get('/:customerId/:page/:startDate?/:endDate?', async (req, res, next) => {
    //get orders belonging to shop with customerId
    //based on status
    const customerId = req.params.customerId;
    const page = req.params.page;
    const startDate = req.params.startDate;
    const endDate = req.params.endDate;
    try {
        const quotes = await sequelize.query(
            'exec spGetCustomerQuotes :customerId, :page, :startDate, :endDate',
            {
                replacements: {
                    customerId: customerId,
                    page: page,
                    startDate: startDate ? startDate : null,
                    endDate: endDate ? endDate : null
                }
            }).spread((quotes, message) => {
                //since the return data will be string and not parsed
                //lets parse it
                var obj = Object.values(quotes[0])[0];
                if (obj) {
                    return JSON.parse(obj);
                } else {
                    return [];
                }
            });
        res.send(quotes);
    } catch (error) {
		res.send({error : true});
		console.log(e);
    }
});

module.exports = router;