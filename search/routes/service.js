const express = require("express");
const { sequelize } = require("../models");

const router = express.Router();

router.get("/", async (req, res, next) => {
  //get all services
  try {
    const services = await sequelize
      .query("exec spGetAllServices")
      .spread((value, created) => {
        return value;
      });
    res.send(services);
  } catch (e) {
    res.send({ error: true });
    console.log(e);
  }
});

router.get("/services/:lat/:lng/:categoryId?", async (req, res, next) => {
  // get all services near the user with latitude and longitude
  // optional parameter is categoryId
  const { lat, lng, categoryId } = req.params;
  try {
    const services = await sequelize
      .query("exec spGetAllServicesNearUser :custLat, :custLng, :categoryId", {
        replacements: {
          custLat: lat,
          custLng: lng,
          categoryId: categoryId || null,
        },
      })
      .spread((value, created) => {
        return value;
      });
    res.send(services);
  } catch (e) {
    res.send({ error: true });
    console.log(e);
  }
});

router.get("/:type/:id", async (req, res, next) => {
  //get all services
  try {
    let error = false;
    let procedureName = null;
    let type = 0;
    const { type, id } = req.params;
    const isActive = req.query.isActive ? req.query.isActive : 1;
    if (type == "serviceItem") {
      //get all services for category
      procedureName = `dbo.spGetAllServicesForCategory`;
      type = 1;
    } else if (type == "serviceDetails") {
      //get all details for services
      procedureName = `dbo.spGetAllDetailsInService`;
      type = 2;
    } else if (type == "packageRate") {
      //get package item rate
      procedureName = `dbo.spGetPackageItemRate`;
      type = 3;
    } else if (type == "repairParts") {
      //get repair parts service and charge
      procedureName = `dbo.spGetRepairPartsServiceCharge`;
      type = 4;
    } else {
      //404 not found
      error = true;
    }

    if (!error) {
      const details = await sequelize
        .query(`exec ${procedureName} :id, :isActive`, {
          replacements: {
            id,
            isActive,
          },
        })
        .spread((value, created) => {
          if (type === 2 || type === 4) {
            return JSON.parse(value[0].json);
          } else {
            return value;
          }
        });
      res.send(details);
    } else {
      res.send({ error: true, message: "404 Not Found" });
    }
  } catch (e) {
    res.send({ error: true });
    console.log(e);
  }
});

module.exports = router;
