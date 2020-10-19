const express = require('express');
const {customer, sequelize} = require('../models');
const sendMessage = require('../middleware/sms');
const router = express.Router();

router.get('/:custId', async(req, res, next)=>{
	var user = null;
	try {
		user = await sequelize.query('EXEC spInitializeCustomer :custId',{
			replacements: {
				custId: req.params.custId
			}
		}).spread((value, created)=> {
			var obj = Object.values(value[0]);
			if(obj[0]){
				return(JSON.parse(obj))
			}else{
				return {error: true, reason: 'unknown customer Id'};
			}
		})
	} catch(e) {
		// statements
		user = {error: true, reason: 'database error'};
		console.log(e);
	}
	res.send(user);
})

router.post('/', async(req, res, next)=>{
	var user = null;
	try {
		//check if mobile number is valid or not
		let mobile = req.body.mobile;
		if(mobile.length >= 10){
			user = await sequelize.query('EXEC spLoginOrSignupCustomer :mobile',{
				replacements: {
					mobile: mobile
				}
			}).spread((value, created)=> {
				return value[0];
			});
			// after getting result we have to send OTP to users mobile
			//remaining
			// sendMessage({
			// 	mobile: user.mobile, 
			// 	message: `Your nxtStores OTP is : ${user.otp}. Please DO NOT share this with anyone!.`
			// });
			res.send(user);
		}else{
			res.json({error: true, message: 'invalid_number'});
		}
	} catch(e) {
		res.json({error: true, message: 'database_error'});
		// statements
		console.log(e);
	}
})

router.put('/:customerId', async(req, res, next)=>{
	try {
		await customer.update({...req.body},{where: { id: req.params.customerId }});
		res.send({message: 'updated'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

module.exports = router;