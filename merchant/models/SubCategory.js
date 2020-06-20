'use strict';
module.exports = (sequelize, DataTypes) => {
  const subCategory = sequelize.define('subCategory', {
    name: DataTypes.STRING(50)
  }, {
    tableName: 'subCategory',
    timestamps: false    
  });
  subCategory.associate = function(models) {
    // associations can be defined here
    subCategory.belongsTo(models.category);
    subCategory.hasMany(models.subCategoryChild);
  };
  return subCategory;
};