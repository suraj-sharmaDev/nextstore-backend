const express = require('express');
const {shop, address, sequelize} = require('../models');
const upload = require('../middleware/fileUpload');
const deleteFile = require('../middleware/fileDelete');

const router = express.Router();

router.get('/:shopId/:param?', async(req, res, next)=>{
	//this api is called at landing page of shop where only list of categories will be shown
	//basically this api should integrate category, subcategory and subcategory child

	//same api can be used to get basic shopInfo by passing basicInfo params
	try {
		let content = null;
		if(!req.params.param){
			// if there was not param
			content = await sequelize.query(
				'exec spCreateShopContent :shopId;', 
				{ 
					replacements: { shopId: req.params.shopId }
			}).spread((user, created)=>{
				//since the return data will be string and not parsed
				//lets parse it
				var shop = JSON.parse(user[0].shopInfo);
				var categories = JSON.parse(user[0].categories);
				var recommends = JSON.parse(user[0].recommends);
				return {shop, categories, recommends}
			})
		}else if (req.params.param === 'basic'){
			content = await sequelize.query(
				'exec spShopBasicInfo :shopId;', 
				{ 
					replacements: { shopId: req.params.shopId }
			}).spread((value, created)=>{
				//since the return data will be string and not parsed
				//lets parse it
				return value[0];
			})			
		}else{
			content = await sequelize.query(
				'exec spGetProductsInSubCategory :shopId, :subCategoryId', 
				{ 
					replacements: { 
						shopId: req.params.shopId,
						subCategoryId: req.params.param 
					}
			}).spread((product, created)=>{
				//since the return data will be string and not parsed
				//lets parse it
				var obj = Object.values(product[0])[0];
				if(obj){
					return JSON.parse(obj);
				}else{
					return {error: true, reason: 'Either shopId or subCategoryId does not exist'}
				}
			})			
		}
		res.send(content);
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
});


router.post('/:merchId', upload, async(req, res, next)=>{
	//add new shop for a merchant
	let json = JSON.parse(req.body.json);
	let files = null;
	if(typeof req.file != 'undefined' || typeof req.files != 'undefined'){
        //when file was uploaded
		files = req.file ? req.file : req.files;
	}
    //since file has been uploaded lets insert into our database
    for (let index = 0; index < files.length; index++) {
		const file = files[index];
		json.shop['image'] = file.path.split('assets/images/').slice(1).join('.');
	}
	const t = await sequelize.transaction();
	try {
		const result = await shop.create({...json.shop, merchantId: req.params.merchId}, { transaction: t });
		await result.createAddress({...json.address}, { transaction: t });
		await t.commit();
		// //also have to add a
		// console.log(result);
		res.send({message: true});
	} catch(e) {
		await t.rollback();
		res.send(e);
		console.log(e);
	}
})

router.put('/:merchId/:shopId', upload, async(req, res, next)=>{
	//either shop is edited with image and properties or just properties
	let json = null;
	let files = null;
	let prevImage = null;
	if(typeof req.file != 'undefined' || typeof req.files != 'undefined'){
        //when file was uploaded
		files = req.file ? req.file : req.files;
		json = JSON.parse(req.body.json);
		//since file has been uploaded lets insert into our database
		for (let index = 0; index < files.length; index++) {
			const file = files[index];
			json.shop['image'] = file.path.split('assets/images/').slice(1).join('.');
		}
		prevImage = await shop.findOne({
			where: {
				id: req.params.shopId
			}
		});
		//delete previous image of the shop
		deleteFile(prevImage.image);
	}else{
		json = req.body;		
	}
	const t = await sequelize.transaction();
	try{
		if(json.shop) {
			await shop.update({...json.shop},{ where: { id: req.params.shopId }}, { transaction: t });
		}
		if(json.address){
			await address.update({...json.address}, { where: { shopId: req.params.shopId }}, { transaction: t });			
		}
		await t.commit();
		res.send({message: true});
	}catch(e) {
		await t.rollback();
		res.send({error : true});
		console.log(e);
	}
});


module.exports = router;