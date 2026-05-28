const express = require("express");
const path = require("path");

const app = express();

app.use(express.static(path.join(__dirname, "../public")));

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "UP",
    service: "nodejs-static-website-k8s",
    timestamp: new Date().toISOString()
  });
});

app.get("/api/info", (req, res) => {
  res.status(200).json({
    app: "Static Website using Node.js",
    environment: process.env.NODE_ENV || "development",
    version: process.env.APP_VERSION || "1.0.0",
    deployedOn: "Kubernetes",
    provisionedBy: "Terraform"
  });
});

module.exports = app;