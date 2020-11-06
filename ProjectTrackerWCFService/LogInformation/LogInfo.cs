using System;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace LogInformation
{
    public static class LogInfo
    {
        public static void LogException(string sExMessage)
        {
            LogEntry logEntry = new LogEntry { Message = sExMessage };
            Logger.Write(logEntry);
        }
    }
}
