const { User, validate } = require("../model/user_model");
const bcrypt = require("bcrypt");
const _ = require("lodash");

const express = require("express");
const router = express.Router();

router.post("/", async (req, res) => {
  // First Validate The Request
  const { error } = validate(req.body);
  if (error) {
    return res.status(400).send(error.details[0].message);
  }

  User.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.send(user);
});

module.exports = router;
