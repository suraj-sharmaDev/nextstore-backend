const express = require('express');
const {customer, orderMaster, cart, address, sequelize} = require('../models');
const router = express.Router();

router.get('/:custId', async(req, res, next)=>{
	var customer = null;
	try {
		customer = await sequelize.query('EXEC spInitializeCustomer :custId',{
			replacements: {
				custId: req.params.custId
			}
		}).spread((user, created)=> {
			var obj = Object.values(user[0]);
			if(obj[0]){
				return(JSON.parse(obj))
			}else{
				return {error: true, reason: 'unknown customer Id'};
			}
		})
	} catch(e) {
		// statements
		customer = {error: true, reason: 'database error'};
		console.log(e);
	}
	res.send(customer);
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