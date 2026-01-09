const WebSocket = require('ws');
const winston = require('winston');

const BINANCE_WS_URL = 'wss://stream.binance.com:9443/ws/btcusdt@trade';
const MAX_RETRIES = 5;
const HEARTBEAT_INTERVAL = 30000;
const MAX_TRADES = 100;

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.Console({ format: winston.format.simple() }),
    ],
});

let ws;
let latestTrades = [];
let retryCount = 0;
let heartbeatInterval;

function connect() {
    ws = new WebSocket(BINANCE_WS_URL);

    ws.on('open', () => {
        logger.info('WebSocket connected to Binance.');
        retryCount = 0;
        startHeartbeat();
    });

    ws.on('message', (data) => {
        try {
            const trade = JSON.parse(data);
            processTrade(trade);
        } catch (error) {
            logger.error('Failed to parse message:', error);
        }
    });

    ws.on('close', () => {
        logger.warn('WebSocket disconnected.');
        stopHeartbeat();
        reconnect();
    });

    ws.on('error', (error) => {
        logger.error('WebSocket error:', error);
        ws.close();
    });
}

function processTrade(trade) {
    if (trade.p) {
        const tradeData = {
            price: parseFloat(trade.p),
            timestamp: new Date().getTime()
        };
        latestTrades.push(tradeData);
        if (latestTrades.length > MAX_TRADES) {
            latestTrades.shift();
        }
        logger.debug(`Trade stored: ${tradeData.price}`);
    }
}

function reconnect() {
    if (retryCount < MAX_RETRIES) {
        retryCount++;
        const backoffTime = Math.pow(2, retryCount) * 1000;
        logger.warn(`Attempting to reconnect in ${backoffTime / 1000}s... (Attempt ${retryCount}/${MAX_RETRIES})`);
        setTimeout(connect, backoffTime);
    } else {
        logger.error('Maximum reconnection attempts reached. Could not connect to Binance.');
    }
}

function startHeartbeat() {
    heartbeatInterval = setInterval(() => {
        if (ws.readyState === WebSocket.OPEN) {
            ws.ping();
            logger.debug('Heartbeat ping sent.');
        }
    }, HEARTBEAT_INTERVAL);
}

function stopHeartbeat() {
    clearInterval(heartbeatInterval);
}

function getLatestTrades(count = 10) {
    return latestTrades.slice(-count);
}

function getCurrentPrice() {
    return latestTrades.length > 0 ? latestTrades[latestTrades.length - 1].price : null;
}

module.exports = {
    connect,
    getLatestTrades,
    getCurrentPrice,
};
