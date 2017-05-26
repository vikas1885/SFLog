global class SFLog
{  
  private static String LogData='';
  global enum LogTypes { HEAP, QUERY, DML, CPU, ALL }

    global static void addLog(Object msg, Boolean updateImmediately)
  {
        addLog(msg);
    if(updateImmediately)
            updateLog();
  }
    
    global static void addLog(LogTypes logtype, Object msg, Boolean updateImmediately)
  {
        addLog(logtype, msg);
        if(updateImmediately)
            updateLog();
    }   
    
  global static void addLog(Object msg)
  {
        msg = JSON.serialize( msg).replaceAll('"','');
        LogData += '\n'+System.DateTime.now()+'\n';
        LogData += msg + '\n';
        
  }  

  /*  public  static String getCallingMethodName()
    {
       // StackTraceElement[] stacktrace = Thread.currentThread().getStackTrace();
    //StackTraceElement e = stacktrace[2];//maybe this number needs to be corrected
    String methodName;// = e.getMethodName();
    List<String>  methodList;
        try
        {
            integer num=1/0;
        }
        catch(System.Exception e)
        {
           methodName = e.getStackTraceString();
           methodList = methodName.split('Class');
        }
        
        return methodList[2];
  }
*/
  global static void addLog(LogTypes logtype, Object msg)
  {
        msg = JSON.serialize( msg).replaceAll('"','');
        
        LogData += '\n\n'+System.DateTime.now()+'\n';
   //     LogData += getCallingMethodName()+'\n';
        LogData += msg + ':\n';
    if(logtype == LogTypes.HEAP)
    {
            LogData += 'Heap Size is: ';  
      LogData += Limits.getHeapSize()+'\n';  
    }
    else if(logtype == LogTypes.QUERY)
    {
            LogData += 'Number of query is: ';
      LogData += Limits.getQueries()+'\n';  
    }
    else if(logtype == LogTypes.DML)
    {
            LogData += 'Number of DML is: ';
      LogData += Limits.getDMLStatements()+'\n';  
    }
    else if(logtype == LogTypes.CPU)
    {
            LogData += 'Cpu time is: ';            
      LogData += Limits.getCpuTime()+'\n';  
    }
        else if(logtype == LogTypes.ALL)
    {
            LogData += 'Heap Size is: ';
      LogData += Limits.getHeapSize()+'\n';  
            LogData += 'Number of query is: ';
            LogData += Limits.getQueries()+'\n';  
            LogData += 'Number of DML is: ';
            LogData += Limits.getDMLStatements()+'\n';  
            LogData += 'Cpu time is: ';            
      LogData += Limits.getCpuTime()+'\n';  
    }    
            LogData += '';
  }
  
  private static void updateLog(String value, Boolean clearLog)
  {
        DebugLog__c debugLog;
        try
        {
	       debugLog = [select LogDescription__c,LogNumber__c from DebugLog__c Limit 1];
        }
        catch(Exception e){
            
        }

        if(debugLog != null)
        {
            if(debugLog.LogDescription__c == null ||clearLog)
          {
              debugLog.LogDescription__c = '';
          }  
            debugLog.LogDescription__c += value;     
        }
        else
        {
            debugLog = new DebugLog__c(LogDescription__c= value, LogNumber__c= 1);
        }
    upsert debugLog LogNumber__c;
        LogData = ' ';
  }
  
  global static void updateLog()
  {
        updateLog(LogData,false);
    }
    
    global static void ClearLog()
  {
        updateLog(' ',true);
  }
}