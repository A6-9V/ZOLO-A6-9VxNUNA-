#!/usr/bin/env python3
"""
Jules API Keys Manager
Provides programmatic access to Jules API keys from environment variables
or GitHub secrets in GitHub Actions workflows.
"""

import os
import sys
from typing import List, Optional, Dict


class JulesAPIKeyManager:
    """Manager for accessing Jules API keys from environment variables."""
    
    def __init__(self, prefix: str = "JULES_API_KEY_"):
        """
        Initialize the Jules API Key Manager.
        
        Args:
            prefix: Prefix for environment variables containing API keys
        """
        self.prefix = prefix
        self._keys_cache: Optional[List[str]] = None
    
    def get_key(self, key_number: int) -> Optional[str]:
        """
        Get a specific Jules API key by number.
        
        Args:
            key_number: Key number (1-12)
            
        Returns:
            API key string or None if not found
        """
        if key_number < 1 or key_number > 12:
            raise ValueError("Key number must be between 1 and 12")
        
        env_var = f"{self.prefix}{key_number}"
        return os.getenv(env_var)
    
    def get_all_keys(self) -> List[str]:
        """
        Get all available Jules API keys.
        
        Returns:
            List of API key strings
        """
        if self._keys_cache is not None:
            return self._keys_cache
        
        # Try to get combined key first (comma-separated)
        combined = os.getenv("JULES_API_KEYS_ALL")
        if combined:
            self._keys_cache = [key.strip() for key in combined.split(",")]
            return self._keys_cache
        
        # Otherwise, collect individual keys
        keys = []
        for i in range(1, 13):
            key = self.get_key(i)
            if key:
                keys.append(key)
        
        self._keys_cache = keys
        return keys
    
    def get_available_keys_count(self) -> int:
        """
        Get the count of available API keys.
        
        Returns:
            Number of available keys
        """
        return len(self.get_all_keys())
    
    def get_keys_dict(self) -> Dict[int, str]:
        """
        Get all keys as a dictionary with key numbers.
        
        Returns:
            Dictionary mapping key numbers to API key strings
        """
        result = {}
        for i in range(1, 13):
            key = self.get_key(i)
            if key:
                result[i] = key
        return result
    
    def is_key_available(self, key_number: int) -> bool:
        """
        Check if a specific key is available.
        
        Args:
            key_number: Key number to check
            
        Returns:
            True if key is available, False otherwise
        """
        try:
            return self.get_key(key_number) is not None
        except ValueError:
            return False
    
    def mask_key(self, key: str, visible_chars: int = 10) -> str:
        """
        Mask an API key for safe logging.
        
        Args:
            key: API key to mask
            visible_chars: Number of characters to show at the start
            
        Returns:
            Masked key string
        """
        if not key or len(key) <= visible_chars:
            return "***"
        return f"{key[:visible_chars]}...***"
    
    def validate_key_format(self, key: str) -> bool:
        """
        Validate Jules API key format.
        
        Args:
            key: API key to validate
            
        Returns:
            True if format is valid, False otherwise
        """
        # Jules API keys appear to follow pattern: AQ.Ab8RN6{random_chars}
        if not key:
            return False
        
        if not key.startswith("AQ."):
            return False
        
        # Should be at least 30 characters
        if len(key) < 30:
            return False
        
        return True


def main():
    """Example usage and CLI interface."""
    manager = JulesAPIKeyManager()
    
    print("=" * 70)
    print("Jules API Keys Manager")
    print("=" * 70)
    print()
    
    # Check if any keys are available
    available_count = manager.get_available_keys_count()
    
    if available_count == 0:
        print("❌ No Jules API keys found in environment variables.")
        print()
        print("To use this script, ensure one of the following:")
        print("  1. Running in GitHub Actions with secrets configured")
        print("  2. Environment variables JULES_API_KEY_1 through JULES_API_KEY_12 are set")
        print("  3. Environment variable JULES_API_KEYS_ALL is set (comma-separated)")
        print()
        sys.exit(1)
    
    print(f"✓ Found {available_count} Jules API key(s)")
    print()
    
    # List available keys (masked)
    print("Available Keys:")
    print("-" * 70)
    
    keys_dict = manager.get_keys_dict()
    for key_num, key_value in keys_dict.items():
        masked = manager.mask_key(key_value)
        is_valid = manager.validate_key_format(key_value)
        status = "✓ Valid" if is_valid else "⚠ Invalid format"
        print(f"  Key {key_num:2d}: {masked} [{status}]")
    
    print()
    print("=" * 70)
    print()
    
    # Example: Get first available key
    if manager.is_key_available(1):
        key1 = manager.get_key(1)
        print("Example - Get first key:")
        print(f"  manager.get_key(1) = {manager.mask_key(key1)}")
        print()
    
    # Example: Get all keys
    all_keys = manager.get_all_keys()
    print(f"Example - Get all keys:")
    print(f"  manager.get_all_keys() = List of {len(all_keys)} key(s)")
    print()


# Example usage patterns
def example_usage():
    """
    Example code showing how to use the JulesAPIKeyManager.
    """
    # Create manager instance
    manager = JulesAPIKeyManager()
    
    # Get a specific key
    api_key = manager.get_key(1)
    if api_key:
        # Use the API key
        print(f"Using API key: {manager.mask_key(api_key)}")
    
    # Get all keys and round-robin through them
    all_keys = manager.get_all_keys()
    for i, key in enumerate(all_keys, 1):
        if manager.validate_key_format(key):
            print(f"Key {i} is valid: {manager.mask_key(key)}")
    
    # Check if a specific key is available
    if manager.is_key_available(5):
        print("Key 5 is available")
    
    # Get keys as dictionary
    keys_dict = manager.get_keys_dict()
    print(f"Available keys: {list(keys_dict.keys())}")


if __name__ == "__main__":
    main()
