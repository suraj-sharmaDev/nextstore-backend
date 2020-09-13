const express = require('express');
const {sequelize} = require('../models');
const router = express.Router();

router.get('/', (req, res, next)=>{
    res.send({error: true, message: '404'});
})

router.post('/', async(req, res, next)=>{
	try {
        const admin = await sequelize.query('exec spLoginAdmin :username, :password', {
            replacements: {
                username: req.body.username,
                password: req.body.password
            }})
            .spread((value, created)=>
            {
                return value[0];
            });
		res.json(admin);
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
})

module.exports = router;

