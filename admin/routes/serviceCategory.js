const express = require("express");
const { sequelize } = require("../models");
const router = express.Router();

router.post("/", async (req, res, next) => {
    let error = true;
    let status = null;
    try {
      status = await sequelize
        .query("exec spAddUpdateServiceCategory :json, :serviceCategoryId", {
          replacements: {
            json: JSON.stringify(req.body),
            serviceCategoryId: null,
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
  
  router.put("/:serviceCategoryId", async (req, res, next) => {
    let error = true;
    let status = null;
    try {
      const { serviceCategoryId } = req.params;
      status = await sequelize
        .query("exec spAddUpdateServiceCategory :json, :serviceCategoryId", {
          replacements: {
            json: JSON.stringify(req.body),
            serviceCategoryId: serviceCategoryId,
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
  