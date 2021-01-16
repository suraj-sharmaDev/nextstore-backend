/******************************************
 *  Author : Suraj Sharma
 *  Created On : Sat Jan 16 2021
 *  File : order.js
 *******************************************/
const express = require("express");
const { sequelize } = require("../models");
const router = express.Router();

router.get("/:status/:page/:startDate?/:endDate?", async (req, res, next) => {
  //get orders belonging to shop with shopId
  //based on status
  const { shopId, status, page, startDate, endDate } = req.params;
  try {
    const orders = await sequelize
      .query("exec spGetAllShopOrders :status, :page, :startDate, :endDate", {
        replacements: {
          status: status,
          page: page,
          startDate: startDate ? startDate : null,
          endDate: endDate ? endDate : null,
        },
      })
      .spread((orders, message) => {
        //since the return data will be string and not parsed
        //lets parse it
        var obj = Object.values(orders[0])[0];
        if (obj) {
          return JSON.parse(obj);
        } else {
          return [];
        }
      });
    res.send({ error: false, entity: orders });
  } catch (e) {
    res.send({ error: true, message: e });
    console.log(e);
  }
});

module.exports = router;
