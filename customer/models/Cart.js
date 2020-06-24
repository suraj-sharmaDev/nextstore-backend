'use strict';
module.exports = (sequelize, DataTypes) => {
  const Cart = sequelize.define('cart', {
    productId: DataTypes.INTEGER,
    name: DataTypes.STRING(100),
    image: DataTypes.STRING(180),
    price: DataTypes.INTEGER,
    qty: DataTypes.INTEGER
  }, {
  	// freezeTableName : true,
  	tableName : 'cart',
    timestamps: false
  });
  Cart.associate = function(models) {
    // associations can be defined here
    Cart.belongsTo(models.customer,{foreignKeyConstraint: true});
  };
  return Cart;
};