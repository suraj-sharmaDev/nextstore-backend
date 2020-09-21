const express = require('express');
const {sequelize} = require('../models');
const router = express.Router();
const deleteFile = require('../middleware/fileDelete');

router.get('/', (req, res, next)=>{
    res.send(__dirname+'../../assets');
})

router.post('/:shopId', async(req, res, next)=>{
    //for offers
    let error = false;
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
        insertData.offer_image = file.path.split('assets/images/').slice(1).join('.');;
    }
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
    } catch (error) {
        error = true;
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
        updateData.offer_image = file.path.split('assets/images/').slice(1).join('.');;
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
    } catch (error) {
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

module.exports = router;