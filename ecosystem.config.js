module.exports = {
  apps : [
    {
      name: 'customer_nextstore',
      script: './customer/app.js',
      watch: true,
      ignore_watch: ["node_modules"]
    },
    {
      name: 'merchant_nextstore',
      script: './merchant/app.js',
      watch: true,
      ignore_watch: ["node_modules"]
    },
    {
      name: 'order_nextstore',
      script: './order/app.js',
      watch: true,
      ignore_watch: ["node_modules"]
    },
    {
      name: 'search_nextstore',
      script: './search/app.js',
      watch: true,
      ignore_watch: ["node_modules"]
    },
    {
      name: 'admin_nextstore',
      script: './admin/app.js',
      watch: true,
      ignore_watch: ["node_modules"]
    },
    {
      name: 'payment_nextstore',
      script: './payment/app.js',
      watch: true,
      ignore_watch: ["node_modules"]
    },    
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
