const express = require("express");
const MongoClient = require("mongodb").MongoClient;
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
const cors = require("cors");

const User = require("./models/user_model");
const { register, login } = require("./controllers/userController");
const uploadRoutes = require("./controllers/uploadController");

// Set up express app
const app = express();
const port = process.env.PORT || 5000;

dotenv.config();

const mongoUrl = process.env.MONGODB_URL;

const client = new MongoClient(mongoUrl);

mongoose
  .connect(mongoUrl)
  .then(() => console.log("CONNECTED TO MONGODB"))
  .catch((err) => console.log("MONGODB CONNECTION ERROR: ", err));

// Middlewares
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

const db = client.db("test");
const usersCollection = db.collection("users");
const fileCollection = db.collection("files");

app.post("/register", (req, res) => register(req, res, usersCollection));
app.post("/login", (req, res) => login(req, res, usersCollection));

// upload routes
app.use("/", uploadRoutes);

// Route to check server status
app.get("/", (req, res) => {
  res.send("Hello World");
});

// Start the server
app.listen(port, () => {
  console.log(`Server listening on http://localhost:${port}`);
});
