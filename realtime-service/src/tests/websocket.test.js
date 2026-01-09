// Mock the 'ws' module and use fake timers
jest.mock('ws');
jest.useFakeTimers();

const WebSocket = require('ws');

describe('Binance WebSocket Service', () => {

  // This helper function sets up a clean environment for each test
  const setupTest = () => {
    jest.resetModules();

    const eventHandlers = {};
    const mockSocket = {
      on: jest.fn((event, handler) => {
        eventHandlers[event] = handler;
      }),
      close: jest.fn(),
      ping: jest.fn(),
      readyState: WebSocket.OPEN,
    };

    WebSocket.mockImplementation(() => mockSocket);

    const binanceWebsocket = require('../services/binanceWebsocket');

    return { binanceWebsocket, mockSocket, eventHandlers };
  };

  it('should connect and set up event listeners', () => {
    const { binanceWebsocket, mockSocket } = setupTest();
    binanceWebsocket.connect();

    expect(WebSocket).toHaveBeenCalledWith('wss://stream.binance.com:9443/ws/btcusdt@trade');
    expect(mockSocket.on).toHaveBeenCalledWith('open', expect.any(Function));
    expect(mockSocket.on).toHaveBeenCalledWith('message', expect.any(Function));
    expect(mockSocket.on).toHaveBeenCalledWith('close', expect.any(Function));
    expect(mockSocket.on).toHaveBeenCalledWith('error', expect.any(Function));
  });

  it('should process and store trades on message', () => {
    const { binanceWebsocket, eventHandlers } = setupTest();
    binanceWebsocket.connect();

    const trade = { p: '50000.00' };
    eventHandlers.message(JSON.stringify(trade));

    expect(binanceWebsocket.getCurrentPrice()).toBe(50000.00);
    expect(binanceWebsocket.getLatestTrades(1).length).toBe(1);
  });

  it('should attempt to reconnect on close', () => {
    const { binanceWebsocket, eventHandlers } = setupTest();
    binanceWebsocket.connect();

    eventHandlers.close();

    expect(setTimeout).toHaveBeenCalledWith(expect.any(Function), 2000);
    jest.runOnlyPendingTimers();
    expect(WebSocket).toHaveBeenCalledTimes(2);
  });

  it('should stop reconnecting after max retries', () => {
    const { binanceWebsocket, eventHandlers } = setupTest();
    binanceWebsocket.connect();

    for (let i = 0; i < 5; i++) {
        eventHandlers.close();
        jest.runOnlyPendingTimers();
    }
    expect(WebSocket).toHaveBeenCalledTimes(6);

    eventHandlers.close();
    jest.runOnlyPendingTimers();
    expect(WebSocket).toHaveBeenCalledTimes(6);
  });

  it('should send a heartbeat ping', () => {
    const { binanceWebsocket, mockSocket, eventHandlers } = setupTest();
    binanceWebsocket.connect();

    eventHandlers.open();
    expect(setInterval).toHaveBeenCalledWith(expect.any(Function), 30000);

    jest.advanceTimersByTime(30000);
    expect(mockSocket.ping).toHaveBeenCalledTimes(1);
  });
});
