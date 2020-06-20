const express = require('express');
const {category, subCategory, subCategoryChild} = require('../models');

const router = express.Router();

router.get('/:type?/:id?', async(req, res, next)=>{
	let model = null;
	let include = null;
	switch (req.params.type) {
		case 'subCategory':
			model = subCategory;
			include = {model: subCategoryChild};
			break;
		case 'subCategoryChild':
			model = subCategoryChild;
			include = 'productMasters';
			break;
		default:
			model = category;
			include = {model: subCategory,include: {model: subCategoryChild}}			
			break;
	}

	try {
		const result = await model.findAll({
			where: req.params.id ? {id: req.params.id} : {},
			include: include
		});
		res.send(result);
	} catch(e) {
		res.send(e);
		console.log(e);
	}
})

router.post('/:type?', async(req, res, next)=>{
	let model = null;
	switch (req.params.type) {
		case 'subCategory':
			model = subCategory;
			break;
		case 'subCategoryChild':
			model = subCategoryChild;
			break;
		default:
			model = category;
			break;
	}
	try {
		const result = model.create({...req.body});
		res.send({message : 'created'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

router.put('/:type?/:id?', async(req, res, next)=>{
	let model = null;
	switch (req.params.type) {
		case 'subCategory':
			model = subCategory;
			break;
		case 'subCategoryChild':
			model = subCategoryChild;
			break;
		default:
			model = category;
			break;
	}
	try {
		const result = model.update({...req.body},{
			where:{
				id: req.params.id
			}
		});
		res.send({message : 'updated'});
	} catch(e) {
		// statements
		res.send({error: true});
		console.log(e);
	}
})

module.exports = router;