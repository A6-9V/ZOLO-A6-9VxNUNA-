//+------------------------------------------------------------------+
//|                                    AccountSetup_411534497.mq5 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   // Display account information
   Print("=== Account Setup Information ===");
   Print("Account Number: {{MT5_ACCOUNT}}");
   Print("Server: Exness-MT5Real8");
   Print("Account Type: Real");
   Print("");
   
   // Check current account
   long currentAccount = AccountInfoInteger(ACCOUNT_LOGIN);
   string currentServer = AccountInfoString(ACCOUNT_SERVER);
   
   Print("=== Current Account Status ===");
   Print("Current Account: ", currentAccount);
   Print("Current Server: ", currentServer);
   Print("");
   
   // Verify connection
   if(currentAccount == {{MT5_ACCOUNT}} && currentServer == "Exness-MT5Real8")
   {
      Print("✓ Account {{MT5_ACCOUNT}} is connected!");
      Print("Account Name: ", AccountInfoString(ACCOUNT_NAME));
      Print("Account Company: ", AccountInfoString(ACCOUNT_COMPANY));
      Print("Account Balance: ", AccountInfoDouble(ACCOUNT_BALANCE));
      Print("Account Equity: ", AccountInfoDouble(ACCOUNT_EQUITY));
      Print("Account Currency: ", AccountInfoString(ACCOUNT_CURRENCY));
      Print("Account Leverage: 1:", AccountInfoInteger(ACCOUNT_LEVERAGE));
      Print("Account Server: ", AccountInfoString(ACCOUNT_SERVER));
      Print("Connection Status: ", TerminalInfoInteger(TERMINAL_CONNECTED) ? "Connected" : "Disconnected");
   }
   else
   {
      Print("⚠ Account {{MT5_ACCOUNT}} is NOT currently connected.");
      Print("");
      Print("To connect to this account:");
      Print("1. In MT5, go to: File -> Login to Trade Account");
      Print("2. Enter Account: {{MT5_ACCOUNT}}");
      Print("3. Enter Password: [YOUR_PASSWORD]");
      Print("4. Select Server: Exness-MT5Real8");
      Print("5. Click Login");
   }
   
   Print("=== End of Account Information ===");
}
//+------------------------------------------------------------------+
