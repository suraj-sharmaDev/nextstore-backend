const express = require('express');
const {productMaster, product, sequelize} = require('../models');

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

		await sequelize.query(
			'exec spInsertProductInShop :json', 
			{ 
				replacements: { 
					json: JSON.stringify({...req.body, shopId : parseInt(req.params.shopId)}),
				}
		});
		res.send({error: false, message: 'inserted'});
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
})

router.put('/:shopId/:productId', async(req, res, next)=>{
	try {
		await sequelize.query(
			'exec spUpdateProductInShop :json, :shopId', 
			{ 
				replacements: { 
					json: JSON.stringify({...req.body, id : parseInt(req.params.productId)}),
					shopId: parseInt(req.params.shopId)
				}
		});
		res.send({error: false, message: 'updated'});
	} catch(e) {
		res.json({error : true});
		console.log(e);
	}
})

module.exports = router;