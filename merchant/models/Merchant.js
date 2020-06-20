'use strict';
module.exports = (sequelize, DataTypes) => {
  const merchant = sequelize.define('merchant', {
    firstName: DataTypes.STRING(100),
    lastName: DataTypes.STRING(100),
    mobile: DataTypes.STRING(30),
    fcmToken: DataTypes.STRING
  }, {
    tableName: 'merchant'
  });
  merchant.associate = function(models) {
    // associations can be defined here
    merchant.hasMany(models.shop);
  };
  return merchant;
};