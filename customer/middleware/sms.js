const fetch = require('node-fetch');

/** CRYPT4BITSPVTLTD SMS API START */

const ver = 1;
const mode = 1;
const action = 'push_sms';
const type = 1;
const route = 4;
const loginName = 'CRYPT4BITSPVTLTD';
const apiPassword = 'c27c8716018093418282';
const sender = 'cbycfb';
const apiUrl = 'http://sms.xpresssms.in/api/api.php';

const sendMessage = (data) => {
    let url = apiUrl;
    url += `?ver=${ver}`;
    url += `&mode=${mode}`;
    url += `&action=${action}`;
    url += `&type=${type}`;
    url += `&route=${route}`;
    url += `&login_name=${loginName}`;
    url += `&api_password=${apiPassword}`;
    url += `&number=${data.mobile}`
    url += `&message=${data.message}`;
    url += `&sender=${sender}`; 
    fetch(url)
    .then((res)=>{})
    .catch((err)=>{console.log(err)});
}

/** CRYPT4BITSPVTLTD SMS API END */

/** NXTSTORES SMS API START */
// const apiUrl = 'https://api.textlocal.in/send/?';
// // const apiKey = encodeURIComponent('FFvh8FKfRgA-xtzMRxmHEiNuOnwaEwklepOtaTort7');
// // const sender = encodeURIComponent('ZISMDV');
// const apiKey = 'FFvh8FKfRgA-xtzMRxmHEiNuOnwaEwklepOtaTort7';
// const sender = 'ZISMDV';
// /** NXTSTORES SMS API END */

// const sendMessage = (data) => {
//     const message = `
//     Hi,
//     Welcome message , Your customer ID is ${data.message}
//     Thanks
//     MedV
//     `;
//     const encodedMessage = encodeURIComponent(message);
//     // const numbers = encodeURIComponent(data.mobile);
//     const numbers = data.mobile;    
//     let url = apiUrl;
//     url += `apikey=${apiKey}`;
//     url += `&numbers=${numbers}`;
//     url += `&sender=${sender}`;
//     url += `&message=${encodedMessage}`;
//     console.log(url);
// }

module.exports = sendMessage;