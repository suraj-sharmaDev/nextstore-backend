'use strict';
module.exports = (sequelize, DataTypes) => {
  const category = sequelize.define('category', {
    name: DataTypes.STRING(50)
  }, {
    tableName: 'category',
    timestamps: false    
  });
  category.associate = function(models) {
    // associations can be defined here
    category.hasMany(models.subCategory);
  };
  return category;
};