//+------------------------------------------------------------------+
//| EXNESS GenX Trading - Configuration                              |
//| Version 2.0 - Full Strategy Parameters                           |
//+------------------------------------------------------------------+
#ifndef EXNESS_GENX_CONFIG_MQH
#define EXNESS_GENX_CONFIG_MQH

//=== GENERAL SETTINGS ================================================
input string CFG_SECTION_1        = "═══ GENERAL ═══";              // ─────────────────
input bool   CFG_Enable_Trading   = true;                           // Enable Trading
input bool   CFG_Enable_Logging   = true;                           // Enable Logging
input int    CFG_Magic_Number     = 81001;                          // Magic Number (unique ID)
input string CFG_Trade_Comment    = "GenX_v2";                      // Trade Comment

//=== SYMBOLS =========================================================
input string CFG_SECTION_2        = "═══ SYMBOLS ═══";              // ─────────────────
input string CFG_Symbol_1         = "EURUSD";                       // Symbol 1
input string CFG_Symbol_2         = "XAUUSD";                       // Symbol 2
input string CFG_Symbol_3         = "ETFXAU";                       // Symbol 3
input string CFG_Symbol_4         = "BTCUSD";                       // Symbol 4

//=== MONEY MANAGEMENT ================================================
input string CFG_SECTION_3        = "═══ RISK MANAGEMENT ═══";      // ─────────────────
input double CFG_Risk_Percent     = 1.0;                            // Risk % per trade (1-5 recommended)
input double CFG_Fixed_Lot        = 0.01;                           // Fixed lot (if risk calc fails)
input double CFG_Max_Lot          = 5.0;                            // Maximum lot size
input double CFG_Min_Lot          = 0.01;                           // Minimum lot size
input int    CFG_Max_Positions    = 3;                              // Max open positions
input int    CFG_Max_Daily_Trades = 10;                             // Max trades per day

//=== STOP LOSS & TAKE PROFIT =========================================
input string CFG_SECTION_4        = "═══ SL / TP ═══";              // ─────────────────
input bool   CFG_Use_ATR_SL       = true;                           // Use ATR for SL/TP
input double CFG_ATR_SL_Multi     = 1.5;                            // ATR multiplier for SL
input double CFG_ATR_TP_Multi     = 2.5;                            // ATR multiplier for TP
input int    CFG_Fixed_SL_Pips    = 50;                             // Fixed SL in pips (if ATR disabled)
input int    CFG_Fixed_TP_Pips    = 100;                            // Fixed TP in pips (if ATR disabled)

//=== TRAILING STOP ===================================================
input string CFG_SECTION_5        = "═══ TRAILING STOP ═══";        // ─────────────────
input bool   CFG_Use_Trailing     = true;                           // Enable Trailing Stop
input int    CFG_Trail_Start_Pips = 30;                             // Start trailing after X pips profit
input int    CFG_Trail_Step_Pips  = 10;                             // Trail step in pips
input bool   CFG_Use_BreakEven    = true;                           // Enable Break-Even
input int    CFG_BE_Trigger_Pips  = 20;                             // Move to BE after X pips profit
input int    CFG_BE_Plus_Pips     = 5;                              // Lock in X pips at BE

//=== STRATEGY: MOVING AVERAGES =======================================
input string CFG_SECTION_6        = "═══ MA STRATEGY ═══";          // ─────────────────
input bool   CFG_Use_MA_Strategy  = true;                           // Enable MA Crossover
input int    CFG_MA_Fast_Period   = 10;                             // Fast MA Period
input int    CFG_MA_Slow_Period   = 30;                             // Slow MA Period
input ENUM_MA_METHOD CFG_MA_Method = MODE_EMA;                      // MA Method (SMA/EMA)
input ENUM_APPLIED_PRICE CFG_MA_Price = PRICE_CLOSE;                // MA Applied Price

//=== STRATEGY: RSI FILTER ============================================
input string CFG_SECTION_7        = "═══ RSI FILTER ═══";           // ─────────────────
input bool   CFG_Use_RSI_Filter   = true;                           // Enable RSI Filter
input int    CFG_RSI_Period       = 14;                             // RSI Period
input int    CFG_RSI_Overbought   = 70;                             // RSI Overbought Level
input int    CFG_RSI_Oversold     = 30;                             // RSI Oversold Level

//=== STRATEGY: ATR VOLATILITY ========================================
input string CFG_SECTION_8        = "═══ ATR SETTINGS ═══";         // ─────────────────
input int    CFG_ATR_Period       = 14;                             // ATR Period
input double CFG_Min_ATR          = 0.0005;                         // Minimum ATR to trade

//=== TIME FILTER =====================================================
input string CFG_SECTION_9        = "═══ TIME FILTER ═══";          // ─────────────────
input bool   CFG_Use_Time_Filter  = false;                          // Enable Time Filter
input int    CFG_Trade_Start_Hour = 8;                              // Trading Start Hour (server time)
input int    CFG_Trade_End_Hour   = 20;                             // Trading End Hour (server time)
input bool   CFG_Avoid_Friday_PM  = true;                           // Avoid Friday afternoon trading

//=== NEWS FILTER =====================================================
input string CFG_SECTION_10       = "═══ NEWS FILTER ═══";          // ─────────────────
input bool   CFG_Avoid_News       = false;                          // Pause before/after high-impact news
input int    CFG_News_Pause_Mins  = 30;                             // Minutes to pause around news

//+------------------------------------------------------------------+
#endif // EXNESS_GENX_CONFIG_MQH
//+------------------------------------------------------------------+
