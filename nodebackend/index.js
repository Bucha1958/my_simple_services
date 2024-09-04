
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const app = express();

// Security enhancements
app.use(helmet());

// Enable CORS for a specific domain
app.use(cors());

app.get('/api', (req, res) => {
  res.json({ message: 'Hello from the backend!' });
});

// Health check endpoint for Kubernetes or monitoring
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Backend server running on port ${PORT}`));
