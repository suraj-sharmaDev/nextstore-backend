/******************************************
 *  Author : Suraj Sharma
 *  Created On : Tue Mar 16 2021
 *  File : billData.js
 *******************************************/
const express = require('express');
const path = require('path');
const deleteFile = require('../middleware/fileDelete');
const {sequelize} = require('../models');
const router = express.Router();

router.get('/:merchantId/:type?/:orderQuoteId?', async(req, res, next)=>{
    const {merchantId, type, orderQuoteId} = req.params;
    if(merchantId === undefined){
        res.send({error: true, message: 'merchantId should be defined'});
        return;
    }
    try {
        const status = await sequelize.query(
            'exec spRetrieveBillDetails :merchantId, :type, :orderQuoteId',
            {
                replacements: {
                    merchantId: merchantId,
                    type: type || null,
                    orderQuoteId: orderQuoteId || null
                }
            }
        ).spread((value, message)=>{
            var obj = Object.values(value[0])[0];
            if(obj){
                return JSON.parse(obj);
            }
            return [];
        })
        res.send(status);
    } catch (error) {
        console.log(error);
        res.send({error: true, message: error});
    }
});

router.post('/', async(req, res, next)=>{
    const {merchantId, orderId, quoteId} = req.body;
    const files = req.file || req.files;
    // depending on type of OS the path data will be different so
    const normalizedPath = path.normalize((files[0] || files).path).replace(/\\/g, "/");
    if(merchantId === undefined && (orderId === undefined || quoteId === undefined)) {
        deleteFile(normalizedPath);        
        res.send({error: true, message: 'merchantId, quoteId or orderId are required'});
        return;
    }

    let insertData = {
        merchantId,
        orderId,
        quoteId,
        image: null
    }
    insertData.image = normalizedPath.split('assets/images/').slice(1).join('.');
    //since file has been uploaded lets insert into our database
    try {
        status = await sequelize.query(
            'exec spInsertBillInNxtBillDetails :json', 
            { 
                replacements: { 
                    json: JSON.stringify(insertData)
                }
        }).spread((value, message)=>{
                //since the return data will be string and not parsed
                //lets parse it
                return value;
        });

        res.send({error: false, message: 'uploaded'});
    } catch (error) {
        res.send({error: true, message: error});
    }
});

module.exports = router;