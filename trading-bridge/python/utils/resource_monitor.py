"""
Resource Monitor for Trading System
Monitors CPU, memory, and adapts system behavior for low-spec machines
"""
import psutil
import logging
import time
from typing import Dict, Optional

logger = logging.getLogger(__name__)


class ResourceMonitor:
    """Monitor system resources and adapt behavior"""
    
    def __init__(
        self,
        cpu_warning_threshold: float = 70.0,
        cpu_critical_threshold: float = 85.0,
        memory_warning_threshold: float = 80.0,
        memory_critical_threshold: float = 90.0,
        check_interval: int = 30
    ):
        """
        Initialize resource monitor
        
        Args:
            cpu_warning_threshold: CPU usage % to trigger warning
            cpu_critical_threshold: CPU usage % to trigger critical mode
            memory_warning_threshold: Memory usage % to trigger warning
            memory_critical_threshold: Memory usage % to trigger critical mode
            check_interval: Seconds between checks
        """
        self.cpu_warning_threshold = cpu_warning_threshold
        self.cpu_critical_threshold = cpu_critical_threshold
        self.memory_warning_threshold = memory_warning_threshold
        self.memory_critical_threshold = memory_critical_threshold
        self.check_interval = check_interval
        
        self.last_check_time = 0
        self.cpu_percent = 0.0
        self.memory_percent = 0.0
        self.is_critical = False
        self.warning_count = 0
        
        # Adaptive sleep values
        self.base_sleep = 10  # Base sleep in seconds
        self.current_sleep = self.base_sleep
        
    def check_resources(self) -> Dict[str, any]:
        """
        Check system resources
        
        Returns:
            Dict with resource information
        """
        current_time = time.time()
        
        # Only check if enough time has passed
        if current_time - self.last_check_time < self.check_interval:
            return {
                'cpu_percent': self.cpu_percent,
                'memory_percent': self.memory_percent,
                'is_critical': self.is_critical,
                'sleep_interval': self.current_sleep
            }
        
        self.last_check_time = current_time
        
        # Get CPU usage (1 second interval for accuracy)
        self.cpu_percent = psutil.cpu_percent(interval=1)
        
        # Get memory usage
        memory = psutil.virtual_memory()
        self.memory_percent = memory.percent
        
        # Determine status
        was_critical = self.is_critical
        
        if (self.cpu_percent >= self.cpu_critical_threshold or 
            self.memory_percent >= self.memory_critical_threshold):
            self.is_critical = True
            self.warning_count += 1
            
            if not was_critical:
                logger.warning(
                    f"CRITICAL: System resources high - "
                    f"CPU: {self.cpu_percent:.1f}%, "
                    f"Memory: {self.memory_percent:.1f}%"
                )
            
            # Increase sleep interval to reduce load
            self.current_sleep = min(self.base_sleep * 3, 30)
            
        elif (self.cpu_percent >= self.cpu_warning_threshold or 
              self.memory_percent >= self.memory_warning_threshold):
            self.is_critical = False
            self.warning_count += 1
            
            if self.warning_count % 5 == 0:  # Log every 5 warnings
                logger.warning(
                    f"Warning: System resources elevated - "
                    f"CPU: {self.cpu_percent:.1f}%, "
                    f"Memory: {self.memory_percent:.1f}%"
                )
            
            # Moderately increase sleep interval
            self.current_sleep = min(self.base_sleep * 1.5, 15)
            
        else:
            # Resources normal
            if was_critical:
                logger.info("System resources returned to normal levels")
            
            self.is_critical = False
            self.current_sleep = self.base_sleep
        
        return {
            'cpu_percent': self.cpu_percent,
            'memory_percent': self.memory_percent,
            'is_critical': self.is_critical,
            'sleep_interval': self.current_sleep,
            'warning_count': self.warning_count
        }
    
    def get_adaptive_sleep(self) -> int:
        """
        Get adaptive sleep interval based on current resource usage
        
        Returns:
            Sleep interval in seconds
        """
        return int(self.current_sleep)
    
    def log_summary(self):
        """Log resource usage summary"""
        logger.info(
            f"Resource Summary - "
            f"CPU: {self.cpu_percent:.1f}%, "
            f"Memory: {self.memory_percent:.1f}%, "
            f"Adaptive Sleep: {self.current_sleep}s, "
            f"Status: {'CRITICAL' if self.is_critical else 'NORMAL'}"
        )
