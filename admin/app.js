const express = require("express");
const cors = require("cors");
const createError = require("http-errors");
const {
  admin,
  product,
  shopOffer,
  merchant,
  shop,
  service,
  servicePackage,
  serviceRepair,
  order,
} = require("./routes");
const bodyParser = require("body-parser");
const upload = require("./middleware/fileUpload");
const app = express();
const port = process.env.PORT || 3004;
app.use(cors());

//create a middleware for each route
const jsonParser = express.json();
app.use(bodyParser.urlencoded({ extended: false }));

app.use("/admin", jsonParser, admin);
app.use("/product", upload, product);
app.use("/shopOffer", upload, shopOffer);
app.use("/shop", jsonParser, shop);
app.use("/merchant", jsonParser, merchant);
app.use("/order", jsonParser, order);
app.use("/service", jsonParser, service);
app.use("/servicePackage", jsonParser, servicePackage);
app.use("/serviceRepair", jsonParser, serviceRepair);

app.get("/", (req, res) => {
  res.send({ path: 404 });
});

//create error 404 error
app.use((req, res, next) => {
  next(createError(404));
});

app.use((err, req, res, next) => {
  res.status(err.status || 500);
  res.send(JSON.stringify(err));
});
app.listen(port);
