# How to Connect Your MetaTrader 5 Terminal to an MQL5 VPS

This guide provides the standard, correct procedure for connecting your MetaTrader 5 (MT5) terminal to your MQL5 Virtual Hosting service. This process is called **migration** and is performed entirely within the MT5 terminal's graphical user interface (GUI).

**There is no need for any external scripts.** The following steps will synchronize your local trading environment (accounts, charts, indicators, and Expert Advisors) to the MQL5 virtual server, allowing it to run 24/7.

## Prerequisites

Before you begin, please ensure the following are set up on your **local computer** (not the VPS):

1.  **Exness MetaTrader 5 Terminal:** You must have the Exness MT5 terminal installed.
2.  **Trading Account:** You must be logged into your Exness trading account within the terminal.
3.  **MQL5 Community Account:** You must be logged into your MQL5 account (`lengkundee`). To do this, go to `Tools > Options > Community` and enter your MQL5 username and password.

## Step-by-Step Migration Instructions

1.  **Open the Navigator Window:**
    *   In your MT5 terminal, go to the `View` menu and select `Navigator`, or press `Ctrl+N`.

2.  **Locate Your Trading Account:**
    *   In the Navigator window, you will see a list of your accounts. Find the trading account that you want to run on the VPS.

3.  **Initiate the Migration:**
    *   Right-click on your trading account number in the Navigator.
    *   In the context menu that appears, select **"Register a Virtual Server"**.

4.  **Follow the Virtual Hosting Wizard:**
    *   The "Virtual Hosting Wizard" will open. This wizard will guide you through the process.
    *   It will automatically detect your MQL5 account and your active VPS subscription.
    *   You will be prompted to choose the type of migration. Select **"Migrate trading environment: charts, indicators, Expert Advisors, and settings"**.

5.  **Confirm and Start the Migration:**
    *   Review the summary of what will be migrated.
    *   Click the "Migrate" button to start the synchronization process. The terminal will copy your EAs, indicators, open charts, and settings to the MQL5 virtual server.

6.  **Verify the Migration:**
    *   After the migration is complete, you can check its status.
    *   Right-click on your account in the Navigator again and look at the virtual server context menu. You should see details about the VPS, including CPU and memory usage.
    *   You can also check the terminal's **Journal** tab for logs related to the migration and the activity of your EAs on the virtual server.

Your trading environment is now running on the MQL5 VPS. You can close your local MetaTrader 5 terminal, and your EAs will continue to run on the virtual server.

**Important Note:** If you need to make changes to your trading setup (e.g., add a new EA, change EA settings, or open a new chart), you must make those changes on your **local terminal first** and then **re-migrate** your environment by following these steps again.
