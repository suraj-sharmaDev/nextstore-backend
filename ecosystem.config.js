module.exports = {
  apps : [
    {
      name: 'customer',
      script: './customer/app.js',
      watch: '.'
    },
    {
      name: 'merchant',
      script: './merchant/app.js',
      watch: '.'
    },
    {
      name: 'order',
      script: './order/app.js',
      watch: '.'
    },
    {
      name: 'search',
      script: './search/app.js',
      watch: '.'
    }        
  ],

  deploy : {
    production : {
      user : 'SSH_USERNAME',
      host : 'SSH_HOSTMACHINE',
      ref  : 'origin/master',
      repo : 'GIT_REPOSITORY',
      path : 'DESTINATION_PATH',
      'pre-deploy-local': '',
      'post-deploy' : 'npm install && pm2 reload ecosystem.config.js --env production',
      'pre-setup': ''
    }
  }
};
