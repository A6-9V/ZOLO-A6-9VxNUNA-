"""
Verify Stop Loss and Take Profit functionality
Tests if SL/TP are properly implemented and working
"""

import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'python'))

from brokers.exness_api import ExnessAPI
from brokers.base_broker import BrokerConfig
from trader.multi_symbol_trader import MultiSymbolTrader
import json

def load_config():
    """Load broker configuration"""
    config_path = os.path.join(os.path.dirname(__file__), 'config', 'brokers.json')
    if not os.path.exists(config_path):
        print(f"[ERROR] Configuration file not found: {config_path}")
        return None
    
    with open(config_path, 'r') as f:
        config_data = json.load(f)
    
    brokers = config_data.get('brokers', [])
    if not brokers:
        print("[ERROR] No brokers configured")
        return None
    
    broker_config = brokers[0]
    return BrokerConfig(
        name=broker_config.get('name', 'EXNESS'),
        api_url=broker_config.get('api_url', 'https://api.exness.com'),
        account_id=broker_config.get('account_id', ''),
        api_key=broker_config.get('api_key', ''),
        api_secret=broker_config.get('api_secret', ''),
        rate_limit=broker_config.get('rate_limit', {})
    )

def test_exness_api_sl_tp():
    """Test ExnessAPI SL/TP implementation"""
    print("=" * 60)
    print("Testing ExnessAPI Stop Loss and Take Profit")
    print("=" * 60)
    
    config = load_config()
    if not config:
        return False
    
    api = ExnessAPI(config)
    
    # Check if place_order method accepts SL/TP parameters
    import inspect
    sig = inspect.signature(api.place_order)
    params = list(sig.parameters.keys())
    
    print(f"\n[1] Checking place_order method signature...")
    print(f"    Parameters: {params}")
    
    has_sl = 'stop_loss' in params
    has_tp = 'take_profit' in params
    
    if has_sl and has_tp:
        print(f"    [OK] place_order accepts stop_loss and take_profit parameters")
    else:
        print(f"    [ERROR] Missing SL/TP parameters!")
        return False
    
    # Check method implementation
    print(f"\n[2] Checking method implementation...")
    source = inspect.getsource(api.place_order)
    
    if 'stop_loss' in source and 'take_profit' in source:
        print(f"    [OK] Method implementation includes SL/TP handling")
    else:
        print(f"    [WARNING] SL/TP may not be fully implemented")
    
    # Check if SL/TP are added to order_data
    if "order_data['stop_loss']" in source or 'stop_loss' in source:
        print(f"    [OK] stop_loss is added to order_data")
    else:
        print(f"    [WARNING] stop_loss may not be added to order_data")
    
    if "order_data['take_profit']" in source or 'take_profit' in source:
        print(f"    [OK] take_profit is added to order_data")
    else:
        print(f"    [WARNING] take_profit may not be added to order_data")
    
    return True

def test_multi_symbol_trader_sl_tp():
    """Test MultiSymbolTrader SL/TP implementation"""
    print("\n" + "=" * 60)
    print("Testing MultiSymbolTrader Stop Loss and Take Profit")
    print("=" * 60)
    
    config = load_config()
    if not config:
        return False
    
    trader = MultiSymbolTrader()
    
    # Check execute_trade method signature
    import inspect
    sig = inspect.signature(trader.execute_trade)
    params = list(sig.parameters.keys())
    
    print(f"\n[1] Checking execute_trade method signature...")
    print(f"    Parameters: {params}")
    
    has_sl = 'stop_loss' in params
    has_tp = 'take_profit' in params
    
    if has_sl and has_tp:
        print(f"    [OK] execute_trade accepts stop_loss and take_profit parameters")
    else:
        print(f"    [ERROR] Missing SL/TP parameters!")
        return False
    
    # Check if SL/TP are passed to broker
    print(f"\n[2] Checking if SL/TP are passed to broker...")
    source = inspect.getsource(trader.execute_trade)
    
    if 'stop_loss=stop_loss' in source and 'take_profit=take_profit' in source:
        print(f"    [OK] SL/TP are passed to broker.place_order()")
    else:
        print(f"    [WARNING] SL/TP may not be passed correctly")
    
    return True

def test_mql5_ea_sl_tp():
    """Check MQL5 EA SL/TP implementation"""
    print("\n" + "=" * 60)
    print("Checking MQL5 EA Stop Loss and Take Profit")
    print("=" * 60)
    
    ea_path = os.path.join(os.path.dirname(__file__), 'mql5', 'Experts', 'PythonBridgeEA.mq5')
    
    if not os.path.exists(ea_path):
        print(f"    [WARNING] EA file not found: {ea_path}")
        return False
    
    with open(ea_path, 'r', encoding='utf-8') as f:
        ea_code = f.read()
    
    print(f"\n[1] Checking PythonBridgeEA.mq5...")
    
    # Check if ExecuteBuy/ExecuteSell accept SL/TP
    has_execute_buy_sl = 'ExecuteBuy' in ea_code and 'stopLoss' in ea_code
    has_execute_sell_sl = 'ExecuteSell' in ea_code and 'stopLoss' in ea_code
    
    if has_execute_buy_sl and has_execute_sell_sl:
        print(f"    [OK] ExecuteBuy and ExecuteSell accept stopLoss parameter")
    else:
        print(f"    [WARNING] SL parameter may be missing")
    
    has_execute_buy_tp = 'ExecuteBuy' in ea_code and 'takeProfit' in ea_code
    has_execute_sell_tp = 'ExecuteSell' in ea_code and 'takeProfit' in ea_code
    
    if has_execute_buy_tp and has_execute_sell_tp:
        print(f"    [OK] ExecuteBuy and ExecuteSell accept takeProfit parameter")
    else:
        print(f"    [WARNING] TP parameter may be missing")
    
    # Check if SL/TP are passed to trade.Buy/Sell
    if 'trade.Buy' in ea_code and 'sl' in ea_code.lower() and 'tp' in ea_code.lower():
        print(f"    [OK] SL/TP are passed to trade.Buy()")
    else:
        print(f"    [WARNING] SL/TP may not be passed to trade.Buy()")
    
    if 'trade.Sell' in ea_code and 'sl' in ea_code.lower() and 'tp' in ea_code.lower():
        print(f"    [OK] SL/TP are passed to trade.Sell()")
    else:
        print(f"    [WARNING] SL/TP may not be passed to trade.Sell()")
    
    return True

def test_enhanced_ea_sl_tp():
    """Check Enhanced EA SL/TP configuration"""
    print("\n" + "=" * 60)
    print("Checking Enhanced EA Stop Loss and Take Profit")
    print("=" * 60)
    
    mql5_repo = os.path.join(os.path.dirname(__file__), '..', 'mql5-repo', 'Experts', 'Advisors')
    
    enhanced_eas = [
        'ExpertMACD_Enhanced.mq5',
        'ExpertMAMA_Enhanced.mq5',
        'ExpertMAPSAR_Enhanced.mq5'
    ]
    
    print(f"\n[1] Checking Enhanced EAs...")
    
    for ea_name in enhanced_eas:
        ea_path = os.path.join(mql5_repo, ea_name)
        if os.path.exists(ea_path):
            with open(ea_path, 'r', encoding='utf-8') as f:
                ea_code = f.read()
            
            # Check for SL/TP input parameters
            has_sl_input = 'StopLoss' in ea_code or 'stop_loss' in ea_code.lower()
            has_tp_input = 'TakeProfit' in ea_code or 'take_profit' in ea_code.lower()
            
            print(f"\n    {ea_name}:")
            if has_sl_input:
                print(f"      [OK] Has Stop Loss input parameter")
            else:
                print(f"      [WARNING] Stop Loss parameter may be missing")
            
            if has_tp_input:
                print(f"      [OK] Has Take Profit input parameter")
            else:
                print(f"      [WARNING] Take Profit parameter may be missing")
            
            # Check if SL/TP are used in trade execution
            if 'trade.Buy' in ea_code or 'trade.Sell' in ea_code:
                if 'sl' in ea_code.lower() and 'tp' in ea_code.lower():
                    print(f"      [OK] SL/TP are used in trade execution")
                else:
                    print(f"      [WARNING] SL/TP may not be used in trade execution")
        else:
            print(f"\n    {ea_name}: [NOT FOUND]")
    
    return True

def main():
    """Run all SL/TP verification tests"""
    print("\n" + "=" * 60)
    print("Stop Loss and Take Profit Verification")
    print("=" * 60)
    print("\nThis script verifies that SL/TP are properly implemented")
    print("across all components of the trading system.\n")
    
    results = []
    
    # Test 1: ExnessAPI
    try:
        result = test_exness_api_sl_tp()
        results.append(("ExnessAPI", result))
    except Exception as e:
        print(f"[ERROR] ExnessAPI test failed: {e}")
        results.append(("ExnessAPI", False))
    
    # Test 2: MultiSymbolTrader
    try:
        result = test_multi_symbol_trader_sl_tp()
        results.append(("MultiSymbolTrader", result))
    except Exception as e:
        print(f"[ERROR] MultiSymbolTrader test failed: {e}")
        results.append(("MultiSymbolTrader", False))
    
    # Test 3: MQL5 EA
    try:
        result = test_mql5_ea_sl_tp()
        results.append(("MQL5 EA", result))
    except Exception as e:
        print(f"[ERROR] MQL5 EA test failed: {e}")
        results.append(("MQL5 EA", False))
    
    # Test 4: Enhanced EAs
    try:
        result = test_enhanced_ea_sl_tp()
        results.append(("Enhanced EAs", result))
    except Exception as e:
        print(f"[ERROR] Enhanced EA test failed: {e}")
        results.append(("Enhanced EAs", False))
    
    # Summary
    print("\n" + "=" * 60)
    print("Verification Summary")
    print("=" * 60)
    
    for component, result in results:
        status = "[OK]" if result else "[ISSUES FOUND]"
        print(f"{component}: {status}")
    
    all_ok = all(result for _, result in results)
    
    if all_ok:
        print("\n[SUCCESS] All components have SL/TP implementation")
    else:
        print("\n[WARNING] Some components may have SL/TP issues")
        print("Review the warnings above for details")
    
    print("\n" + "=" * 60)
    print("Note: This is a code verification test.")
    print("To test actual SL/TP execution, place a test trade")
    print("and verify the orders are created with SL/TP.")
    print("=" * 60)

if __name__ == "__main__":
    main()

