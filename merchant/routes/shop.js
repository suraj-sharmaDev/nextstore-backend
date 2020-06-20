const express = require('express');
const {shop, address, sequelize} = require('../models');

const router = express.Router();

router.get('/:shopId', (req, res, next)=>{
	shop.findOne({
		where:{
			id: req.params.shopId
		}
	})
	.then((result)=>{
		res.send(result);
	})
	.catch((err)=>{
		res.send(err);
	})
});

router.post('/:merchId', async(req, res, next)=>{
	const t = await sequelize.transaction();
	try {
		const result = await shop.create({...req.body, merchantId: req.params.merchId}, { transaction: t });
		await result.createAddress({...req.body.address}, { transaction: t });
		await t.commit();
		res.send({message: true});
	} catch(e) {
		await t.rollback();
		res.send(e);
		console.log(e);
	}
})

router.put('/:shopId', async(req, res, next)=>{
	const t = await sequelize.transaction();
	try{
		if(req.body.shop) {
			await shop.update({...req.body.shop},{ where: { id: req.params.shopId }}, { transaction: t });
		}
		if(req.body.address){
			await address.update({...req.body.address}, { where: { shopId: req.params.shopId }}, { transaction: t });			
		}
		await t.commit();
		res.send({message: true});
	}catch(e) {
		await t.rollback();
		res.send({error : true});
		console.log(e);
	}
})
module.exports = router;