const express = require('express');
const {cart, sequelize} = require('../models');

const router = express.Router();

router.get('/:customerId', (req, res, next)=>{
	try {
		const cart = await sequelize.query('EXEC spGetCustomerCart :customerId', { 
			replacements: { 
				customerId: req.params.customerId
			}
			}).spread((value, created)=>{
				//since the return data will be string and not parsed
				//lets parse it
				return value;
			})	

		res.send(cart);
	} catch(e) {
		await t.rollback();
		res.send({error: true, message: 'json_incomplete'});
		console.log(e);
	}
})

router.post('/:customerId', async(req, res, next)=>{
	const t = await sequelize.transaction();
	try {
		await sequelize.query('exec spbulkCreateCart :json', { 
			replacements: { 
				json: JSON.stringify(req.body)
			}
		});		
		await t.commit();
		res.send({message: 'created'});
	} catch(e) {
		await t.rollback();
		res.send({error: true, message: 'json_incomplete'});
		console.log(e);
	}
})

router.put('/:cartId', async(req, res, next)=>{
	try {
		await cart.update({...req.body}, {where: { id: req.params.cartId}});
		res.send({message: 'updated'});
	} catch(e) {
		res.send({error: true})
		// statements
		console.log(e);
	}
})

router.delete('/', async(req, res, next)=>{
	const t = await sequelize.transaction();
	try {
		await cart.destroy({where: {id : req.body}});
		await t.commit();
		res.send({message: 'deleted'});
		// statements
	} catch(e) {
		await t.rollback();
		res.send({error: true})
		// statements
		console.log(e);
	}
})

module.exports = router;