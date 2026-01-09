const express = require('express');
const winston = require('winston');
const livePriceRouter = require('./src/api/live-price');
const binanceWebsocket = require('./src/services/binanceWebsocket');

const app = express();
const port = 3000;

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.Console({ format: winston.format.simple() }),
    ],
});

// Middleware
app.use(express.json());

// API Routes
app.use('/api', livePriceRouter);

// Start the WebSocket service
binanceWebsocket.connect();

// Start the server
app.listen(port, () => {
    logger.info(`Server is running on http://localhost:${port}`);
});

module.exports = app;
