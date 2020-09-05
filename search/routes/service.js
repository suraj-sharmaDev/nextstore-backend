const express = require('express');
const {sequelize} = require('../models');

const router = express.Router();

router.get('/', async(req, res, next)=>{
    //get all services
	try {
        const services = await sequelize.query('exec spGetAllServices')
            .spread((value, created)=>
            {
                return value;
            });
		res.send(services);
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
});

router.get('/:type/:id', async(req, res, next)=>{
    //get all services
	try {
        let error = false;
        let procedureName = null;
        let type = 0;
        if(req.params.type == 'serviceItem'){
            //get all services for category
            procedureName = `dbo.spGetAllServicesForCategory`;
            type = 1;
        }else if(req.params.type == 'serviceDetails'){
            //get all details for services
            procedureName = `dbo.spGetAllDetailsInService`;
            type = 2;
        }else if(req.params.type == 'packageRate'){
            //get package item rate
            procedureName = `dbo.spGetPackageItemRate`;
            type = 3;
        }else if(req.params.type == 'repairParts'){
            //get repair parts service and charge
            procedureName = `dbo.spGetRepairPartsServiceCharge`;
            type = 4;
        }else{
            //404 not found
            error = true;
        }

        if(!error)
        {
            const details = await sequelize.query(`exec ${procedureName} :id`, {
                replacements: {
                    id: req.params.id
                }
            })
            .spread((value, created)=>
            {
                if(type === 2 || type === 4){
                    return JSON.parse(value[0].json);
                }else{
                    return value;
                }
            });
		    res.send(details);
        }else{
            res.send({error : true, message: '404 Not Found'});            
        }
	} catch(e) {
		res.send({error : true});
		console.log(e);
	}
});

module.exports = router;