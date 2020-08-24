const express = require('express');
const { sequelize } = require('../models');
const router = express.Router();

router.get('/:merchId', async(req, res, next)=>{
	var merchant = null;
	try {
		merchant = await sequelize.query('EXEC spGetMerchantShops :merchId',{
			replacements: {
				merchId: req.params.merchId
			}
		}).spread((user, created)=> {
			var obj = Object.values(user[0]);
			if(obj[0]){
				return(JSON.parse(obj))
			}else{
				return {error: true, reason: 'unknown merchant Id'};
			}
		})
	} catch(e) {
		// statements
		merchant = {error: true, reason: 'database error'};
		console.log(e);
	}
	res.send(merchant);
});

router.post('/', async(req, res, next)=>{
	var merchant = null;
	try {
        const email = req.body.email;
        const password = req.body.password;
		merchant = await sequelize.query('EXEC spLoginMerchant :email, :password',{
			replacements: {
                email: email,
                password: password
			}
		}).spread((user, created)=> {
            return user[0];
		})
	} catch(e) {
		// statements
		merchant = {error: true, reason: 'database error'};
		console.log(e);
	}
	res.send(merchant);
})

router.put('/:merchId', (req, res, next)=>{
	merchant.update({...req.body},{
		where: {
			id: req.params.merchId
		}
	})
	.then((result)=>{
		res.send({updated: true});
	})
	.catch(err=>res.send(err))
})

module.exports = router;