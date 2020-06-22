const express = require('express');
const {customer, orderMaster, cart, address, sequelize} = require('../models');
const router = express.Router();

router.get('/:custId', async(req, res, next)=>{
	customer.findOne({
		where: {
			id: req.params.custId
		},
		attributes: {
			exclude: ['fcmToken']
		},
		include: [{
			model: cart,
		}, {
			model: address,
		}, {
			model: orderMaster,
			required: false,						
			where:{
				status: ['pending', 'accepted'],
			}
		}],
	})
	.then((result)=>{
		res.json(result)
	})
	.catch((err)=>{
		res.json(err)
	})
})

router.post('/', async(req, res, next)=>{
	try {
		const [cust, created] = await customer.findOrCreate({
			where: {
				mobile: req.body.mobile
			},
			include: 'addresses',
			defaults: {
				mobile: req.body.mobile
			}
		})
		res.json(cust);		
	} catch(e) {
		res.send(e);
		// statements
		console.log(e);
	}
})

router.put('/:customerId', async(req, res, next)=>{
	try {
		await customer.update({...req.body},{where: { id: req.params.customerId }});
		res.send({message: 'updated'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

module.exports = router;