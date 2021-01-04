using Flex.APT.FrameWork.Contract.AppSettings;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Flex.APT.Api.Common
{
    public class Appsetting : IMailServiceAppsettings, ICacheServiceAppsettings, IServerAppSettings
    {
        public string EMailFromAddress { get; set; }
        public string MailTemplatePath { get; set; }
        public string SmtpAddress { get; set; }
        public int SmtpTimeout { get; set; }
        public bool IsEmailRequired { get; set; }
        public string CacheServer { get; set; }
        public string InstanceName { get; set; }
        public string ServerName { get; set; }
    }
}
