'use strict';
module.exports = (sequelize, DataTypes) => {
  const OrderMaster = sequelize.define('orderMaster', {
    customerId: DataTypes.INTEGER,
    shopId: DataTypes.INTEGER,
    status: {
      type: DataTypes.STRING(20),
      defaultValue: "pending"
    },
    createdAt: DataTypes.DATE
  }, {
    // freezeTableName : true,
    tableName : 'orderMaster',
    timestamps: false
  });
  OrderMaster.associate = function(models) {
    // associations can be defined here
    OrderMaster.hasMany(models.orderDetail,{foreignKeyConstraint: true});
  };
  return OrderMaster;
};