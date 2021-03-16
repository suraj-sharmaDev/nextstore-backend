const express = require('express');
const {sequelize} = require('../models');
const router = express.Router();
const deleteFile = require('../middleware/fileDelete');
const path = require('path');

router.get('/:page?/:shopId?', async(req, res, next)=>{
    //list out all offers belonging to shops
    let error = true;
    let status = null;
    let page = req.params.page ? req.params.page : 1;
    let shopId = req.params.shopId ? req.params.shopId : null;
    try {
        status = await sequelize.query(
            'exec spGetshopOffersForShop :shopId, :page', 
            { 
                replacements: { 
                    shopId: shopId,
                    page: page
                }
        }).spread((value, message)=>{
                //since the return data will be string and not parsed
                //lets parse it
                return value;
        });
        error = false;
    } catch (err) {
        error = true;
    }
    if(error){
        res.send({error: true, message: 'db_error'});
    }else{
        res.send(status);
    }
})

router.post('/:shopId', async(req, res, next)=>{
    //for offers
    let error = true;
    let status = null;
    let files = [];
    let insertData = {
        shopId: req.params.shopId,
        offer_image: null,
    }
    if(typeof req.file != 'undefined' || typeof req.files != 'undefined'){
        //when file was uploaded
        files = req.file ? req.file : req.files;
    }
    //since file has been uploaded lets insert into our database
    for (let index = 0; index < files.length; index++) {
        const file = files[index];
        const normalizedPath = path.normalize(file.path).replace(/\\/g, "/");
        insertData.offer_image = normalizedPath.split('assets/images/').slice(1).join('.');
    }
    if(files.length > 0){
        //insert offer data in database
        try {
            status = await sequelize.query(
                'exec spInsertInshopOffers :json', 
                { 
                    replacements: { 
                        json: JSON.stringify(insertData)
                    }
            }).spread((value, message)=>{
                    //since the return data will be string and not parsed
                    //lets parse it
                    return value;
            });
            error = false;
        } catch (err) {
            error = true;
        }
    }
    if(error){
        res.send({error: true, message: 'not_created'})
    }else{
        res.send({error: false, message: 'created'})        
    }
});

router.put('/:offerId/:shopId', async(req, res, next)=>{
    let error = false;
    let status = null;
    let files = [];
    let {offerId, shopId} = req.params;
    let updateData = {
        shopId: shopId
    }
    if(typeof req.file != 'undefined' || typeof req.files != 'undefined'){
        //when file was uploaded
        files = req.file ? req.file : req.files;
    }
    //since file has been uploaded lets insert into our database
    for (let index = 0; index < files.length; index++) {
        const file = files[index];
        const normalizedPath = path.normalize(file.path).replace(/\\/g, "/");
        updateData.offer_image = normalizedPath.split('assets/images/').slice(1).join('.');;
    }
    //update product data in database
    try {
		status = await sequelize.query(
            'exec spUpdateInshopOffers :json, :offerId', 
            { 
                replacements: { 
                    json: JSON.stringify(updateData),
                    offerId: offerId
                }
        }).spread((value, message)=>{
                //since the return data will be string and not parsed
                //lets parse it
                return value;
        });
    } catch (err) {
        error = true;
    }
    //after previous image is found delete it from filesystem
    // console.log(status[0].previousImage);
    deleteFile(status[0].previousImage);
    if(error){
        res.send({error: true, message: 'not_updated'})
    }else{
        res.send({error: false, message: 'updated'})        
    }
});

router.delete('/:offerId', async(req, res, next)=>{
    const {offerId} = req.params;
    let status = null;
    let error = true;
    try {
		status = await sequelize.query(
            'exec spDeleteInshopOffers :offerId', 
            { 
                replacements: { 
                    offerId: offerId
                }
        }).spread((value, message)=>{
                //since the return data will be string and not parsed
                //lets parse it
                return value;
        });
        error = false;
    } catch (err) {
        error = true;
    }
    //after previous image is found delete it from filesystem
    deleteFile(status[0].previousImage);
    if(error){
        res.send({error: true, message: 'not_deleted'})
    }else{
        res.send({error: false, message: 'deleted'})        
    }    
});
module.exports = router;