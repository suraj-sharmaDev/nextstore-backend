const express = require('express');
const {cart, sequelize} = require('../models');

const router = express.Router();

router.get('/:customerId', (req, res, next)=>{
	cart.findAll({where: {customerId : req.params.customerId}})
	.then((result)=> res.json(result))
	.catch((err)=>res.json(err))
})

router.post('/:customerId', async(req, res, next)=>{
	const t = await sequelize.transaction();
	try {
		await sequelize.query('exec spbulkCreateCart :json, :customerId', { 
			replacements: { 
				json: JSON.stringify(req.body),
				customerId: req.params.customerId 
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