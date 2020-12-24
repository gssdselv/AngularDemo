using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.FrameWork.Contract.AppSettings
{
    public interface IMailServiceAppsettings
    {
        string EMailFromAddress { get; set; }
        string MailTemplatePath { get; set; }
        string SmtpAddress { get; set; }
        int SmtpTimeout { get; set; }
        bool IsEmailRequired { get; set; }

    }
}
