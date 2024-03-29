const express = require("express");
const { sequelize } = require("../models");
const router = express.Router();

router.get("/:page?", async (req, res, next) => {
  let error = true;
  let status = null;
  let page = req.params.page ? req.params.page : 1;
  try {
    status = await sequelize
      .query("exec spGetServiceProvidersWithFilter :json, :page", {
        replacements: {
          json: JSON.stringify(req.query),
          page: page,
        },
      })
      .spread((value, message) => {
        //since the return data will be string and not parsed
        //lets parse it
        return value;
      });
    error = false;
  } catch (err) {
    error = true;
    console.log(err);
  }
  if (error) {
    res.send({ error: true, message: "db_error" });
  } else {
    res.send(status);
  }
});

router.get("/:status/:page/:startDate?/:endDate?", async (req, res, next) => {
  //get quotes belonging to service provider irrespective of their ids
  //based on status
  const { shopId, status, page, startDate, endDate } = req.params;
  try {
    const orders = await sequelize
      .query(
        "exec spGetAllServiceProviderQuotes :status, :page, :startDate, :endDate",
        {
          replacements: {
            status: status,
            page: page,
            startDate: startDate ? startDate : null,
            endDate: endDate ? endDate : null,
          },
        }
      )
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

router.post("/", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    status = await sequelize
      .query("exec spAddUpdateServiceItem :json, :serviceItemId", {
        replacements: {
          json: JSON.stringify(req.body),
          serviceItemId: null,
        },
      })
      .spread((value, message) => {
        //since the return data will be string and not parsed
        //lets parse it
        return value[0];
      });
    error = false;
  } catch (err) {
    error = true;
    console.log(err);
  }
  if (error) {
    res.send({ error: true, message: "db_error" });
  } else {
    res.send(status);
  }
});

router.put("/:serviceItemId", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    const { serviceItemId } = req.params;
    status = await sequelize
      .query("exec spAddUpdateServiceItem :json, :serviceItemId", {
        replacements: {
          json: JSON.stringify(req.body),
          serviceItemId: serviceItemId,
        },
      })
      .spread((value, message) => {
        //since the return data will be string and not parsed
        //lets parse it
        return value[0];
      });
    error = false;
  } catch (err) {
    error = true;
    console.log(err);
  }
  if (error) {
    res.send({ error: true, message: "db_error" });
  } else {
    res.send(status);
  }
});

module.exports = router;
