const express = require('express');
const {orderMaster, orderDetail, sequelize} = require('../models');
const sendMessage = require('../middleware/firebase');
const router = express.Router();

router.get('/:orderId?/:status?', async(req, res, next)=>{
	try {
		let where = {};

		req.params.orderId ? where.id = req.params.orderId : null;
		req.params.status ? where.status = req.params.status : null;
		
		const result = await orderMaster.findOne({
			attributes: ['id', 'customerId', 'shopId', 'status'],
			where: where,
			include: {model: orderDetail, attributes: ['productId', 'productName', 'price']}
		});
		res.send(result);
	} catch(e) {
		// statements
		res.send({error : true})
		console.log(e);
	}
})

router.post('/:orderId?', async(req, res, next)=>{
	//when orderId is not passed a new orderwill be created
	//else orders will be added to existent order
	try {
		if(!req.params.orderId){
			//after new order is created notification should be sent to merchant 
			//for receiving new order
			const shop = await sequelize.query(
						'DECLARE @fcmToken NVARCHAR(255); exec spCreateNewOrder :json, @fcmToken OUTPUT; select @fcmToken as fcmToken;', 
						{ 
							replacements: { json: JSON.stringify(req.body) }
						}).spread((user, created)=>{ return user[0] })
			const type = 'new_order';
			sendMessage(shop.fcmToken, type);
		}else{
			await sequelize.query('exec spbulkCreateOrderDetail :json, :orderMasterId', { 
				replacements: 
				{ 
					json: JSON.stringify(req.body), 
					orderMasterId: req.params.orderId
				}
			});
		}
		res.send({message : 'created'});
	} catch(e) {
		// statements
		res.send({error : true});
		console.log(e);
	}
})

router.put('/', async(req, res, next)=>{
	try {
		await sequelize.query('exec spbulkUpdateOrderDetail :json', { replacements: { json: JSON.stringify(req.body) }});
		res.send({message:'updated'});
	} catch(e) {
		// statements
		res.send({error : true });
		console.log(e);
	}
})

router.delete('/:orderId?', async(req, res, next)=>{
	let model = orderMaster;
	let id = req.params.orderId;
	if(!id){
		model = orderDetail;
		id = req.body;
	}
	try {
		await model.destroy({
			where : {
				id : id
			}
		});
		res.send({message : 'deleted'});
	} catch(e) {
		res.send({error : true})
		// statements
		console.log(e);
	}
})

module.exports = router;