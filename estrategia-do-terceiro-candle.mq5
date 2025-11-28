//+------------------------------------------------------------------+
//|                                estrategia-do-terceiro-candle.mq5 |
//|                                              João Vitor Nogueira |
//|                                   https://github.com/jv-nogueira |
//+------------------------------------------------------------------+
#property copyright "João Vitor Nogueira"
#property link      "https://github.com/jv-nogueira"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
 
input double INPVOLUME = 0.01;
input double INPSTOP_LOSS = 0.0005;
input double INPTAKE_PROFIT = 0.0005;
 
CTrade trade;
MqlRates rates[];
MqlTick tick;

int OnInit()
  {
//---
   ArraySetAsSeries(rates, true);
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
void OnTick()
{
   Print("teste 1");
   int copied = CopyRates(_Symbol, _Period, 0, 5, rates);
   if(copied < 3) return;
   Print("teste 2");
   
   if(OrdersTotal()>=1) return;
   Print("teste 3");
   
  PositionSelect(_Symbol);
   Print("teste 4");
   if(PositionsTotal()>=1) return;
   Print("teste 5");
   
   if (!SymbolInfoTick(_Symbol, tick)) return;
   Print("teste 6 tick: ", tick.bid);
   
   if(BuyStrategy() && IsNewCandle( rates[0] )){
      BuyMarket(INPVOLUME, tick.bid - INPSTOP_LOSS, tick.bid + INPTAKE_PROFIT);
      Print("teste 7");
   }
   if(SellStrategy() && IsNewCandle( rates[0] )){
      SellMarket(INPVOLUME, tick.bid + INPSTOP_LOSS, tick.bid - INPTAKE_PROFIT);
      Print("teste 8");
   }
}

//+------------------------------------------------------------------+

bool BuyStrategy(){
   Print("teste 9");
   bool buy = false;
   if(rates[3].low < rates[1].low) buy=true;
   
   return buy;
}

bool SellStrategy(){
   Print("teste 10");
   bool sell = false;
   if(rates[3].high > rates[1].high) sell=true;
   
   return sell;
}

bool IsNewCandle(MqlRates & _rates){
   bool isNew = false;
   if(MathAbs(_rates.high - _rates.low) < 10) isNew = true;
   
   return isNew;
}

bool BuyMarket(double _volume, double _sl, double _tp){
    bool ok = trade.Buy( _volume, _Symbol, 0.0, _sl, _tp );

    if ( ! ok ) {
        int errorCode = GetLastError();
        Print("BuyMarket - ", errorCode );
        ResetLastError();
    }

    return ok;
}

bool SellMarket(double _volume, double _sl, double _tp){
    bool ok = trade.Sell( _volume, _Symbol, 0.0, _sl, _tp );

    if ( ! ok ) {
        int errorCode = GetLastError();
        Print("SellMarket - ", errorCode );
        ResetLastError();
    }

    return ok;
}
