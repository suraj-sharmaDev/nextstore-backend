const path = require('path');
const fs = require('fs');
const multer = require('multer');
//storage engine
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        // we require name of product so that the images always lands in particular folder
        const {name, type} = req.body;
        const folderName = name ? name.replace(/\s+/g, '_').toLowerCase() : null;
        const fileName = file.fieldname;
        let dir = null;
        switch (type) {
            case 'product':
                dir = path.join(__dirname, '../../assets/images/productPool', folderName);
                if(fileName == 'image'){
                    dir = path.join(
                            __dirname, 
                            `../../assets/images/productPool/${folderName}/400_x_400` 
                    );
                }                
                break;
            case 'offer':
                dir = path.join(__dirname, '../../assets/images/offers');
                break;
            case 'shop':
                dir = path.join(__dirname, '../../assets/images', folderName);                
                break;
            default:
                break;
        }
        fs.exists(dir, exist => {
            if (!exist) {
                return fs.mkdir(dir, { recursive: true }, error => cb(error, dir))
            }
            return cb(null, dir)
        })
    },
    filename: (req, file, callback) => {
        const {type} = req.body;
        let fileName = null;
        switch (type) {
            case 'offer':
                fileName = file.fieldname + '_' + Date.now() + path.extname(file.originalname);
                break;
            default:
                fileName = file.fieldname + path.extname(file.originalname);                
                break;
        }
        callback(null, fileName)
    }
})
//init multer upload 
const upload = multer({
    storage: storage
}).any();

module.exports = upload;