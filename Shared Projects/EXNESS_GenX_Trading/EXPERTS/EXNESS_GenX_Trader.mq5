//+------------------------------------------------------------------+
//| EXNESS_GenX_Trader.mq5                                           |
//| EA: SMC (BOS/CHoCH) + Donchian breakout + MTF confirmation       |
//| Alerts / Push notifications + optional auto-trading              |
//+------------------------------------------------------------------+
#property strict
#property version   "2.01"

#include <Trade/Trade.mqh>

enum ENUM_SL_MODE
{
  SL_ATR = 0,          // ATR * multiplier
  SL_SWING = 1,        // last confirmed swing (fractal) + buffer
  SL_FIXED_POINTS = 2  // fixed points
};

enum ENUM_TP_MODE
{
  TP_RR = 0,               // RR * SL distance
  TP_FIXED_POINTS = 1,     // fixed points
  TP_DONCHIAN_WIDTH = 2    // Donchian channel width * multiplier
};

input group "Core"
input bool   EnableTrading         = false; // if false: alerts only
input long   MagicNumber           = 26012025;
input bool   OnePositionPerSymbol  = true;

input group "Main timeframe logic"
input ENUM_TIMEFRAMES SignalTF     = PERIOD_CURRENT;
input bool   FireOnClose           = true;  // use last closed bar on SignalTF

input group "SMC (structure)"
input bool   UseSMC                = true;
input bool   UseCHoCH              = true;

input group "Trend Breakout"
input bool   UseDonchianBreakout   = true;
input int    DonchianLookback      = 20;

input group "Lower timeframe confirmation"
input bool            RequireMTFConfirm = true;
input ENUM_TIMEFRAMES LowerTF           = PERIOD_M5;
input int             EMAFast           = 20;
input int             EMASlow           = 50;

input group "Risk / Orders"
input bool   AllowWeekendTrading   = true; // Allow trading on Sat/Sun (Crypto/Indices)
input ENUM_SL_MODE SLMode                = SL_ATR;
input ENUM_TP_MODE TPMode                = TP_RR;

input double FixedLots             = 0.10; // used when RiskPercent=0
input double RiskPercent           = 0.0;  // if >0: position size from SL distance
input bool   RiskUseEquity         = true; // recommended
input bool   RiskClampToFreeMargin = true; // reduce lots if not enough margin

input int    ATRPeriod             = 14;
input double ATR_SL_Mult           = 2.0;

input int    SwingSLBufferPoints   = 20;   // extra points beyond swing (SL_SWING)
input int    FixedSLPoints         = 500;  // SL_FIXED_POINTS

input double RR                    = 2.0;
input int    FixedTPPoints         = 1000; // TP_FIXED_POINTS
input double DonchianTP_Mult       = 1.0;  // TP_DONCHIAN_WIDTH

input int    SlippagePoints        = 30;

input group "Notifications"
input bool   PopupAlerts           = true;
input bool   PushNotifications     = true;

//--- Globals
CTrade gTrade;

int gFractalsHandle = INVALID_HANDLE;
int gAtrHandle      = INVALID_HANDLE;
int gDonchianHandle = INVALID_HANDLE;
int gEmaFastHandle  = INVALID_HANDLE;
int gEmaSlowHandle  = INVALID_HANDLE;

datetime gLastSignalBarTime = 0;
int gTrendDir = 0; // 1 bullish, -1 bearish, 0 unknown

// PERF: Cached signal timeframe.
ENUM_TIMEFRAMES gSignalTf = PERIOD_CURRENT;

// PERF: Cached validated Donchian lookback.
int gDonchianLookback = 20;

// --- Cached symbol properties (performance)
double G_POINT = 0.0;
double G_TICK_SIZE = 0.0;
double G_TICK_VALUE = 0.0;
double G_VOL_MIN = 0.0;
double G_VOL_MAX = 0.0;
double G_VOL_STEP = 0.0;
int    G_DIGITS = 2;
int    G_STOPS_LEVEL = 0;
double G_MIN_STOP_PRICE = 0.0;

// --- Cached MTF direction (performance)
datetime g_mtfDir_lastCheckTime = 0;
int      g_mtfDir_cachedValue = 0;

//--- Functions
int GetMTFDir()
{
  if(!RequireMTFConfirm) return 0;
  if(gEmaFastHandle==INVALID_HANDLE || gEmaSlowHandle==INVALID_HANDLE) return 0;

  datetime mtf_time[];
  if(CopyTime(_Symbol, LowerTF, 0, 1, mtf_time) != 1) return 0;
  if(mtf_time[0] == g_mtfDir_lastCheckTime) return g_mtfDir_cachedValue;
  g_mtfDir_lastCheckTime = mtf_time[0];

  double fast[], slow[];
  if(CopyBuffer(gEmaFastHandle, 0, 1, 1, fast) != 1) { g_mtfDir_cachedValue=0; return 0; }
  if(CopyBuffer(gEmaSlowHandle, 0, 1, 1, slow) != 1) { g_mtfDir_cachedValue=0; return 0; }

  if(fast[0] > slow[0]) g_mtfDir_cachedValue = 1;
  else if(fast[0] < slow[0]) g_mtfDir_cachedValue = -1;
  else g_mtfDir_cachedValue = 0;

  return g_mtfDir_cachedValue;
}

// --- Cached ATR value (performance)
double   g_atr_cachedValue = 0.0;
datetime g_atr_cacheTime = 0;

double GetATR(const int signalBar, const datetime signalBarTime)
{
  if(g_atr_cacheTime == signalBarTime && g_atr_cachedValue > 0.0) return g_atr_cachedValue;

  if(g_atr_cacheTime != signalBarTime)
  {
    g_atr_cachedValue = 0.0;
    g_atr_cacheTime = signalBarTime;
  }

  if(gAtrHandle == INVALID_HANDLE) return 0.0;

  double atr[];
  if(CopyBuffer(gAtrHandle, 0, signalBar, 1, atr) != 1) return 0.0;
  if(atr[0] <= 0.0) return 0.0;

  g_atr_cachedValue = atr[0];
  return g_atr_cachedValue;
}

bool HasOpenPosition(const string sym, const long magic)
{
  for(int i=PositionsTotal()-1; i>=0; i--)
  {
    ulong ticket = PositionGetTicket(i);
    if(ticket <= 0) continue;
    if(!PositionSelectByTicket(ticket)) continue;
    
    if(PositionGetString(POSITION_SYMBOL) != sym) continue;
    if(PositionGetInteger(POSITION_MAGIC) != magic) continue;
    return true;
  }
  return false;
}

double NormalizeLots(double lots)
{
  lots = MathMax(G_VOL_MIN, MathMin(G_VOL_MAX, lots));
  lots = MathFloor(lots/G_VOL_STEP) * G_VOL_STEP;
  int volDigits = (int)MathRound(-MathLog10(G_VOL_STEP));
  if(volDigits < 0) volDigits = 2;
  if(volDigits > 8) volDigits = 8;
  return NormalizeDouble(lots, volDigits);
}

double LotsFromRisk(const double riskPct, const double slPoints, const bool useEquity)
{
  if(riskPct <= 0.0 || slPoints <= 0.0) return 0.0;

  double base = (useEquity ? AccountInfoDouble(ACCOUNT_EQUITY) : AccountInfoDouble(ACCOUNT_BALANCE));
  double riskMoney = base * (riskPct/100.0);

  if(G_TICK_VALUE <= 0 || G_TICK_SIZE <= 0) return 0.0;
  double valuePerPointPerLot = G_TICK_VALUE * (G_POINT / G_TICK_SIZE);
  if(valuePerPointPerLot <= 0) return 0.0;

  return riskMoney / (slPoints * valuePerPointPerLot);
}

double NormalizePriceToTick(double price)
{
  double tick = (G_TICK_SIZE > 0.0 ? G_TICK_SIZE : G_POINT);
  if(tick > 0.0) price = MathRound(price / tick) * tick;
  return NormalizeDouble(price, G_DIGITS);
}

double ClampLotsToMargin(const ENUM_ORDER_TYPE type, double lots, const double price)
{
  if(lots <= 0.0 || !RiskClampToFreeMargin) return lots;

  double freeMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
  if(freeMargin <= 0.0) return 0.0;

  double margin=0.0;
  if(!OrderCalcMargin(type, _Symbol, lots, price, margin)) return lots;
  if(margin <= freeMargin) return lots;

  double margin1=0.0;
  if(!OrderCalcMargin(type, _Symbol, 1.0, price, margin1) || margin1 <= 0.0) return lots;

  return MathMin(lots, (freeMargin / margin1) * 0.95);
}

void Notify(const string msg)
{
  if(PopupAlerts) Alert(msg);
  if(PushNotifications) SendNotification(msg);
}

//--- Entry Points
int OnInit()
{
  gSignalTf = (SignalTF==PERIOD_CURRENT ? (ENUM_TIMEFRAMES)_Period : SignalTF);

  gFractalsHandle = iFractals(_Symbol, gSignalTf);
  gAtrHandle = iATR(_Symbol, gSignalTf, ATRPeriod);
  
  gDonchianLookback = (DonchianLookback < 2 ? 2 : DonchianLookback);
  gDonchianHandle = iCustom(_Symbol, gSignalTf, "Free Indicators\\Donchian Channel", gDonchianLookback, false);

  gEmaFastHandle = iMA(_Symbol, LowerTF, EMAFast, 0, MODE_EMA, PRICE_CLOSE);
  gEmaSlowHandle = iMA(_Symbol, LowerTF, EMASlow, 0, MODE_EMA, PRICE_CLOSE);

  if(gFractalsHandle == INVALID_HANDLE || gAtrHandle == INVALID_HANDLE || 
     gDonchianHandle == INVALID_HANDLE || gEmaFastHandle == INVALID_HANDLE || 
     gEmaSlowHandle == INVALID_HANDLE) return INIT_FAILED;

  gTrade.SetExpertMagicNumber(MagicNumber);
  gTrade.SetDeviationInPoints(SlippagePoints);

  G_POINT = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
  G_TICK_SIZE = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
  G_TICK_VALUE = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE_LOSS);
  if(G_TICK_VALUE <= 0.0) G_TICK_VALUE = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
  G_VOL_MIN = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
  G_VOL_MAX = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
  G_VOL_STEP = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
  G_DIGITS = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
  G_STOPS_LEVEL = (int)MathMax(SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL), SymbolInfoInteger(_Symbol, SYMBOL_TRADE_FREEZE_LEVEL));
  G_MIN_STOP_PRICE = G_STOPS_LEVEL * G_POINT;

  return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
  IndicatorRelease(gFractalsHandle);
  IndicatorRelease(gAtrHandle);
  IndicatorRelease(gDonchianHandle);
  IndicatorRelease(gEmaFastHandle);
  IndicatorRelease(gEmaSlowHandle);
}

void OnTick()
{
  // --- Weekend Filter ---
  MqlDateTime dt;
  TimeToStruct(TimeCurrent(), dt);
  if(dt.day_of_week == 0 || dt.day_of_week == 6)
  {
    if(!AllowWeekendTrading && _Symbol != "BTCUSD" && _Symbol != "ETFXAU") return;
  }

  const int sigBar = (FireOnClose ? 1 : 0);
  datetime bar_time[];
  if(CopyTime(_Symbol, gSignalTf, 0, sigBar+1, bar_time) <= sigBar) return;
  if(bar_time[sigBar] == gLastSignalBarTime) return;
  gLastSignalBarTime = bar_time[sigBar];

  double lastSwingHigh = 0.0, lastSwingLow = 0.0;
  datetime lastSwingHighT = 0, lastSwingLowT = 0;
  double closeSig = 0.0;

  if(UseSMC || SLMode == SL_SWING)
  {
    MqlRates rates[];
    int needBars = MathMin(400, Bars(_Symbol, gSignalTf));
    if(needBars < 100 || CopyRates(_Symbol, gSignalTf, 0, needBars, rates) < 100) return;
    ArraySetAsSeries(rates, true);
    closeSig = rates[sigBar].close;

    double upFr[], dnFr[];
    int frNeed = MathMin(300, needBars);
    if(CopyBuffer(gFractalsHandle, 0, 0, frNeed, upFr) > 0 && CopyBuffer(gFractalsHandle, 1, 0, frNeed, dnFr) > 0)
    {
      ArraySetAsSeries(upFr, true);
      ArraySetAsSeries(dnFr, true);
      for(int i=sigBar+2; i<frNeed; i++)
      {
        if(lastSwingHighT==0 && upFr[i] != 0.0 && upFr[i] != EMPTY_VALUE) { lastSwingHigh = upFr[i]; lastSwingHighT = rates[i].time; }
        if(lastSwingLowT==0  && dnFr[i] != 0.0 && dnFr[i] != EMPTY_VALUE)  { lastSwingLow  = dnFr[i]; lastSwingLowT  = rates[i].time; }
        if(lastSwingHighT!=0 && lastSwingLowT!=0) break;
      }
    }
  }
  else
  {
    double closes[];
    if(CopyClose(_Symbol, gSignalTf, sigBar, 1, closes) != 1) return;
    closeSig = closes[0];
  }

  double donUp[], donDn[];
  if(CopyBuffer(gDonchianHandle, 0, sigBar+1, 1, donUp) != 1 || CopyBuffer(gDonchianHandle, 2, sigBar+1, 1, donDn) != 1) return;
  double donHigh = donUp[0], donLow = donDn[0];

  bool smcLong = (UseSMC && lastSwingHighT!=0 && closeSig > lastSwingHigh);
  bool smcShort = (UseSMC && lastSwingLowT!=0 && closeSig < lastSwingLow);
  bool donLong = (UseDonchianBreakout && closeSig > donHigh);
  bool donShort = (UseDonchianBreakout && closeSig < donLow);

  if(!(smcLong || donLong || smcShort || donShort)) return;

  int mtfDir = GetMTFDir();
  if(RequireMTFConfirm)
  {
    if((smcLong || donLong) && mtfDir != 1) return;
    if((smcShort || donShort) && mtfDir != -1) return;
  }

  bool isLong = (smcLong || donLong);
  if(isLong) gTrendDir = 1; else gTrendDir = -1;

  Notify(StringFormat("%s %s | TF=%s | SMC=%s DON=%s", _Symbol, (isLong?"LONG":"SHORT"), EnumToString(gSignalTf), (smcLong||smcShort?"Y":"N"), (donLong||donShort?"Y":"N")));

  if(!EnableTrading || (OnePositionPerSymbol && HasOpenPosition(_Symbol, MagicNumber))) return;

  double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
  double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
  double entry = (isLong ? ask : bid);
  double sl = 0.0, tp = 0.0;

  if(SLMode == SL_SWING)
  {
    double buf = SwingSLBufferPoints * G_POINT;
    sl = (isLong ? lastSwingLow - buf : lastSwingHigh + buf);
    if(sl <= 0.0 || (isLong && sl >= entry) || (!isLong && sl <= entry))
    {
      double atr = GetATR(sigBar, bar_time[sigBar]);
      sl = (isLong ? entry - ATR_SL_Mult * atr : entry + ATR_SL_Mult * atr);
    }
  }
  else if(SLMode == SL_FIXED_POINTS) sl = (isLong ? entry - FixedSLPoints * G_POINT : entry + FixedSLPoints * G_POINT);
  else sl = (isLong ? entry - ATR_SL_Mult * GetATR(sigBar, bar_time[sigBar]) : entry + ATR_SL_Mult * GetATR(sigBar, bar_time[sigBar]));

  if(sl <= 0.0) return;

  if(TPMode == TP_FIXED_POINTS) tp = (isLong ? entry + FixedTPPoints * G_POINT : entry - FixedTPPoints * G_POINT);
  else if(TPMode == TP_DONCHIAN_WIDTH) tp = (isLong ? entry + DonchianTP_Mult * MathAbs(donHigh-donLow) : entry - DonchianTP_Mult * MathAbs(donHigh-donLow));
  else tp = (isLong ? entry + RR * MathAbs(entry-sl) : entry - RR * MathAbs(entry-sl));

  if(G_MIN_STOP_PRICE > 0)
  {
    if(isLong) { sl = MathMin(sl, entry - G_MIN_STOP_PRICE); tp = MathMax(tp, entry + G_MIN_STOP_PRICE); }
    else { sl = MathMax(sl, entry + G_MIN_STOP_PRICE); tp = MathMin(tp, entry - G_MIN_STOP_PRICE); }
  }

  sl = NormalizePriceToTick(sl); tp = NormalizePriceToTick(tp);
  double lots = (RiskPercent > 0 ? LotsFromRisk(RiskPercent, MathAbs(entry-sl)/G_POINT, RiskUseEquity) : FixedLots);
  lots = NormalizeLots(ClampLotsToMargin(isLong?ORDER_TYPE_BUY:ORDER_TYPE_SELL, lots, entry));

  if(lots > 0) { if(isLong) gTrade.Buy(lots, _Symbol, 0.0, sl, tp); else gTrade.Sell(lots, _Symbol, 0.0, sl, tp); }
}
