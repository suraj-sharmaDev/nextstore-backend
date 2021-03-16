const path = require('path');
const fs = require('fs');
const multer = require('multer');
//storage engine
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const dir = path.join(__dirname, '../../assets/images/bills');
        if (fs.existsSync(dir)) {
            return cb(null, dir);
        }else {
            return fs.mkdir(dir, { recursive: true }, error => cb(error, dir));
        }
    },
    filename: (req, file, callback) => {
        const fileName = file.fieldname + '_' + Date.now() + path.extname(file.originalname);
        callback(null, fileName)
    }
})

//init multer upload 
const upload = multer({
    storage: storage
}).any();

module.exports = upload;