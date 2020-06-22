'use strict';
module.exports = (sequelize, DataTypes) => {
  const product = sequelize.define('product', {
    mrp: DataTypes.INTEGER,
    price: DataTypes.INTEGER
  }, {
    tableName : 'product',
    timestamps: false    
  });
  product.associate = function(models) {
    // associations can be defined here
    product.belongsTo(models.shop);
    product.belongsTo(models.productMaster);
  };
  return product;
};