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
    Customer.hasMany(models.address,{foreignKeyConstraint: true});
    Customer.hasMany(models.cart,{foreignKeyConstraint: true});
    Customer.hasMany(models.orderMaster,{foreignKeyConstraint: true});
  };
  return Customer;
};