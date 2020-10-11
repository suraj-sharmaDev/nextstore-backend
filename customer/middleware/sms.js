const fetch = require('node-fetch');

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

module.exports = sendMessage;