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

router.post('/', async(req, res, next)=>{
	//create a new quote by customer
	try {
		const serviceProvider = await sequelize.query(
			'exec spCreateNewQuote :json', 
			{ 
				replacements: { json: JSON.stringify(req.body) }
			}).spread((user, created)=>{
				return (user); 
			})
		const type = 'new_quote';
		if(serviceProvider.length > 0){
			let fcmToken = [];
			serviceProvider.map((s)=>{
				if(s.fcmToken != null){
					fcmToken.push(s.fcmToken)
				}
			});
			//send push notification to service providers only if valid fcmToken available
			if(fcmToken.length > 0){
				let data = {
					fcmToken: fcmToken,
					type: type
				}
				sendMessage(data);
			}
		}
		//send api request back to client
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

module.exports = router;