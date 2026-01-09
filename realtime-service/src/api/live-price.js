const express = require('express');
const { getCurrentPrice, getLatestTrades } = require('../services/binanceWebsocket');

const router = express.Router();

router.get('/live-price', (req, res) => {
    const currentPrice = getCurrentPrice();
    const recentTrades = getLatestTrades(10);

    if (currentPrice === null) {
        return res.status(503).json({ error: 'No price data available yet.' });
    }

    res.json({
        price: currentPrice,
        recent: recentTrades,
    });
});

module.exports = router;
