const Razorpay = require('razorpay');

/** TEST */
const instance = new Razorpay({
    key_id: 'rzp_test_mbxyyMiUsc7oYz', 
    key_secret: 'Z4Bfn0BM28UzTjI5EkJ2dJTL'
})

/** PRODUCTION */
// const instance = new Razorpay({
//     key_id: 'rzp_live_kixdopwwSaWHLu', 
//     key_secret: 'QnBPOAu39SIaXTj2Ne1d7MKA'
// })

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