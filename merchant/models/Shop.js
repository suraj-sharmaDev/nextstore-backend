'use strict';
module.exports = (sequelize, DataTypes) => {
  const shop = sequelize.define('shop', {
  	name: DataTypes.STRING,
  	category: DataTypes.STRING(50),
  	onlineStatus: {
  		type: DataTypes.BOOLEAN,
  		defaultValue: 1
  	},
    image: DataTypes.STRING,
    coverage: DataTypes.INTEGER,
    fcmToken: DataTypes.STRING   
  }, {
  	tableName: 'shop',
    timestamps: false
  });
  shop.associate = function(models) {
    // associations can be defined here
    shop.hasOne(models.address,{foreignKeyConstraint: true});
    shop.belongsTo(models.merchant,{foreignKeyConstraint: true});
  };
  return shop;
};