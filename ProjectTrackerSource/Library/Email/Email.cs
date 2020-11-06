using System;
using System.Configuration;
using System.Net.Mail;
using System.Configuration.Provider;
using log4net;
using log4net.Appender;
using log4net.Repository;
using System.IO;

[assembly: log4net.Config.XmlConfigurator(Watch = true)]

namespace Library.Email
{
    public class Email : ProviderBase
    {
        private string server = ConfigurationManager.AppSettings["SmtpServer"].ToString();
        private int port = Convert.ToInt32(ConfigurationManager.AppSettings["port"].ToString());

        public static void Initialize(string logDirectory)
        {
            ILoggerRepository repository = LogManager.GetRepository();
            IAppender[] appenders = repository.GetAppenders();
            foreach (IAppender appender in appenders)
            {
                FileAppender fileAppender = appender as FileAppender;
                fileAppender.File = Path.Combine(logDirectory, Path.GetFileName(fileAppender.File));
                fileAppender.ActivateOptions();
            }
        }
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger
        (System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        public bool SendEmail(string body, string subject, string from, string[] to, string[] cc)
        {
            if (!object.Equals(ConfigurationManager.AppSettings["TestMode"], null))
            {
                if (ConfigurationManager.AppSettings["TestMode"].ToString() == "1")
                {
                    from = "kumar.sundaram@flextronics.com";
                    to = new string[] { "kumar.sundaram@flextronics.com" };
                    cc = to;
                    return true;
                }
            }

            bool isEnvoy = true;

            // Definições do servidor
            SmtpClient smtpClient = new SmtpClient(server);
            smtpClient.Port = port;            

            try
            {
                MailMessage mailMessage = new MailMessage();
                if (from == null)
                //throw new Exception("Empty shipper address.");
                {
                    //log.Info(string.Format("From is null {0}", from));
                    mailMessage.From = new MailAddress("ProjectTracker@Flextronics.com");
                }
                else
                {
                    mailMessage.From = new MailAddress(from);
                }
                
                foreach (string toAdress in to)
                {   
                    string[] emails = toAdress.Split(';');
                    foreach (string email in emails)
                    {                        
                        if (email != null && email.Trim() != "")
                        {
                            mailMessage.To.Add(email);
                        } 
                    }
                }
                
                //Add adrees to cc
                foreach (string ccAdress in cc)
                {                    
                    string[] emails = ccAdress.Split(';');                    
                    foreach (string email in emails)
                    {  
                        if (email != null && email.Trim() != "")
                        {
                            mailMessage.CC.Add(email);
                        }  
                    }
                }

                // Definições da mensagem
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                // Enviar Email
                smtpClient.Send(mailMessage);
            }
            catch (Exception ex)
            {
                isEnvoy = false;
                //throw e; chexmarx
                //log.Info(string.Format("Exception Sending email {0}", body + " From " + from + "  TO  " +  string.Join(";",to) + "  CC  " + string.Join(";", cc) + " Error " + ex.ToString()));
            }

            return isEnvoy;
        }
    }
}
