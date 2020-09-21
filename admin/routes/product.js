const express = require('express');
const {sequelize} = require('../models');
const router = express.Router();

router.get('/', (req, res, next)=>{
    res.send(__dirname+'../../assets');
})

router.post('/', async(req, res, next)=>{
    //we create a new folder for the product
    //create an extra folder
    let error = false;
    let status = null;
    let files = [];
    let {name, subCategoryChildId} = req.body;
    let insertData = {
        name: name,
        subCategoryChildId: subCategoryChildId,
        image: null,
        bigImage1: null,
        bigImage2: null,
        bigImage3: null,
        bigImage4: null,
        bigImage5: null,
        bigImage6: null
    }
    if(typeof req.file != 'undefined' || typeof req.files != 'undefined'){
        //when file was uploaded
        files = req.file ? req.file : req.files;
    }
    //since file has been uploaded lets insert into our database
    for (let index = 0; index < files.length; index++) {
        const file = files[index];
        const fileName = file.fieldname;
        insertData[fileName] = file.path.split('assets/images/').slice(1).join('.');;
    }
    //insert product data in database
    try {
		status = await sequelize.query(
            'exec spInsertInProductMaster :json', 
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

router.put('/:productMasterId', async(req, res, next)=>{
    let error = false;
    let status = null;
    let files = [];
    let productMasterId = req.params.productMasterId;
    let {name, subCategoryChildId} = req.body;
    let updateData = {
        name: name,
        subCategoryChildId: subCategoryChildId
    }
    if(typeof req.file != 'undefined' || typeof req.files != 'undefined'){
        //when file was uploaded
        files = req.file ? req.file : req.files;
    }
    //since file has been uploaded lets insert into our database
    for (let index = 0; index < files.length; index++) {
        const file = files[index];
        const fileName = file.fieldname;
        updateData[fileName] = file.path.split('assets/images/').slice(1).join('.');;
    }
    //update product data in database
    try {
		status = await sequelize.query(
            'exec spUpdateInProductMaster :json, :productMasterId', 
            { 
                replacements: { 
                    json: JSON.stringify(updateData),
                    productMasterId: productMasterId
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
        res.send({error: true, message: 'not_updated'})
    }else{
        res.send({error: false, message: 'updated'})        
    }
});

module.exports = router;