//+------------------------------------------------------------------+
//|                                                EA-Control-v1.mq4 |
//|                                                   David Martinez |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
#define _dts(_arg) TimeToString(_arg,TIME_DATE|TIME_MINUTES)
#define _prs(_arg) DoubleToString(_arg,(int)MarketInfo(OrderSymbol(),MODE_DIGITS))
#define _float(_arg) DoubleToString(_arg,2)
#define _lts(_arg) DoubleToString(_arg,2)
#define _del ","
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
datetime prevbar;

void OnTick()
  {
   if(prevbar == Time[0]) return;
   prevbar = Time[0];
//---
   int handle = FileOpen("HistoryFiles/" + IntegerToString(AccountNumber()) + ".csv", FILE_CSV|FILE_WRITE);
   if(handle!=INVALID_HANDLE)
     {
      int saved=0;


      // Columns names
      FileWrite(handle, "magic"  +_del+
                "ticket"         +_del+
                "openTime"       +_del+
                "orderType"      +_del+
                "lotSize"        +_del+
                "symbol"         +_del+
                "openPrice"      +_del+
                "stopLoss"       +_del+
                "takeProfit"     +_del+
                "closeTime"      +_del+
                "closePrice"     +_del+
                "commision"      +_del+
                "swap"           +_del+
                "profit"         +_del+
                "comment");

      // Data
      for(int i=0; i<=OrdersHistoryTotal()-1; i++)
        {
         if(!OrderSelect(i, SELECT_BY_POS,MODE_HISTORY))
            continue;
         int type = OrderType();
         switch(type)
           {
            case OP_BUY  :
            case OP_SELL :

               saved++;
               FileWrite(handle,(string)
                         IntegerToString(OrderMagicNumber()) +_del+
                         IntegerToString(OrderTicket())      +_del+
                         TimeToString(OrderOpenTime())       +_del+
                         (type==OP_SELL?"sell":"buy")        +_del+
                         DoubleToString(OrderLots(), 2)         +_del+
                         OrderSymbol()                       +_del+
                         DoubleToString(OrderOpenPrice())    +_del+
                         DoubleToString(OrderStopLoss())     +_del+
                         DoubleToString(OrderTakeProfit())   +_del+
                         TimeToString(OrderCloseTime())      +_del+
                         DoubleToString(OrderClosePrice())   +_del+
                         DoubleToString(OrderCommission(), 2)   +_del+
                         DoubleToString(OrderSwap(), 2)         +_del+
                         DoubleToString(OrderProfit(), 2)       +_del+
                         OrderComment());
           }
        }
      FileClose(handle);

     }

  }
//+------------------------------------------------------------------+
