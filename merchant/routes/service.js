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

router.post('/symptom/:CategoryItemId', async(req, res, next)=>{
    //add new serviceProvider for a merchant
	try {
		const serviceProviderId = await sequelize.query(
			'exec spAddSymtomsToServiceRepairs :json, :CategoryItemId', 
			{ 
				replacements: { 
					json: JSON.stringify(req.body),
					CategoryItemId: req.params.CategoryItemId
				}
		    }).spread((value, created)=>{
                return value[0];
            });
            // res.send(serviceProviderId);
		res.send({error: false, ...serviceProviderId});
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
});

router.put('/symptom/:symptomId', async(req, res, next)=>{
    //add new serviceProvider for a merchant
	try {
		if (req.body.symptomData) {
			const serviceProviderId = await sequelize.query(
				'exec spUpdateSymptomsTable :symptomData, :symptomId', 
				{ 
					replacements: { 
						symptomData: req.body.symptomData,
						symptomId: req.params.symptomId
					}
				}).spread((value, created)=>{
					return value[0];
				});
			res.send({error: false, ...serviceProviderId});
		} else {
			res.send({error: true, message: 'please pass symptom data'});
		}
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
});

router.put('/:serviceProviderId', async(req, res, next)=>{
	//update service Provider details
	try {
		const serviceProviderId = await sequelize.query(
			'exec spUpdateServiceProvider :json, :serviceProviderId', 
			{ 
				replacements: { 
					json: JSON.stringify(req.body),
					serviceProviderId: req.params.serviceProviderId
				}
		    }).spread((value, created)=>{
                return value[0];
            });
		res.send({error: false, message: 'updated', ...serviceProviderId});
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}	
});

module.exports = router;