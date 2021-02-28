const express = require('express');
const router = express.Router();
const {createOrder} = require('../middleware/razorpay');

router.get('/', async(req, res, next)=>{
    res.send({hello: 'world'});
})

router.post('/', (req, res, next)=>{
    try {
        var options = req.body;
        createOrder(options)
        .then((result)=>res.send({error: false, message: result}))
        .catch((err)=>res.send({error: true, message: err}));
    } catch (err) {
        res.send({error: true, message: err})
    }
})

module.exports = router;
