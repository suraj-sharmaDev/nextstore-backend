'use strict';
module.exports = (sequelize, DataTypes) => {
  const merchant = sequelize.define('merchant', {
    firstName: DataTypes.STRING(100),
    lastName: DataTypes.STRING(100),
    mobile: DataTypes.STRING(30),
    email: DataTypes.STRING(40),
    password: DataTypes.STRING(100),    
  }, {
    tableName: 'merchant'
  });
  merchant.associate = function(models) {
    // associations can be defined here
    merchant.hasMany(models.shop,{foreignKeyConstraint: true});
  };
  return merchant;
};