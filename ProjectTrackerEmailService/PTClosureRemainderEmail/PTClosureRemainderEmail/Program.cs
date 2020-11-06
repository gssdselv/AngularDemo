using System;
using System.Configuration;
using System.Linq;
using EmailComponent;
using System.Text;
using log4net.Appender;
using log4net.Repository;
using log4net;
using System.IO;
[assembly: log4net.Config.XmlConfigurator(Watch = true)]

namespace PTClosureRemainderEmail
{
    internal class Program
    {        
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
        private static void Main(string[] args)
        {
            try
            {                
                GetEmailIdsFromDB getEmails = new GetEmailIdsFromDB();
                getEmails.ConnectionString = ConfigurationManager.ConnectionStrings["d_PTConnectionString"].ConnectionString;
                getEmails.StoredProcName = "SP_GetProjectOverDueDetail";                 
                System.Data.DataSet ds = getEmails.GetMailIds();
                Email email = new Email();
                email.FromEmail = ConfigurationManager.AppSettings["fromEmail"].ToString();
                email.FromName = ConfigurationManager.AppSettings["fromName"].ToString();
                email.SmtpServer = ConfigurationManager.AppSettings["host"].ToString();
                email.Port = Convert.ToInt32(ConfigurationManager.AppSettings["port"].ToString());                
                foreach (System.Data.DataRow dr in ds.Tables[0].Rows)
                {
                    email.Subject = string.Format("{0}{1}", ConfigurationManager.AppSettings["Subject"].ToString(), dr["PROJECTID"].ToString());
                    email.MessageBody = GetHtml(dr);
                    string ccReceipents = GetCCRecipentsList(dr["CREATOR_ADID"].ToString(), dr["Co_Owner_Email"].ToString());   
                    //string ccReceipents = ConfigurationManager.AppSettings["fromEmail"].ToString();                    
                    bool result = email.SendEmail(dr["Owner_Email"].ToString(), dr["Owner"].ToString(), ccReceipents);                   
                }
            }
            catch (Exception ex)
            {
                string err = string.Format("{0} : {1}\r\nError Message: {2}", DateTime.Now.ToLongDateString(), DateTime.Now.ToLongTimeString(), ex.Message);
                err += "\r\n";
                err += string.Format("Stack Trace: {0}", ex.StackTrace);
                log.Info(string.Format("Exception ..{0}", err));
            }
        }

        private static string GetCCRecipentsList(string owner, string coOwnerEmail)
        {
            User usr = new User();
            string managerEmail = string.Empty;
            ADUserSelect currentUser = usr.GetUser(owner);
            if (currentUser != null)
            {
                string manager = currentUser.Manager.Substring(currentUser.Manager.IndexOf("CN"), currentUser.Manager.IndexOf(","));
                managerEmail = string.Format("{0};", usr.GetMailManager(manager));
            }
            string recipient =  string.Format("{0};{1}{2}", coOwnerEmail, managerEmail, ConfigurationManager.AppSettings["AutomationHeadEmail"].ToString());
            return string.Join(";", recipient.Split(';').Distinct().ToArray()); // remove duplicates from email list
        }

        private static string GetHtml(System.Data.DataRow dr)
        { 
            string sDtlFormUrl = ConfigurationManager.AppSettings["DTLFORMURL"];            
            string htmlTableStart = "<table style=\"border-collapse:collapse; text-align:center;font-family: Verdana; font-size: 14px;\" >";
            string htmlTableEnd = "</table>";
            string htmlHeaderRowStart = "<tr style =\"background-color:#6FA1D2; color:#ffffff;\">";
            string htmlHeaderRowEnd = "</tr>";
            string htmlTrStart = "<tr style =\"color:#555555;\">";
            string htmlTrEnd = "</tr>";
            string htmlTdStart = "<td style=\" border-color:#5c87b2; border-style:solid; border-width:thin; padding: 5px;\">";
            string htmlTdEnd = "</td>";
            StringBuilder messageBody = new StringBuilder();
            messageBody.AppendFormat(string.Format("<p style=\"font-family: Verdana;\">Hello {0},</p><p style=\"font-family: Verdana; font-size: 13.5px;\"> &nbsp;&nbsp;&nbsp;&nbsp; The below Automation project is <b>OPEN</b> in <b>DEFINE</b> STAGE for more than 60 days.{1}Kindly review and update project with state <b>CLOSED, HOLD or DROPPED</b> as directed by your manager.</p><br>", dr["Owner"].ToString(), "<br>"));
            messageBody.Append(htmlTableStart);
            messageBody.Append(htmlHeaderRowStart);
            messageBody.AppendFormat(string.Format("{0}Project ID{1}", htmlTdStart, htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}Open Date{1}", htmlTdStart, htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}Project Description{1}", htmlTdStart, htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}Responsible{1}", htmlTdStart, htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}Co-Responsible{1}", htmlTdStart, htmlTdEnd));
            messageBody.AppendFormat(htmlHeaderRowEnd);
            messageBody.AppendFormat(string.Format("{0}",htmlTrStart));
            messageBody.AppendFormat(string.Format("{0}<a href=' {1}{2}'>{3}</a>{4}",  htmlTdStart, sDtlFormUrl, dr["PROJECTID"], dr["PROJECTID"], htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}{1}{2}",  htmlTdStart, dr["OPEN_DATE"], htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}{1}{2}",  htmlTdStart, dr["PRJ_DESC"], htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}{1}{2}",  htmlTdStart, dr["Owner"], htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}{1}{2}",  htmlTdStart, dr["Co_Owner"], htmlTdEnd));
            messageBody.AppendFormat(string.Format("{0}", htmlTrEnd));
            messageBody.AppendFormat(string.Format("{0}", htmlTableEnd));
            messageBody.AppendFormat(string.Format("<p style=\"font-family: Verdana; font-size: 13px;\"> Note: This is a system generated email. Please donot reply back to this email.</p>"));
            return messageBody.ToString();
        }
    }
}