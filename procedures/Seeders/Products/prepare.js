// Splits a given file into smaller subfiles by line number
var infileName = 'product.sql';
var mainName = 'product';
var fileCount = 1;
var count = 0;
var fs = require('fs');
var outStream;
var outfileName = `${mainName}${fileCount}.sql`;
var prefix = `INSERT INTO product1(mrp, price, shopId, productMasterId)VALUES`;

newWriteStream();
var inStream = fs.createReadStream(infileName);

var lineReader = require('readline').createInterface({
    input: inStream
});

function newWriteStream(){
    outfileName = `${mainName}${fileCount}.sql`;
    outStream = fs.createWriteStream(outfileName);
    count = 0;
}

lineReader.on('line', function(line) {
    if(count === 0){
        count++;
        outStream.write(prefix + '\n' + line + '\n')
    }else{
        count++;
        if(count < 900){
            outStream.write(line + '\n');
        }
        else if(count === 900) {
            outStream.write(line.replace(/.$/,";"));            
            fileCount++;
            console.log('file ', outfileName, count);
            outStream.end();
            newWriteStream();
        }
    }
});

lineReader.on('close', function() {
    if (count > 0) {
        console.log('Final close:', outfileName, count);
    }
    inStream.close();
    outStream.end();
    console.log('Done');
});