## EXNESS GenX Trading Project (Shared Projects)

This project lives under:

- `MQL5\Shared Projects\EXNESS_GenX_Trading`

It is designed as a **single place** to manage the logic that can trade on your EXNESS MetaTrader 5 terminal.

### Structure

- `EXPERTS\EXNESS_GenX_Trader.mq5` – main Expert Advisor
- `INCLUDE\EXNESS_GenX_Config.mqh` – configuration (symbols, risk, magic, etc.)
- `DOCS\WORKFLOW.md` – how to compile, attach, and test

> Note: MetaTrader 5 still controls:
> - Enabling AutoTrading
> - Attaching the EA to a chart
> - Strategy Tester runs

This folder centralizes code and configuration so that once attached, EXNESS can produce trades according to the logic here.


1767707827
D'2026.01.06 13:57:23'
