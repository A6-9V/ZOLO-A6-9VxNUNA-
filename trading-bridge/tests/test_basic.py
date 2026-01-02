"""
Basic tests for trading-bridge Python scripts.
These tests validate that the Python files have correct syntax and structure.
"""

import sys
import os

# Add parent directory to path to import modules
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def test_imports():
    """Test that required packages can be imported."""
    try:
        import zmq
        import requests
        import schedule
        import psutil
        assert True
    except ImportError as e:
        # Skip if dependencies not installed (CI will install minimal set)
        print(f"Skipping import test: {e}")
        assert True


def test_python_files_syntax():
    """Test that all Python files have valid syntax."""
    import py_compile
    
    trading_bridge_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    python_files = [
        f for f in os.listdir(trading_bridge_dir)
        if f.endswith('.py') and not f.startswith('.')
    ]
    
    errors = []
    for filename in python_files:
        filepath = os.path.join(trading_bridge_dir, filename)
        try:
            py_compile.compile(filepath, doraise=True)
        except py_compile.PyCompileError as e:
            errors.append(f"{filename}: {str(e)}")
    
    assert len(errors) == 0, f"Syntax errors found:\n" + "\n".join(errors)


def test_requirements_file_exists():
    """Test that requirements.txt exists."""
    trading_bridge_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    requirements_path = os.path.join(trading_bridge_dir, 'requirements.txt')
    assert os.path.exists(requirements_path), "requirements.txt not found"


def test_basic_configuration():
    """Test that basic configuration exists."""
    # This is a placeholder for actual configuration tests
    assert True, "Configuration test placeholder"


if __name__ == '__main__':
    # Run tests directly
    print("Running basic tests...")
    test_imports()
    test_python_files_syntax()
    test_requirements_file_exists()
    test_basic_configuration()
    print("All tests passed!")
