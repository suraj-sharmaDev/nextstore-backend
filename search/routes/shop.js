const express = require('express');
const {sequelize} = require('../models');
const router = express.Router();

router.get('/:shopId', async(req, res, next)=>{
	//search for products in shop
	var searchKey = req.query.searchKey;
	if(searchKey){
		try {
			const result = await sequelize.query(
							'exec spSearchInShop :shopId, :keyword', 
							{ 
								replacements: { 
									shopId: req.params.shopId,
									keyword: searchKey 
								}
							}).spread((user, created)=>{
								var obj = Object.values(user[0]);
								if(obj){
									return JSON.parse(obj);
								}else{
									return {error: true, reason: 'no_values'};
								}
							})
			res.send(result);
		} catch(e) {
			res.send({error: true, reason: 'database error'})
			console.log(e);
		}
	}else{
		res.send({error: true, reason: 'searchKey not provided'})
	}
})

router.get('/:lat/:lng', async(req, res, next)=>{
	//this method does two things
	//it either fetches all shop near the user
	//but if search query present it fetches all shop near the user having product
	//matched by search query
	const searchKey = req.query.searchKey;
	if(searchKey){
		try {
			const result = await sequelize.query('exec spSearchShopsWithProduct :lat, :lng, :keyword',{
				replacements: {
					lat: req.params.lat,
					lng: req.params.lng,
					keyword: searchKey
				}
			}).spread((shops, created)=>{
				return shops;
			})
			res.send(result);
		} catch(e) {
			// statements
			res.send({error: true, reason: 'database error'})
			console.log(e);
		}		
	}else{
		try {
			const result = await sequelize.query('exec spGetNearbyShopsOffers :lat, :lng',{
				replacements: {
					lat: req.params.lat,
					lng: req.params.lng
				}
			}).spread((shops, created)=>{
				var obj = Object.values(shops[0])[0];
				if(obj){
					return JSON.parse(obj);
				}else{
					return {error: true, reason: 'Either shopId or subCategoryId does not exist'}
				}
			})
			res.send(result);
		} catch(e) {
			// statements
			res.send({error: true, reason: 'database error'})
			console.log(e);
		}
	}
})

module.exports = router;