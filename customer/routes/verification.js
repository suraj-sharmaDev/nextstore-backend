const express = require('express');
const {sequelize} = require('../models');
const router = express.Router();

router.post('/', async(req, res, next)=>{
    const customerId = req.body.customerId;
    const otpCode = req.body.otpCode;
    let user = null;
    try {
		user = await sequelize.query('EXEC spVerifyCustomerOtp :customerId, :otp',{
			replacements: {
                customerId: customerId,
                otp: otpCode
			}
		}).spread((value, created)=> {
            return value[0];
        });
    } 
    catch(e) {
        console.log(e)
        user = {error: true, message: 'database_error'};
    }
    res.send(user);
});

module.exports = router;