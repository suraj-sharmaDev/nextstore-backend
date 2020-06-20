const express = require('express');
const { Op } = require("sequelize");
const {address} = require('../models');
const router = express.Router();

router.get('/:custId/:label?', (req, res, next)=>{
	let whereClause = {
		customerId: req.params.custId
	};
	if(req.params.label){
		whereClause.label = req.params.label
	}
	address.findAll({
		where: whereClause
	})
	.then((addr)=>res.json(addr))
	.catch(err=>res.json(err))
})

router.post('/', async(req, res, next)=>{
	//only label with other are created more than once 
	//home and work once created can only be updated
	var data = {...req.body};
	data.reverseAddress ? data.reverseAddress = JSON.stringify(reverseAddress) : null;
	try {
		const [addr, created] = await address.findOrCreate({
			//find if home or work already exists
			where: {
				[Op.and]: [
					{
						label: {
							[Op.eq] : [req.body.label!=='other' ? req.body.label : null]
						}
					},
					{
						customerId: req.body.customerId
					}
				]
			},
			defaults: {...data}
		});
		res.json(addr);
	} catch(e) {
		res.send(e);
		// statements
		console.log(e);
	}
});

//update addresses
router.put('/:addrId', (req, res, next)=>{
	var data = {...req.body};
	data.reverseAddress ? data.reverseAddress = JSON.stringify(reverseAddress) : null;
	address.update({...data},
	{
		where: {
			id: req.params.addrId
		}
	})
	.then((result)=>{
		res.json({updated: true})
	})
	.catch((err)=>{
		res.json(err)
	})
})

module.exports = router;

