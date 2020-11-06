using System;
using System.Configuration;
using System.DirectoryServices;
using System.Text;
using System.Xml;

namespace PTClosureRemainderEmail
{
    public class User
    {
		private DirectoryEntry ADConnection()
		{
            string ldap = ConfigurationManager.AppSettings["LDAP_PATH"];
            string user = ConfigurationManager.AppSettings["LDAP_DOMAINUSER"];
            string pass = ConfigurationManager.AppSettings["LDAP_PASS"];			
			DirectoryEntry deConnection = new DirectoryEntry(ldap, user, pass, AuthenticationTypes.Secure);			
			return deConnection;
		}

        /// <summary>
        /// Find mail manager
        /// </summary>
        /// <param name="manager">Manager information (CN=ManagerName)</param>
        /// <returns>Manager mail</returns>
        public string GetMailManager(string manager)
        {
            string mailManager = "";
            string search = string.Format("(&(objectClass=user)({0}))", manager);

            DirectorySearcher ds = new DirectorySearcher();
            ds.SearchRoot = ADConnection();
            ds.SearchScope = SearchScope.Subtree;
            string[] propertiesToLoad = Convert.ToString("samAccountName; title; company; department; phisicalDeliveryOfficeName; st; l; streetAddress; postalCode; telephoneNumber; otherTelephone; extensionAttribute1; extensionAttribute2; extensionAttribute3; extensionAttribute4; pager; manager; facSmileTelephoneNumber; otherHomePhone; info; mobile; msExchAssistantName; telephoneAssistant; description; homePhone; ").Split(';');

            foreach (string s in propertiesToLoad)
            {
                ds.PropertiesToLoad.Add(s);
            }

            ds.Filter = search;
            ADUserSelect adSel = null;
            if (ds.FindAll().Count > 0)
            {
                DirectoryEntry de = ds.FindOne().GetDirectoryEntry();
                adSel = new ADUserSelect();
                mailManager = adSel.Email = de.Properties["mail"].Value == null ? "" : de.Properties["mail"].Value.ToString();
            }
            return mailManager;
        } 

        public ADUserSelect GetUser(string UserName)
        {
            ADUserSelect userInfo = new ADUserSelect();
            string loginname = UserName;

            string URL = string.Format("{0}filter=(samaccountname={1})", ConfigurationSettings.AppSettings.Get("FlexADURL"), loginname);

            System.Net.WebClient webRequest = new System.Net.WebClient();
            byte[] requestedHtml = webRequest.DownloadData(URL);
            UTF8Encoding utf8 = new UTF8Encoding();
            string requestedHtmlUnicode = utf8.GetString(requestedHtml);

            XmlDataDocument oXml = new XmlDataDocument();
            oXml.LoadXml(requestedHtmlUnicode);

            XmlNodeList oNodes = oXml.SelectNodes("ResultSet/ADUserInfo");

            if (oNodes.Count == 0)
                return null;

            XmlNode oNode = oNodes.Item(0);

            userInfo.Email = oNode["mail"].InnerText;
            userInfo.FirstName = oNode["givenname"].InnerText;
            userInfo.LastName = oNode["sn"].InnerText;

            //Get manager
            ADUserSelect managerInformation = GetUser(userInfo.FirstName, userInfo.LastName, loginname);
            userInfo.Manager = managerInformation.Manager;
            return userInfo;
        }

        public ADUserSelect GetUser(string firstName, string lastName, string loginname)
        {
            string search = string.Format("(&(objectClass=user)(sn={1})(givenName={0}))", firstName, lastName);
            search = string.Format("(&(objectClass=user)(samAccountName={0}))", loginname);
            string[] propertiesToLoad = Convert.ToString("samAccountName; title; company; department; phisicalDeliveryOfficeName; st; l; streetAddress; postalCode; telephoneNumber; otherTelephone; extensionAttribute1; extensionAttribute2; extensionAttribute3; extensionAttribute4; pager; manager; facSmileTelephoneNumber; otherHomePhone; info; mobile; msExchAssistantName; telephoneAssistant; description; homePhone; ").Split(';');

            DirectorySearcher ds = new DirectorySearcher();
            ds.SearchRoot = ADConnection();
            ds.SearchScope = SearchScope.Subtree;

            foreach (string s in propertiesToLoad)
            {
                ds.PropertiesToLoad.Add(s);
            }

            ds.Filter = search;
            ADUserSelect adSel = null;
            if (ds.FindAll().Count > 0)
            {
                DirectoryEntry de = ds.FindOne().GetDirectoryEntry();
                adSel = new ADUserSelect();
                adSel.Manager = de.Properties["manager"].Value == null ? "" : de.Properties["manager"].Value.ToString();
            }
            return adSel;
        }
    }

	#region Class ADUserSearch

	public class ADUserSearch
	{
		public string FirstName
		{
			get{return firstName;}
			set{firstName = value;}	
		}

		public string LastName
		{
			get{return lastName;}
			set{lastName = value;}
		}

		public string UserName
		{
			get{return userName;}
			set{userName = value;}
		}

		private string firstName;
		private string lastName;
		private string userName;
        private string email;
	}

	#endregion

	#region Class ADUserSelect

	public class ADUserSelect
	{
		#region Propriedades

		public string UserName
		{
			get{return userName;}
			set{userName = value;}
		}

        public string Email
        {
            get { return email; }
            set { email = value; }
        }

		public string Title
		{
			get{return title;}
			set{title = value;}
		}

		public string OfficeLocation
		{
			get{return officeLocation;}
			set{officeLocation = value;}
		}

		public string State
		{
			get{return state;}
			set{state = value;}
		}

		public string Street
		{
			get{return street;}
			set{street = value;}
		}

		public string PostalCode
		{
			get{return postalCode;}
			set{postalCode = value;}
		}

		public string Phone
		{
			get{return phone;}
			set{phone = value;}
		}

		public string OtherPhone
		{
			get{return otherPhone;}
			set{otherPhone = value;}
		}

		public string[] VOIP
		{
			get{return voip;}
			set{voip = value;}
		}

		public string Pager
		{
			get{return pager;}
			set{pager = value;}
		}

		public string Manager
		{
			get{return manager;}
			set{manager = value;}
		}

		public string Fax
		{
			get{return fax;}
			set{fax = value;}
		}

		public string HomePhone
		{
			get{return homePhone;}
			set{homePhone = value;}
		}

		public string OtherHomePhone
		{
			get{return otherHomePhone;}
			set{otherHomePhone = value;}
		}

		public string Info
		{
			get{return info;}
			set{info = value;}
		}

		public string Mobile
		{
			get{return mobile;}
			set{mobile = value;}
		}

		public string ExchAssistantName
		{
			get{return exchAssistantName;}
			set{exchAssistantName = value;}
		}

		public string AssistantPhone
		{
			get{return assistantPhone;}
			set{assistantPhone = value;}
		}

		public string Description
		{
			get{return description;}
			set{description = value;}
		}

		public string City
		{
			get{return city;}
			set{city = value;}
		}

		public string LastName
		{
			get{return lastName;}
			set{lastName = value;}
		}

		public string FirstName
		{
			get{return firstName;}
			set{firstName = value;}
		}

		public string Company
		{
			get{return company;}
			set{company=value;}
		}

		public string Department
		{
			get{return department;}
			set{department = value;}
		}
        public string FullName
        {
            get { return FirstName + " " + LastName; }
        }

		#endregion

		#region Atributos
        private string email;
		private string firstName;
		private string lastName;
		private string userName;
		private string title;
		private string company;
		private string department;
		private string officeLocation;
		private string state;
		private string city;
		private string street;
		private string postalCode;
		private string phone;
		private string otherPhone;
		private string[] voip;
		private string pager;
		private string manager;
		private string fax;
		private string homePhone;
		private string otherHomePhone;
		private string info;
		private string mobile;
		private string exchAssistantName;
		private string assistantPhone;
		private string description;
		#endregion
	}

	#endregion



}
