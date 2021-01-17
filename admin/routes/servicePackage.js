/******************************************
 *  Author : Suraj Sharma
 *  Created On : Sun Jan 17 2021
 *  File : servicePackage.js
 *******************************************/

const express = require("express");
const { sequelize } = require("../models");
const router = express.Router();

router.post("/", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    status = await sequelize
      .query("exec spAddUpdateServicePackage :json, :packageId", {
        replacements: {
          json: JSON.stringify(req.body),
          packageId: null,
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

router.put("/:packageId", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    const { packageId } = req.params;
    console.log(packageId);
    status = await sequelize
      .query("exec spAddUpdateServicePackage :json, :packageId", {
        replacements: {
          json: JSON.stringify(req.body),
          packageId: packageId,
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

router.post("/packageItem", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    status = await sequelize
      .query("exec spAddUpdateServicePackageItem :json, :packageItemId", {
        replacements: {
          json: JSON.stringify(req.body),
          packageItemId: null,
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

router.put("/packageItem/:packageItemId", async (req, res, next) => {
  let error = true;
  let status = null;
  try {
    const { packageItemId } = req.params;
    status = await sequelize
      .query("exec spAddUpdateServicePackageItem :json, :packageItemId", {
        replacements: {
          json: JSON.stringify(req.body),
          packageItemId: packageItemId,
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
