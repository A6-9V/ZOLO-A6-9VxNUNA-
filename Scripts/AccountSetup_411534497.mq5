//+------------------------------------------------------------------+
//|                                    AccountSetup_411534497.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   // --- Configuration ---
   long   targetAccount = {{MT5_ACCOUNT}};
   string targetServer  = "Exness-MT5Real8";

   // --- Display Header ---
   Print("========================================================");
   Print("        MQL5 Account Connection Verification        ");
   Print("========================================================");
   Print("");

   // --- Get Current Account Information ---
   long   currentAccount = AccountInfoInteger(ACCOUNT_LOGIN);
   string currentServer  = AccountInfoString(ACCOUNT_SERVER);
   bool   isConnected    = TerminalInfoInteger(TERMINAL_CONNECTED);

   // --- Check Connection Status ---
   Print("[INFO] Target Account: ", targetAccount);
   Print("[INFO] Target Server:  ", targetServer);
   Print("--------------------------------------------------------");
   Print("[INFO] Current Account: ", currentAccount);
   Print("[INFO] Current Server:  ", currentServer);
   Print("[INFO] Connection Status: ", isConnected ? "Connected" : "Disconnected");
   Print("");

   // --- Verification Logic ---
   if(currentAccount == targetAccount && currentServer == targetServer && isConnected)
     {
      Print("[OK] Success! Your account is correctly connected and verified.");
      Print("[OK] Account Name:    ", AccountInfoString(ACCOUNT_NAME));
      Print("[OK] Account Balance: ", AccountInfoDouble(ACCOUNT_BALANCE), " ", AccountInfoString(ACCOUNT_CURRENCY));
      Print("[OK] Account Equity:  ", AccountInfoDouble(ACCOUNT_EQUITY));
      Print("[OK] Leverage:        1:", AccountInfoInteger(ACCOUNT_LEVERAGE));
     }
   else
     {
      Print("[ERROR] Verification Failed. The account is not correctly connected.");
      Print("");
      Print("Please check the following:");
      Print("1. You are logged into account '", targetAccount, "'.");
      Print("2. You are connected to the '", targetServer, "' server.");
      Print("3. Your terminal has an active internet connection.");
      Print("");
      Print("You can log in by going to 'File' -> 'Login to Trade Account'.");
     }

   Print("========================================================");
   Print("                  Verification Complete                  ");
   Print("========================================================");
  }
//+------------------------------------------------------------------+
