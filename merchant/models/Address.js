'use strict';
module.exports = (sequelize, DataTypes) => {
  const Address = sequelize.define('address', {
    pickupAddress: DataTypes.STRING,
    latitude: DataTypes.DOUBLE,
    longitude: DataTypes.DOUBLE
  }, {
  	// freezeTableName : true,
  	tableName : 'shopAddress',
    timestamps: false    
  });
  Address.associate = function(models) {
    // associations can be defined here
    Address.belongsTo(models.shop);
  };
  return Address;
};