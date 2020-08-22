'use strict';
module.exports = (sequelize, DataTypes) => {
  const Address = sequelize.define('address', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true
    },
    label: DataTypes.STRING(100),
    addressName: DataTypes.STRING(100),
    landmark: DataTypes.STRING,
    latitude: DataTypes.DOUBLE,
    longitude: DataTypes.DOUBLE,
    reverseAddress: DataTypes.STRING
  }, {
  	// freezeTableName : true,
  	tableName : 'customerAddress',
    timestamps: false    
  });
  Address.associate = function(models) {
    // associations can be defined here
    Address.belongsTo(models.customer,{foreignKeyConstraint: true});
  };
  return Address;
};