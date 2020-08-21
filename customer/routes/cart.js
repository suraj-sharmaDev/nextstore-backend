const express = require('express');
const {cart, sequelize} = require('../models');

const router = express.Router();

router.get('/:customerId', async(req, res, next)=>{
	try {
		const cart = await sequelize.query('EXEC spGetCustomerCart :customerId', { 
			replacements: { 
				customerId: req.params.customerId
			}
			}).spread((value, created)=>{
				var obj = Object.values(value[0]);
				if(obj[0]){
					return(JSON.parse(obj))
				}else{
					return {error: true, reason: 'unknown customer Id'};
				}
			})	

		res.send(cart);
	} catch(e) {
		res.send({error: true, message: 'json_incomplete'});
		console.log(e);
	}
})

router.post('/:customerId?', async(req, res, next)=>{
	try {
		await sequelize.query('exec spbulkCreateCart :json', { 
			replacements: { 
				json: JSON.stringify(req.body)
			}
		});
		res.send({message: 'created'});
	} catch(e) {
		res.send({error: true, message: 'json_incomplete'});
		console.log(e);
	}
})

router.put('/:customerId/:shopId', async(req, res, next)=>{
	try {
		await sequelize.query('exec spUpdateCart :json, :customerId, :shopId', { 
			replacements: { 
				json: JSON.stringify(req.body),
				customerId: req.params.customerId,
				shopId: req.params.shopId
			}
		});
		res.send({message: 'updated'});
	} catch(e) {
		res.send({error: true, message: 'json_incomplete'});
		console.log(e);
	}
})

router.delete('/:customerId/:shopId', async(req, res, next)=>{
	try {
		await sequelize.query('exec spDeleteCart :json, :customerId, :shopId', { 
			replacements: { 
				json: JSON.stringify(req.body),
				customerId: req.params.customerId,
				shopId: req.params.shopId				
			}
		});
		res.send({message: 'deleted'});
	} catch(e) {
		res.send({error: true, message: 'json_incomplete'});
		console.log(e);
	}
})

module.exports = router;