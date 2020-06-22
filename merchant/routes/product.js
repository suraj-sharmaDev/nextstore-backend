const express = require('express');
const {productMaster, product} = require('../models');

const router = express.Router();

router.get('/:shopId', async(req, res, next)=>{
	try {
		const result = await product.findAll({
			attributes: ['id', 'price', 'mrp'],
			where: { shopId: req.params.shopId },
			include: { 
				model: productMaster, 
				attributes: ['name', 'image', 'subCategoryChildId']
			}
		});
		res.send(result)
	} catch(e) {
		// statements
		console.log(e);
		res.send({error: true});
	}

})

router.post('/:shopId', async(req, res, next)=>{
	try {
		await product.create({...req.body, shopId : req.params.shopId });
		res.send({message : 'created'});
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
})

router.put('/:shopId/:productId', async(req, res, next)=>{
	try {
		await product.update({...req.body},{
			where: {
				id: req.params.productId,
				shopId: req.params.shopId
			}
		});
		res.json({message : 'updated'});
	} catch(e) {
		res.json({error : true});
		console.log(e);
	}
})

module.exports = router;