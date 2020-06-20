'use strict';
module.exports = (sequelize, DataTypes) => {
  const productMaster = sequelize.define('productMaster', {
    name: DataTypes.STRING(100),
    image: DataTypes.STRING(180)
  }, {
    tableName: 'productMaster',
    timestamps: false    
  });
  productMaster.associate = function(models) {
    // associations can be defined here
    productMaster.hasMany(models.product);
    productMaster.belongsTo(models.subCategoryChild);
  };
  return productMaster;
};