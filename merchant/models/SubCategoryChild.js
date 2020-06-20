'use strict';
module.exports = (sequelize, DataTypes) => {
  const subCategoryChild = sequelize.define('subCategoryChild', {
    name: DataTypes.STRING(50)
  }, {
    tableName: 'subCategoryChild',
    timestamps: false
  });
  subCategoryChild.associate = function(models) {
    // associations can be defined here
    subCategoryChild.belongsTo(models.subCategory);
    subCategoryChild.hasMany(models.productMaster);
  };
  return subCategoryChild;
};