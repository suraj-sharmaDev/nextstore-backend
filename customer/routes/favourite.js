const express = require('express');
const {sequelize} = require('../models');

const router = express.Router();

router.get('/:customerId', async(req, res, next)=>{
	try {
		const favourites = await sequelize.query('EXEC spGetFavouriteShops :customerId', { 
			replacements: { 
                customerId: req.params.customerId
			}
			}).spread((value, param)=>(value));	
		res.send(favourites);
	} catch(e) {
		res.send({error: true, message: 'database_error'});
		console.log(e);
	}
})

router.post('/:customerId/:shopId', async(req, res, next)=>{
	try {
		const cart = await sequelize.query('EXEC spAddShopAsFavourite :customerId, :shopId', { 
			replacements: { 
                customerId: req.params.customerId,
                shopId: req.params.shopId
			}
			});	
		res.send({message: 'created'});
	} catch(e) {
		res.send({error: true, message: 'data_non_existent'});
		console.log(e);
	}
})

router.delete('/:customerId/:shopId', async(req, res, next)=>{
	try {
		const cart = await sequelize.query('EXEC spDeleteShopFromFavourite :customerId, :shopId', { 
			replacements: { 
                customerId: req.params.customerId,
                shopId: req.params.shopId
			}
			});	
		res.send({message: 'deleted'});
	} catch(e) {
		res.send({error: true, message: 'database_error'});
		console.log(e);
	}
})

module.exports = router;