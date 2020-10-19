// Splits a given file into smaller subfiles by line number
var infileName = 'productMaster.sql';
var mainName = 'productMaster';
var fileCount = 9;
var count = 0;
var fs = require('fs');
var outStream;
var outfileName = `${mainName}${fileCount}.sql`;
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
    count++;
    outStream.write(line + '\n');
    if (count >= 3000) {
        fileCount++;
        console.log('file ', outfileName, count);
        outStream.end();
        newWriteStream();
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