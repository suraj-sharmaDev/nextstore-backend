const fs = require('fs');
const path = require('path');

const deleteFile = async(filePath) => {
    var relativePath = path.join(__dirname, '../../assets/images', filePath);
    try {
        fs.unlink(relativePath, function(err) {
            if(err && err.code == 'ENOENT') {
                // file doens't exist
                // console.info("File doesn't exist, won't remove it.");
                // console.log(relativePath);
            } else if (err) {
                // other errors, e.g. maybe we don't have enough permission
                // console.error("Error occurred while trying to remove file");
            } else {
                // console.info(`removed`);
            }
        });        
    } catch (error) {
        console.log(error);
    }
}

module.exports = deleteFile;