const express = require('express');
const {productMaster, product, sequelize} = require('../models');

const router = express.Router();

router.get('/', async(req, res, next)=>{
	//when searching for product with productName 
	//list out relatable products from productMaster
	try {
		const status = await sequelize.query(
			'exec spGetProductMasterByKeyword :searchTerm, :categoryId', 
			{ 
				replacements: { 
					searchTerm: req.query.searchTerm,
					categoryId: req.query.categoryId ? req.query.categoryId : null
				}
		}).spread((value, created)=>{
			return value;
		});
		res.send(status);
	} catch(e) {
		res.send({error : true});
		console.log(e);
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