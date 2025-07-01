const express = require('express');
const cors = require('cors'); // We'll need to install this package
const app = express();
const port = 80; // Your backend will listen on port 80

// Enable CORS for all requests - essential for FE-BE communication
app.use(cors());

// This is now your main API endpoint.
// The frontend will call this to get a message.
app.get('/api/hello', (req, res) => {
    res.json({ message: 'Hello from the Node.js Backend API!' });
});

// You can add more API endpoints here later, e.g., for menu items, orders etc.
// Example:
// app.get('/api/menu', (req, res) => {
//   const menuItems = [{ name: 'Coffee', price: 3.50 }];
//   res.json(menuItems);
// });


app.listen(port, '0.0.0.0', () => {
    console.log(`Backend Server running at http://0.0.0.0:${port}`);
});

// backend service is accessible from any machine on the internet .so that whoeber runs this app in their system do not need to update the IP here.