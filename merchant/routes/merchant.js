const express = require('express');
const {merchant, shop} = require('../models');
const router = express.Router();

router.get('/:merchId', (req, res, next)=>{
	merchant.findOne({
		where: {
			id: req.params.merchId
		},
		include: {
			model: shop,
			include: 'address'
		}
	})
	.then((result)=>{
		res.send(result);
	})
	.catch((err)=>{
		res.send(err);
	})
});

router.post('/', async(req, res, next)=>{
	const [merch, created] = await merchant.findOrCreate({
		where: {
			mobile: req.body.mobile
		},
		defaults: {...req.body}
	})
	res.send(merch);
})

router.put('/:merchId', (req, res, next)=>{
	merchant.update({...req.body},{
		where: {
			id: req.params.merchId
		}
	})
	.then((result)=>{
		res.send({updated: true});
	})
	.catch(err=>res.send(err))
})

module.exports = router;