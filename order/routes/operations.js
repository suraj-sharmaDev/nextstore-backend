const express = require('express');
const {orderMaster, orderDetail, sequelize} = require('../models');
const sendMessage = require('../middleware/firebase');
const router = express.Router();

router.get('/acceptOrder/:orderId', async(req, res, next)=>{
	try {
		const customer = await sequelize.query(
						'DECLARE @fcmToken NVARCHAR(255); exec spAcceptOrder :orderId, @fcmToken OUTPUT; select @fcmToken as fcmToken;', 
						{ 
							replacements: { orderId: req.params.orderId }
					}).spread((user, created)=>{ return user[0] })
		const type = 'accept_order';
		sendMessage(customer.fcmToken, type);
		res.send({message : 'accepted'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

router.get('/rejectOrder/:orderId', async(req, res, next)=>{
	try {
		const customer = await sequelize.query(
						'DECLARE @fcmToken NVARCHAR(255); exec spRejectOrder :orderId, @fcmToken OUTPUT; select @fcmToken as fcmToken;', 
						{ 
							replacements: { orderId: req.params.orderId }
					}).spread((user, created)=>{ return user[0] })
		const type = 'reject_order';
		sendMessage(customer.fcmToken, type);
		res.send({message : 'rejected'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

module.exports = router;