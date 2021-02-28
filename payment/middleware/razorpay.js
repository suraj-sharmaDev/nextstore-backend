const Razorpay = require('razorpay');

const instance = new Razorpay({
    key_id: 'rzp_test_3pbm7wyjs8ArmH', 
    key_secret: 'bNM8MZEMuC6OxatJ4dlKAx04'
})

const createOrder = (options) => {
    return new Promise((resolve, reject)=> {
        instance.orders.create(options, function(err, order) {
            if(err) reject(err);
            else resolve(order)
        });        
    })
}

module.exports = {
    createOrder
}