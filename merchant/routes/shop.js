const express = require('express');
const {shop, address, sequelize} = require('../models');

const router = express.Router();

router.get('/:shopId/:param?', async(req, res, next)=>{
	//this api is called at landing page of shop where only list of categories will be shown
	//basically this api should integrate category, subcategory and subcategory child

	//same api can be used to get basic shopInfo by passing basicInfo params
	try {
		let content = null;
		if(!req.params.param){
			// if there was not param
			content = await sequelize.query(
				'exec spCreateShopContent :shopId;', 
				{ 
					replacements: { shopId: req.params.shopId }
			}).spread((user, created)=>{
				//since the return data will be string and not parsed
				//lets parse it
				var shop = JSON.parse(user[0].shopInfo);
				var categories = JSON.parse(user[0].categories);
				var recommends = JSON.parse(user[0].recommends);
				return {shop, categories, recommends}
			})
		}else if (req.params.param === 'basic'){
			content = await sequelize.query(
				'exec spShopBasicInfo :shopId;', 
				{ 
					replacements: { shopId: req.params.shopId }
			}).spread((value, created)=>{
				//since the return data will be string and not parsed
				//lets parse it
				return value[0];
			})			
		}else{
			content = await sequelize.query(
				'exec spGetProductsInSubCategory :shopId, :subCategoryId', 
				{ 
					replacements: { 
						shopId: req.params.shopId,
						subCategoryId: req.params.param 
					}
			}).spread((product, created)=>{
				//since the return data will be string and not parsed
				//lets parse it
				var obj = Object.values(product[0])[0];
				if(obj){
					return JSON.parse(obj);
				}else{
					return {error: true, reason: 'Either shopId or subCategoryId does not exist'}
				}
			})			
		}
		res.send(content);
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
});

// router.get('/:shopId/:subCategoryId', async(req, res, next)=>{
// 	const shopId = req.params.shopId;
// 	const subCategoryId = req.params.subCategoryId;
// 	try {

// 		const products = await sequelize.query(
// 						'exec spGetProductsInSubCategory :shopId, :subCategoryId', 
// 						{ 
// 							replacements: { 
// 								shopId: shopId,
// 								subCategoryId: subCategoryId 
// 							}
// 					}).spread((product, created)=>{
// 						//since the return data will be string and not parsed
// 						//lets parse it
// 						var obj = Object.values(product[0])[0];
// 						if(obj){
// 							return JSON.parse(obj);
// 						}else{
// 							return {error: true, reason: 'Either shopId or subCategoryId does not exist'}
// 						}
// 					})
// 		res.send(products);
// 	} catch(e) {
// 		// statements
// 		res.send({error: true});
// 		console.log(e);
// 	}
// })

router.post('/:merchId', async(req, res, next)=>{
	//add new shop for a merchant
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