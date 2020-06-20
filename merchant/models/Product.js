'use strict';
module.exports = (sequelize, DataTypes) => {
  const product = sequelize.define('product', {
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