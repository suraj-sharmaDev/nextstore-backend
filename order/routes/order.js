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
			attributes: ['id', 'customerId', 'shopId', 'status', 'deliveryAddress'],
			where: where,
			include: {model: orderDetail, attributes: ['productId', 'productName', 'price', 'qty']}
		});
		res.send(result);
	} catch(e) {
		// statements
		res.send({error : true})
		console.log(e);
	}
})

router.get('/:shopId/:status/:page/:startDate?/:endDate?', async(req, res, next)=>{
	//get orders belonging to shop with shopId
	//based on status
    const shopId = req.params.shopId;
    const status = req.params.status;
    const page = req.params.page;
    const startDate = req.params.startDate;
    const endDate = req.params.endDate;
	try {
		const orders = await sequelize.query(
                'exec spGetShopOrders :shopId, :status, :page, :startDate, :endDate', 
                { 
                    replacements: { 
                        shopId: shopId, 
                        status: status, 
                        page: page, 
                        startDate: startDate? startDate: null, 
                        endDate: endDate? endDate : null
                    }
            }).spread((orders, message)=>{
					//since the return data will be string and not parsed
					//lets parse it
                    var obj = Object.values(orders[0])[0];
					if(obj){
						return JSON.parse(obj);
					}else{
						return {error: true, reason: 'Either shopId or subCategoryId does not exist'}
					}
            });
		res.send(orders);
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
});

router.post('/:orderId?', async(req, res, next)=>{
	//when orderId is not passed a new orderwill be created
	//else orders will be added to existent order
	let orderMasterId = null;
	try {
		if(!req.params.orderId){
			//after new order is created notification should be sent to merchant 
			//for receiving new order
			const shop = await sequelize.query(
						'DECLARE @fcmToken NVARCHAR(255); exec spCreateNewOrder :json', 
						{ 
							replacements: { json: JSON.stringify(req.body) }
						}).spread((user, created)=>{ 
							return user[0]; 
						})
			const type = 'new_order';
			orderMasterId = shop.orderMasterId;
			if(shop.fcmToken!= null){
				sendMessage(shop.fcmToken, type);
			}
		}else{
			await sequelize.query('exec spbulkCreateOrderDetail :json, :orderMasterId', { 
				replacements: 
				{ 
					json: JSON.stringify(req.body), 
					orderMasterId: req.params.orderId
				}
			});
		}
		res.send({message : 'created', orderId: orderMasterId});
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