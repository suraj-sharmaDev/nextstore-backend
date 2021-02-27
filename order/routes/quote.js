const express = require('express');
const {sequelize} = require('../models');
const sendMessage = require('../middleware/firebase');
const router = express.Router();


router.get('/:quoteMasterId', async(req, res, next)=>{
	//Get detail of quote using quoteMasterId
	try {
		const quoteDetail = await sequelize.query(
                'exec spGetQuoteDetails :quoteMasterId', 
                { 
                    replacements: { 
                        quoteMasterId: req.params.quoteMasterId
                    }
            }).spread((quotes, message)=>{
					//since the return data will be string and not parsed
					//lets parse it
                    var obj = Object.values(quotes[0])[0];
					if(obj){
						return JSON.parse(obj);
					}else{
						return [];
					}
            });
		res.send(quoteDetail);
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
});

router.get('/:serviceProviderId/:status/:page/:startDate?/:endDate?', async(req, res, next)=>{
	//get orders belonging to shop with shopId
	//based on status
    const serviceProviderId = req.params.serviceProviderId;
    const status = req.params.status;
    const page = req.params.page;
    const startDate = req.params.startDate;
    const endDate = req.params.endDate;
	try {
		const quotes = await sequelize.query(
                'exec spGetServiceProviderQuotes :serviceProviderId, :status, :page, :startDate, :endDate', 
                { 
                    replacements: { 
                        serviceProviderId: serviceProviderId, 
                        status: status, 
                        page: page, 
                        startDate: startDate? startDate: null, 
                        endDate: endDate? endDate : null
                    }
            }).spread((quotes, message)=>{
					//since the return data will be string and not parsed
					//lets parse it
                    var obj = Object.values(quotes[0])[0];
					if(obj){
						return JSON.parse(obj);
					}else{
						return [];
					}
            });
		res.send(quotes);
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
});

router.post('/', async(req, res, next)=>{
	//create a new quote by customer
	let quoteId;
	try {
		const serviceProvider = await sequelize.query(
			'exec spCreateNewQuote :json', 
			{ 
				replacements: { json: JSON.stringify(req.body) }
			}).spread((user, created)=>{
				return (user); 
			});
		quoteId = serviceProvider.quoteId;
		/**
		 * After payment gateway flow has been added we dont notify the admin and merchant
		 * now itself.
		 * The create order flow now is :
		 * 1. Create a order
		 * 2. Use the order Id to create payment
		 * 3. Then pass order Id and payment Info to server and store
		 * 4. Then notify required parties
		 */
	
		 // const type = 'new_quote';
		// if(serviceProvider.length > 0){
		// 	let fcmToken = [];
		// 	serviceProvider.map((s)=>{
		// 		if(s.fcmToken != null){
		// 			fcmToken.push(s.fcmToken)
		// 		}
		// 	});
		// 	//send push notification to service providers only if valid fcmToken available
		// 	if(fcmToken.length > 0){
		// 		let data = {
		// 			fcmToken: fcmToken,
		// 			type: type
		// 		}
		// 		sendMessage(data);
		// 	}
		// }

		//send api request back to client
		res.send({message : 'created', quoteId});

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

module.exports = router;