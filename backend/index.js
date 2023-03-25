const Joi = require("joi");
Joi.objectId = require("joi-objectid")(Joi);
const mongoose = require("mongoose");
const users = require("./routes/user_route");
const auth = require("./routes/auth");
const update = require("./routes/update");
const express = require("express");
const app = express();
const { User, validate } = require("./model/user_model");

mongoose
  .connect("mongodb://127.0.0.1:27017/newApi")
  .then(() => console.log("Now connected to MongoDB!"))
  .catch((err) => console.error("Something went wrong", err));

app.use(express.json());
app.use("/api/auth", auth);
app.use("/api/users", users);

app.put("/api/:id", async (req, res) => {
  try {
    const myDocument = await User.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    res.send(myDocument);
  } catch (error) {
    console.error(error);
    res.status(500).send(error);
  }
});

const port = process.env.PORT || 4000;
app.listen(port, () => console.log(`Listening on port ${port}...`));
