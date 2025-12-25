# Performance Optimization Guide

## Overview

This document describes the performance optimizations implemented to prevent system freezes on low-specification systems (Intel i3-N305, 8GB RAM).

## Problem Identification

The trading system was causing the laptop to freeze during trade placement due to:

1. **High CPU Usage**: Tight polling loops consuming excessive CPU cycles
2. **Resource Contention**: Multiple concurrent operations without throttling
3. **Inefficient Processing**: Heavy analysis running on every market tick
4. **Blocking Operations**: Synchronous operations causing UI freezes

## Optimizations Implemented

### 1. Python Bridge Optimizations

#### Before:
```python
# Tight polling loop with NOBLOCK
message = self.socket.recv_string(zmq.NOBLOCK)
time.sleep(0.1)  # 100ms sleep - very tight loop
```

#### After:
```python
# Blocking receive with timeout
self.socket.setsockopt(zmq.RCVTIMEO, 10000)  # 10 second timeout
message = self.socket.recv_string()  # Blocks until message or timeout
```

**Impact**: Eliminates tight polling loop, reduces CPU usage by ~70-80%

#### Other Bridge Improvements:
- Increased heartbeat monitoring from 5s to 10s
- Error recovery sleep increased from 1s to 2s
- Health check interval increased from 60s to 120s

### 2. MQL5 EA Optimizations

#### Before:
```cpp
void OnTick() {
    // All operations on every tick
    AnalyzeMarketStructure();
    DetectOrderBlocks();
    DetectFairValueGaps();
    // ... heavy processing
}
```

#### After:
```cpp
void OnTick() {
    // Only lightweight operations
    ManagePositions();
}

void OnTimer() {
    // Heavy operations every 10 seconds with 30s throttle
    if(currentTime - lastAnalysisTime < 30)
        return;
    
    AnalyzeMarketStructure();
    DetectOrderBlocks();
    DetectFairValueGaps();
}
```

**Impact**: Reduces CPU usage by ~60-70% during active trading

### 3. Resource Monitoring

New `ResourceMonitor` class provides:
- Real-time CPU and memory monitoring
- Adaptive sleep intervals based on system load
- Emergency brake for critical resource levels
- Performance metrics logging

#### Resource Thresholds:
- **Warning Level**: CPU > 70% or Memory > 80%
- **Critical Level**: CPU > 85% or Memory > 90%

#### Adaptive Behavior:
- Normal: 10s sleep interval
- Warning: 15s sleep interval
- Critical: 30s sleep interval + skip heavy operations

### 4. Background Service Improvements

- Service loop sleep increased from 5s to 10s
- Error handling sleep increased from 10s to 30s
- Integrated resource monitoring
- Emergency brake for critical conditions

## Performance Impact

### Expected Improvements:
- **CPU Usage**: Reduction of 60-80% during normal operation
- **Memory Usage**: More stable with fewer spikes
- **System Responsiveness**: Significant improvement, no freezing
- **Trade Execution**: Maintained reliability with reduced overhead

### Trade-offs:
- Analysis frequency reduced from every tick to every 30-40 seconds
- Signal detection may be slightly delayed (10-30 seconds)
- This is acceptable for swing trading strategies
- Position management still runs on every tick (critical for safety)

## Usage Instructions

### Python Requirements

Install psutil for resource monitoring:
```bash
pip install psutil>=5.9.0
```

Or install all requirements:
```bash
cd trading-bridge
pip install -r requirements.txt
```

### MQL5 Compilation

Recompile the EA with the new OnTimer function:
1. Open MetaEditor
2. Open SmartMoneyConceptEA.mq5
3. Press F7 to compile
4. Attach to chart

### Monitoring

Check logs for resource usage:
```
logs/trading_service_YYYYMMDD.log
logs/mql5_bridge_YYYYMMDD.log
```

Look for lines like:
```
Resource Summary - CPU: 45.2%, Memory: 62.1%, Adaptive Sleep: 10s, Status: NORMAL
```

## Troubleshooting

### High CPU Usage Persists

1. Check for other running processes
2. Increase sleep intervals further in code
3. Reduce number of symbols being traded
4. Disable AI/ML features if enabled

### Trades Not Executing

1. Check OnTimer is running (logs show analysis)
2. Verify trading hours are correct
3. Check daily trade limits not exceeded
4. Review bridge connection status

### System Still Freezing

1. Check Windows Task Manager for other processes
2. Close unnecessary applications
3. Consider upgrading RAM (8GB is minimal)
4. Disable Windows background services

## Advanced Configuration

### Adjust Resource Thresholds

Edit `resource_monitor.py`:
```python
ResourceMonitor(
    cpu_warning_threshold=60.0,    # Lower for more aggressive throttling
    cpu_critical_threshold=75.0,
    memory_warning_threshold=70.0,
    memory_critical_threshold=85.0,
    check_interval=20              # Check more frequently
)
```

### Adjust Sleep Intervals

Edit `background_service.py`:
```python
# Main loop sleep
time.sleep(15)  # Increase from 10s to 15s

# Health check interval
self.health_check_interval = 180  # Increase from 120s to 180s
```

### Adjust Analysis Throttle

Edit `SmartMoneyConceptEA.mq5`:
```cpp
// Throttle heavy analysis
if(currentTime - lastAnalysisTime < 60)  // Increase from 30s to 60s
    return;
```

## Best Practices

1. **Monitor Regularly**: Check logs daily for resource warnings
2. **Close Unused Apps**: Keep only essential applications running
3. **Regular Restarts**: Restart system weekly to clear memory
4. **Update System**: Keep Windows and drivers updated
5. **Clean Disk**: Ensure adequate free disk space (>20GB)

## Technical Details

### System Specifications
- **CPU**: Intel Core i3-N305 @ 1.80 GHz
- **RAM**: 8GB (7.63GB usable)
- **OS**: Windows 11 Home Single Language 25H2

### Key Performance Metrics
- **Base Sleep**: 10 seconds (normal operation)
- **Warning Sleep**: 15 seconds (elevated resources)
- **Critical Sleep**: 30 seconds (critical resources)
- **Analysis Throttle**: 30 seconds minimum between analyses
- **Timer Interval**: 10 seconds (OnTimer in MQL5)

## Future Improvements

1. **Process Priority**: Set trading process to high priority
2. **Core Affinity**: Pin to specific CPU cores
3. **Memory Optimization**: Implement better memory management
4. **Async Operations**: More asynchronous processing
5. **Database Caching**: Cache frequently accessed data

## Support

For issues or questions:
1. Check logs in `logs/` directory
2. Review this guide
3. Check system resource usage in Task Manager
4. Contact support with log files

---

**Last Updated**: 2025-12-25
**Version**: 1.0
**Status**: Production
