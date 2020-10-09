const express = require('express');
const {orderMaster, orderDetail, sequelize} = require('../models');
const sendMessage = require('../middleware/firebase');
const router = express.Router();

router.get('/acceptOrder/:orderId', async(req, res, next)=>{
	try {
		const customer = await sequelize.query(
						'exec spAcceptOrder :orderId', 
						{ 
							replacements: { orderId: req.params.orderId }
						}).spread((user, created)=>{ return user[0] })
		const type = 'accept_order';
		if(customer.fcmToken!= null){
			let data = {
				fcmToken: customer.fcmToken,
				orderId: req.params.orderId,
				type: type
			}
			sendMessage(data);
		}
		res.send({message : 'accepted'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

router.get('/completeOrder/:orderId', async(req, res, next)=>{
	try {
		const customer = await sequelize.query(
						'exec spCompleteOrder :orderId', 
						{ 
							replacements: { orderId: req.params.orderId }
					}).spread((user, created)=>{ return user[0] })
		const type = 'complete_order';
		if(customer.fcmToken!= null){
			let data = {
				fcmToken: customer.fcmToken,
				orderId: req.params.orderId,
				type: type
			}
			sendMessage(data);
		}
		res.send({message : 'delivered'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

router.get('/rejectOrder/:orderId', async(req, res, next)=>{
	try {
		const customer = await sequelize.query(
						'exec spRejectOrder :orderId', 
						{ 
							replacements: { orderId: req.params.orderId }
					}).spread((user, created)=>{ return user[0] })
		const type = 'reject_order';
		if(customer.fcmToken!= null){
			let data = {
				fcmToken: customer.fcmToken,
				orderId: req.params.orderId,
				type: type
			}
			sendMessage(data);
		}
		res.send({message : 'rejected'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

router.post('/bidQuote/:quoteMasterId/:serviceProviderId', async(req, res, next)=>{
	//accept the bid
	try {
		let message = '';
		const customer = await sequelize.query(
						'exec spBidQuoteFromCustomer :quoteMasterId, :serviceProviderId, :json', 
						{ 
							replacements: { 
								quoteMasterId: req.params.quoteMasterId,
								serviceProviderId: req.params.serviceProviderId,
								json: JSON.stringify(req.body)
							}
					}).spread((user, created)=>{ return user[0] })
		if(customer.error == 0){
			//bid went succesfully
			const type = 'bidded_quote';
			if(customer.fcmToken!= null){
				//send notification to customer when bid is complete
				let data = {
					fcmToken: customer.fcmToken,
					type: type
				}
				sendMessage(data);
			}
			message = {
				error: false,
				message: 'bid_success'
			};
		}else{
			//bid failed
			message = {
				error: true,
				message: 'bid_failed'
			};
		}
		res.send(message);
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

router.get('/acceptQuote/:quoteMasterId/:serviceProviderId', async(req, res, next)=>{
	//accept the quote from customer by serviceProvider
	try {
		let message = '';
		const customer = await sequelize.query(
						'exec spAcceptQuoteFromCustomer :quoteMasterId, :serviceProviderId', 
						{ 
							replacements: { 
								quoteMasterId: req.params.quoteMasterId,
								serviceProviderId: req.params.serviceProviderId
							}
					}).spread((user, created)=>{ return user[0] })
		if(customer.fcmToken){
			//send notification to customer when quote is accepted
			let data = {
				fcmToken: customer.fcmToken,
				type: 'bid_accepted'
			}
			sendMessage(data);
		}
		message = {
			error: false,
			message: 'bid_accepted'
		};
		res.send(message);
	} catch (error) {
		// statements
		res.send({error: true});
		console.log(e);		
	}
});

router.get('/rejectQuote/:quoteMasterId/:serviceProviderId', async(req, res, next)=>{
	//reject the quote from customer by serviceProvider
	try {
		let message = '';
		const customer = await sequelize.query(
						'exec spRejectQuoteFromCustomer :quoteMasterId, :serviceProviderId', 
						{ 
							replacements: { 
								quoteMasterId: req.params.quoteMasterId,
								serviceProviderId: req.params.serviceProviderId
							}
					}).spread((user, created)=>{ return user[0] })
		if(customer.fcmToken){
			//send notification to customer when quote is rejected
			let data = {
				fcmToken: customer.fcmToken,
				type: 'bid_rejected'
			}
			sendMessage(data);
		}
		message = {
			error: false,
			message: 'bid_rejected'
		};
		res.send(message);
	} catch (error) {
		// statements
		res.send({error: true});
		console.log(e);		
	}
});

router.get('/acceptBid/:quoteBiddingId/:serviceProviderId', async(req, res, next)=>{
	//accept the bid from serviceProvider by customer
	try {
		let message = '';
		const serviceProvider = await sequelize.query(
						'exec spAcceptBiddingFromServiceProvider :quoteBiddingId, :serviceProviderId', 
						{ 
							replacements: { 
								quoteBiddingId: req.params.quoteBiddingId,
								serviceProviderId: req.params.serviceProviderId
							}
					}).spread((user, created)=>{ return user[0] })
		if(serviceProvider.fcmToken){
			//notify service provider that his bid was accepted
			let data = {
				fcmToken: serviceProvider.fcmToken,
				type: 'bid_accepted'
			}
			sendMessage(data);
		}
		message = {
			error: false,
			message: 'bid_accepted'
		};
		res.send(message);
	} catch (error) {
		// statements
		res.send({error: true});
		console.log(e);		
	}
});
module.exports = router;