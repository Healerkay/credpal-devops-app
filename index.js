const express = require("express");

const app = express();
app.use(express.json());

// GET /health
app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});

app.get("/status", (req, res) => {
  res.status(200).json({
    service: "credpal-devops-app",
    version: "v2-from-ci-cd",
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// POST /process
app.post("/process", (req, res) => {
  res.status(200).json({
    message: "Request processed successfully",
    data: req.body
  });
});

// App must run on port 3000
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
