const fetch = require('node-fetch');

const API_END_POINT = {
    razorPayCreateOrder: 'http://localhost:3011/order'
}

const createRazorPayOrder = (options) => {
    console.log(API_END_POINT.razorPayCreateOrder, JSON.stringify(options));
    return new Promise((resolve, reject) => {
        fetch(API_END_POINT.razorPayCreateOrder, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },            
            body: JSON.stringify(options) 
        })
        .then(res => res.json())
        .then(json => resolve(json))
        .catch((err)=> reject(err));
    })
}

module.exports = {
    createRazorPayOrder
}