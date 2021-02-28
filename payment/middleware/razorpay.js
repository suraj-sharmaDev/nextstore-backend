const Razorpay = require('razorpay');

/** TEST */
// const instance = new Razorpay({
//     key_id: 'rzp_test_3pbm7wyjs8ArmH', 
//     key_secret: 'bNM8MZEMuC6OxatJ4dlKAx04'
// })

/** PRODUCTION */
const instance = new Razorpay({
    key_id: 'rzp_live_kixdopwwSaWHLu', 
    key_secret: 'QnBPOAu39SIaXTj2Ne1d7MKA'
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