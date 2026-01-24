//+------------------------------------------------------------------+
//|                                   MscDateTimeWithInheritance.mqh |
//|                           Copyright 2021, Tobias Johannes Zimmer |
//|                                 https://www.mql5.com/pennyhunter |
//+------------------------------------------------------------------+
#include <Tools\DateTime.mqh>

struct CDateTimeMsc: public CDateTime
  {
public:
   int               msc;                 // additional variable for msc storage
   datetime          check_datetime;      // for convenient observation a little overhead is required.

   //--- CDateTimeMsc methods

   ulong             MscTime(void) {return(ulong(double(CDateTime::DateTime()) * 1000) + msc);}
   void              MscTime(ulong a_msc_time);  // datetime*1000
   void              Msc(int value);
   //bool              IsNumInt(const int num);
   void              MscDec(int delta = 1);
   void              MscInc(int delta = 1);
   void              SecTime(int a_int_time);
   ulong             SecTime(void);
   void              UpdateDateTime();   // updates the observation variable check_datetime
   void              DateTime(datetime a_datetime) {CDateTime::DateTime(a_datetime); UpdateDateTime();}
   datetime          DateTime(void) {return(CDateTime::DateTime());}

  };
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Sets the milliseconds 'msc' to a value 0-999                     |
//+------------------------------------------------------------------+
void CDateTimeMsc::Msc(int value)
  {
//--- check and set
   if(value >= 0 && value < 1000)
      msc = value;
  }

//+------------------------------------------------------------------+
//| Assigns a ulong msc time                                         |
//+------------------------------------------------------------------+
void CDateTimeMsc::MscTime(ulong a_msc_time)
  {
   datetime imt = CDateTime::DateTime();
   int a_sec_time = int(double(a_msc_time) / 1000);
   TimeToStruct(a_sec_time, this);
   msc = int(a_msc_time - ulong(double(a_sec_time) * 1000));
   Print("msc: " + string(msc));
   UpdateDateTime();
  }
/*
//+------------------------------------------------------------------+
//| IsNumInt method                                                  |
//|                                                                  |
//| checks if the deduced time is within integer range               |
//+------------------------------------------------------------------+
bool CDateTimeMsc::IsNumInt(const int num)
  {
   bool flag = (num < int(INT_MAX) && num > int(INT_MIN));
   if(!flag)
      Print("INT_MAX exceeded");
   return(flag);
  }
*/
//+------------------------------------------------------------------+
//| Subtracts specified number of msc                                |
//+------------------------------------------------------------------+
void CDateTimeMsc::MscDec(int delta)
  {
//--- if increment is 0 - exit
   if(delta == 0)
      return;
//--- if increment is negative - inverse the operation
   if(delta < 0)
     {
      MscInc(-delta);
      return;
     }
//--- check if subtract from upper number positions
   if(delta > 1000)
     {
      SecDec(delta / 1000);
      delta %= 1000;
     }
   msc -= delta;
   if(msc < 0)
     {
      msc += 1000;
      SecDec();
     }
   UpdateDateTime();
  }
//+------------------------------------------------------------------+
//| Adds specified number of msc                                     |
//+------------------------------------------------------------------+
void CDateTimeMsc::MscInc(int delta)
  {
//--- if increment is 0 - exit
   if(delta == 0)
      return;
//--- if increment is negative - inverse the operation
   if(delta < 0)
     {
      MscDec(-delta);
      return;
     }
//--- check if add to upper number positions
   if(delta > 1000)
     {
      SecInc(delta / 1000);
      delta %= 1000;
     }
   msc += delta;
   if(msc >= 1000)
     {
      msc -= 1000;
      SecInc();
     }
   UpdateDateTime();
  }

//+------------------------------------------------------------------+
//| returns time in seconds since 1970.01.01. 00:00                  |
//+------------------------------------------------------------------+
ulong  CDateTimeMsc::SecTime(void)
  {
   return(int(CDateTime::DateTime()));
  }

//+------------------------------------------------------------------+
//| processes time in seconds since 1970.01.01. 00:00                |
//+------------------------------------------------------------------+
void  CDateTimeMsc::SecTime(int a_sec_time)
  {
   /*
      if(!IsNumInt(a_int_time))
         Alert(string(a_int_time) + " exceeds integer range!");
         */
   CDateTime::DateTime(datetime(a_sec_time));
   CDateTimeMsc::Msc(0);
   UpdateDateTime();
  }

//+------------------------------------------------------------------+
//| UpdateDateTime method updates the check_dt for observation       |
//+------------------------------------------------------------------+
void CDateTimeMsc::UpdateDateTime(void)
  {
   check_datetime = CDateTime::DateTime();
  }
//+------------------------------------------------------------------+
