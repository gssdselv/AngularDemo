using log4net;
using log4net.Appender;
using log4net.Repository;
using System;
using System.IO;
using System.Net;
using System.Net.Mail;
[assembly: log4net.Config.XmlConfigurator(Watch = true)]

namespace EmailComponent
{

    public class Email
    {
        public string Subject { get; set; }
        public string FromEmail { get; set; }
        public string FromName { get; set; }
        public string MessageBody { get; set; }
        public string SmtpServer { get; set; }
        public int Port { get; set; }
        public NetworkCredential SmtpCredentials { get; set; }

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

        public bool SendEmail(string toEmail, string toName,string ccEmail)
        {
            try
            {
                MailMessage message = new MailMessage();
                message.IsBodyHtml = true;
                message.To.Add(new MailAddress(toEmail, toName));
                if (!string.IsNullOrEmpty(ccEmail))
                {
                    foreach (var address in ccEmail.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        message.CC.Add(new MailAddress(address));
                    }
                }                
                message.From = (new MailAddress(this.FromEmail, this.FromName));
                message.Subject = this.Subject;
                message.Body = this.MessageBody;
                message.IsBodyHtml = true;
                message.BodyEncoding = System.Text.Encoding.UTF8;

                SmtpClient client = new SmtpClient();
                client.Host = this.SmtpServer;
                client.Port = this.Port;
                client.UseDefaultCredentials = false;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.SendCompleted += new SendCompletedEventHandler(SendCompletedCallback);
                Object userState = message;
                log.Info("Sending email");
                client.SendAsync(message, userState);
                log.Info("End Sending email");
            }
            catch (Exception ex)
            {
                log.Info(string.Format("Exception Sending email{0}", ex.Message));
                return false;
            }
            return true;
        }

        private static void SendCompletedCallback(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
        {
            // Get the unique identifier for this asynchronous operation.
            MailMessage token = e.UserState as MailMessage;
            if (e.Cancelled)
            {
                log.Info(string.Format("Sending email cancelled:{0}", token));                
            }
            if (e.Error != null)
            {
                log.Info(string.Format("Sending email cancelled{0}", e.Error.ToString()));               
            }
            else
            {
                log.Info("Message sent");
            }
            
        }

        
    }
}
