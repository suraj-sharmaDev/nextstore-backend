const express = require('express');
const {sequelize} = require('../models');
const sendMessage = require('../middleware/firebase');
const router = express.Router();


router.get('/:serviceProviderId/:status/:page/:startDate?/:endDate?', async(req, res, next)=>{
	//get quotes belonging to serviceProvider with serviceProviderId
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

router.post('/:quoteId?', async(req, res, next)=>{
	//when quoteId is not passed a new quote will be created
	//else details will be added to existent quotes
	let quoteMasterId = null;
	try {
		if(!req.params.quoteId){
			//after new quote is created notification should be sent to merchant 
			//for receiving new quote
			const serviceProvider = await sequelize.query(
						'exec spCreateNewQuote :json', 
						{ 
							replacements: { json: JSON.stringify(req.body) }
						}).spread((user, created)=>{ 
							return user[0]; 
						})
			const type = 'new_quote';
			quoteMasterId = serviceProvider.quoteMasterId;
			if(serviceProvider.fcmToken!= null){
				let data = {
					fcmToken: serviceProvider.fcmToken,
					quoteId: quoteMasterId,
					type: type
				}
				console.log(data);
				// sendMessage(data);
			}
		}else{
			await sequelize.query('exec spbulkCreateQuoteDetail :json, :quoteMasterId', { 
				replacements: 
				{ 
					json: JSON.stringify(req.body), 
					quoteMasterId: req.params.quoteId
				}
			});
		}
		res.send({message : 'created', quoteId: quoteMasterId});
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