module.exports = {
  apps : [
    {
      name: 'customer_nextstore',
      script: './customer/app.js',
      watch: '.'
    },
    {
      name: 'merchant_nextstore',
      script: './merchant/app.js',
      watch: '.'
    },
    {
      name: 'order_nextstore',
      script: './order/app.js',
      watch: '.'
    },
    {
      name: 'search_nextstore',
      script: './search/app.js',
      watch: '.'
    },
    {
      name: 'admin_nextstore',
      script: './admin/app.js',
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
