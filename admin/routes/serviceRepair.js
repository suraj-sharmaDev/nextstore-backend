/******************************************
 *  Author : Suraj Sharma
 *  Created On : Sun Jan 17 2021
 *  File : serviceRepair.js
 *******************************************/
const express = require("express");
const { sequelize } = require("../models");
const router = express.Router();

router.post("/", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    status = await sequelize
      .query("exec spAddUpdateServiceRepairItem :json, :RepairItemId", {
        replacements: {
          json: JSON.stringify(req.body),
          RepairItemId: null,
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

router.put("/:RepairItemId", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    const { RepairItemId } = req.params;
    status = await sequelize
      .query("exec spAddUpdateServiceRepairItem :json, :RepairItemId", {
        replacements: {
          json: JSON.stringify(req.body),
          RepairItemId: RepairItemId,
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

router.post("/repairPart", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    status = await sequelize
      .query(
        "exec spAddUpdateServiceRepairParts :json, :RepairItemsAndRate_Id",
        {
          replacements: {
            json: JSON.stringify(req.body),
            RepairItemsAndRate_Id: null,
          },
        }
      )
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

router.put("/repairPart/:RepairItemsAndRate_Id", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    const { RepairItemsAndRate_Id } = req.params;
    status = await sequelize
      .query(
        "exec spAddUpdateServiceRepairParts :json, :RepairItemsAndRate_Id",
        {
          replacements: {
            json: JSON.stringify(req.body),
            RepairItemsAndRate_Id: RepairItemsAndRate_Id,
          },
        }
      )
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
