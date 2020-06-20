'use strict';
module.exports = (sequelize, DataTypes) => {
  const Customer = sequelize.define('customer', {
    name: DataTypes.STRING,
    mobile: DataTypes.STRING,
    fcmToken: DataTypes.STRING    
  }, {
  	// freezeTableName : true,
  	tableName : 'customer',
    timestamps: false    
  });
  Customer.associate = function(models) {
    // associations can be defined here
    Customer.hasMany(models.address);
    Customer.hasMany(models.cart);
    Customer.hasMany(models.orderMaster);
  };
  return Customer;
};