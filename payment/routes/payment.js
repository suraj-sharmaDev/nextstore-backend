const express = require('express');
const {sequelize} = require('../models');
const sendMessage = require('../middleware/firebase');
const router = express.Router();

router.get('/', async(req, res, next)=>{
    res.send({hello: 'world'});
})

router.post('/', async(req, res, next)=>{
	try {
		const payment = await sequelize.query(
                'exec spCreateNewPayment :json', 
                { 
                    replacements: {
                        json: JSON.stringify(req.body)
                    }
            }).spread((value, message)=>{
                return value[0];
            });

        if(payment.fcmToken!= null){
            const type = 'new_order';
			//fix the fcmTokens to array
			let fcmTokens = [];
			let parsedArray = JSON.parse(payment.fcmToken);
			parsedArray.map((p)=>{
				fcmTokens.push(p.fcmToken)
			})
			let data = {
				fcmToken: fcmTokens,
				type: type
			}
			sendMessage(data);
		}
        
		res.send({message: 'created', error: false});
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
})

module.exports = router;