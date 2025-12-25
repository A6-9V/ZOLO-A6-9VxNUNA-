"""
AI Risk Manager
Intelligent risk management using machine learning
"""
import logging
from typing import Dict, Optional, List
from datetime import datetime

logger = logging.getLogger(__name__)


class AIRiskManager:
    """
    AI-powered risk management
    Provides intelligent risk assessment and position sizing
    """
    
    def __init__(self, config: Optional[Dict] = None):
        """
        Initialize AI Risk Manager
        
        Args:
            config: Configuration dictionary
        """
        self.config = config or {}
        self.max_risk_per_trade = self.config.get('max_risk_per_trade', 1.0)  # 1% default
        self.max_portfolio_risk = self.config.get('max_portfolio_risk', 5.0)  # 5% default
        self.min_confidence = self.config.get('min_confidence', 0.6)  # Minimum confidence to trade
        self.active_positions = {}
        self.risk_history = []
    
    def assess_risk(self, symbol: str, action: str, confidence: float, 
                   account_balance: Optional[float] = None) -> Dict:
        """
        Assess risk for a trading signal
        
        Args:
            symbol: Trading symbol
            action: Trading action (BUY/SELL)
            confidence: Signal confidence (0-1)
            account_balance: Account balance (optional)
            
        Returns:
            Risk assessment dictionary:
            - risk_score: Risk score (0-1)
            - recommended_lot_size: Recommended position size
            - max_risk: Maximum risk percentage
            - stop_loss: Recommended stop loss
            - take_profit: Recommended take profit
            - risk_reasoning: Risk assessment reasoning
        """
        try:
            # Calculate risk score
            risk_score = self._calculate_risk_score(symbol, action, confidence)
            
            # Check if risk is acceptable
            if risk_score > 0.7:
                return {
                    'risk_score': risk_score,
                    'recommended_lot_size': 0.0,
                    'max_risk': 0.0,
                    'stop_loss': None,
                    'take_profit': None,
                    'risk_reasoning': 'Risk too high - trade not recommended',
                    'approved': False
                }
            
            # Calculate position size
            lot_size = self._calculate_position_size(symbol, action, confidence, risk_score, account_balance)
            
            # Calculate stop loss and take profit
            result = self._calculate_stop_loss_take_profit(symbol, action, confidence)
            if len(result) == 3:
                stop_loss, take_profit, risk_reward_ratio = result
            else:
                stop_loss, take_profit = result
                risk_reward_ratio = 2.5  # Default R:R ratio
            
            # Check portfolio risk
            portfolio_risk = self._check_portfolio_risk(symbol, lot_size)
            
            if portfolio_risk > self.max_portfolio_risk:
                # Adjust lot size to stay within portfolio risk limit
                lot_size = lot_size * (self.max_portfolio_risk / portfolio_risk)
                logger.warning(f"Adjusted lot size for {symbol} due to portfolio risk limit")
            
            return {
                'risk_score': risk_score,
                'recommended_lot_size': lot_size,
                'max_risk': self.max_risk_per_trade,
                'stop_loss': stop_loss,
                'take_profit': take_profit,
                'risk_reward_ratio': risk_reward_ratio if 'risk_reward_ratio' in locals() else 2.5,
                'portfolio_risk': portfolio_risk,
                'risk_reasoning': f'Risk assessment: score={risk_score:.2f}, confidence={confidence:.2f}, R:R={risk_reward_ratio if "risk_reward_ratio" in locals() else 2.5:.1f}',
                'approved': risk_score <= 0.7 and confidence >= self.min_confidence
            }
            
        except Exception as e:
            logger.error(f"Error in risk assessment: {e}")
            return {
                'risk_score': 1.0,
                'recommended_lot_size': 0.0,
                'max_risk': 0.0,
                'stop_loss': None,
                'take_profit': None,
                'risk_reasoning': f'Risk assessment error: {str(e)}',
                'approved': False
            }
    
    def _calculate_risk_score(self, symbol: str, action: str, confidence: float) -> float:
        """
        Calculate risk score for a trade
        
        Args:
            symbol: Trading symbol
            action: Trading action
            confidence: Signal confidence
            
        Returns:
            Risk score (0-1), higher = more risky
        """
        # Base risk score
        risk_score = 0.5
        
        # Adjust based on confidence (lower confidence = higher risk)
        risk_score += (1.0 - confidence) * 0.3
        
        # Check for existing positions in same symbol
        if symbol in self.active_positions:
            risk_score += 0.2  # Additional risk for multiple positions
        
        # Check correlation with existing positions
        correlation_risk = self._check_correlation_risk(symbol)
        risk_score += correlation_risk * 0.2
        
        return min(max(risk_score, 0.0), 1.0)
    
    def _calculate_position_size(self, symbol: str, action: str, confidence: float,
                               risk_score: float, account_balance: Optional[float]) -> float:
        """
        Calculate recommended position size
        
        Args:
            symbol: Trading symbol
            action: Trading action
            confidence: Signal confidence
            risk_score: Risk score
            account_balance: Account balance
            
        Returns:
            Recommended lot size
        """
        # Base lot size
        base_lot_size = 0.01
        
        if account_balance:
            # Calculate lot size based on account balance and risk
            risk_amount = account_balance * (self.max_risk_per_trade / 100)
            # Simplified calculation (would need pip value, etc. for accurate calculation)
            lot_size = risk_amount / 1000  # Simplified
            lot_size = max(lot_size, 0.01)  # Minimum lot size
            lot_size = min(lot_size, 10.0)  # Maximum lot size
        else:
            lot_size = base_lot_size
        
        # Adjust based on confidence
        lot_size = lot_size * confidence
        
        # Adjust based on risk score (lower risk = can trade larger)
        lot_size = lot_size * (1.0 - risk_score * 0.5)
        
        # Round to 2 decimal places
        lot_size = round(lot_size, 2)
        
        return max(lot_size, 0.01)  # Ensure minimum lot size
    
    def _calculate_stop_loss_take_profit(self, symbol: str, action: str, confidence: float) -> tuple:
        """
        Calculate stop loss and take profit levels
        
        Args:
            symbol: Trading symbol
            action: Trading action
            confidence: Signal confidence
            
        Returns:
            Tuple of (stop_loss, take_profit, risk_reward_ratio)
            Note: stop_loss and take_profit are None - they should be calculated
            at execution time based on entry price. risk_reward_ratio is provided
            for the EA to calculate TP from SL.
        """
        # Default risk/reward ratios based on confidence
        # Higher confidence = better risk/reward ratio
        if confidence > 0.8:
            risk_reward_ratio = 3.0  # 1:3 ratio
        elif confidence > 0.6:
            risk_reward_ratio = 2.5  # 1:2.5 ratio
        else:
            risk_reward_ratio = 2.0  # 1:2 ratio
        
        # Return None for SL/TP prices - they will be calculated at execution time
        # The risk_reward_ratio will be used by the EA to calculate TP from SL
        # This is because we need the entry price to calculate absolute SL/TP prices
        stop_loss = None  # Will be calculated at execution time based on entry price
        take_profit = None  # Will be calculated at execution time: TP = Entry ± (SL_distance * R:R)
        
        return stop_loss, take_profit, risk_reward_ratio
    
    def _check_portfolio_risk(self, symbol: str, lot_size: float) -> float:
        """
        Check total portfolio risk
        
        Args:
            symbol: Trading symbol
            lot_size: Position size
            
        Returns:
            Total portfolio risk percentage
        """
        # Calculate current portfolio risk
        current_risk = sum([pos.get('risk', 0.0) for pos in self.active_positions.values()])
        
        # Add new position risk
        new_position_risk = self.max_risk_per_trade  # Simplified
        total_risk = current_risk + new_position_risk
        
        return total_risk
    
    def _check_correlation_risk(self, symbol: str) -> float:
        """
        Check correlation risk with existing positions
        
        Args:
            symbol: Trading symbol
            
        Returns:
            Correlation risk score (0-1)
        """
        # TODO: Implement correlation analysis
        # Check if symbol is highly correlated with existing positions
        # Higher correlation = higher risk
        
        # Placeholder
        return 0.0
    
    def add_position(self, symbol: str, position_data: Dict):
        """
        Add active position for risk tracking
        
        Args:
            symbol: Trading symbol
            position_data: Position information
        """
        self.active_positions[symbol] = {
            'symbol': symbol,
            'timestamp': datetime.now().isoformat(),
            'risk': position_data.get('risk', 0.0),
            'lot_size': position_data.get('lot_size', 0.0),
            **position_data
        }
    
    def remove_position(self, symbol: str):
        """
        Remove position from tracking
        
        Args:
            symbol: Trading symbol
        """
        if symbol in self.active_positions:
            del self.active_positions[symbol]
    
    def get_portfolio_risk(self) -> Dict:
        """
        Get current portfolio risk status
        
        Returns:
            Portfolio risk information
        """
        total_risk = sum([pos.get('risk', 0.0) for pos in self.active_positions.values()])
        position_count = len(self.active_positions)
        
        return {
            'total_risk': total_risk,
            'max_allowed_risk': self.max_portfolio_risk,
            'position_count': position_count,
            'risk_percentage': (total_risk / self.max_portfolio_risk * 100) if self.max_portfolio_risk > 0 else 0,
            'positions': list(self.active_positions.keys())
        }




























