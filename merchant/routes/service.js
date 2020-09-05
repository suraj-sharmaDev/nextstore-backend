const express = require('express');
const {sequelize} = require('../models');

const router = express.Router();

router.get('/:serviceProviderId', async(req, res, next)=>{
    //get all services belonging to serviceProvider
});

router.post('/', async(req, res, next)=>{
    //add new serviceProvider for a merchant
	try {
		const serviceProviderId = await sequelize.query(
			'exec spAddServiceToMerchant :json', 
			{ 
				replacements: { 
					json: JSON.stringify(req.body),
				}
		    }).spread((value, created)=>{
                return value[0];
            });
            // res.send(serviceProviderId);
		res.send({error: false, message: 'inserted', ...serviceProviderId});
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
});

router.put('/:serviceProviderId', async(req, res, next)=>{
    //update service Provider details
});

module.exports = router;