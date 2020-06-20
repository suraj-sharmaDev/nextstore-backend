'use strict';
module.exports = (sequelize, DataTypes) => {
  const OrderDetail = sequelize.define('orderDetail', {
    productId: DataTypes.INTEGER,
    productName: DataTypes.STRING(100),
    qty: DataTypes.INTEGER,
    price: DataTypes.INTEGER    
  }, {
    // freezeTableName : true,
    tableName : 'orderDetail',
    timestamps: false
  });
  OrderDetail.associate = function(models) {
    // associations can be defined here
    OrderDetail.belongsTo(models.orderMaster, {
      foreignKeyConstraint: true
    , onDelete: 'cascade'      
    });
  };
  return OrderDetail;
};