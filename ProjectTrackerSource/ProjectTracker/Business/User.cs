using System;
using System.Configuration;
using System.DirectoryServices;
using System.Text;
using System.Xml;

namespace ProjectTracker.Business
{
    public class User
    {
        public static bool IsUserValid(string username)
        {
            User user = new User();
            ADUserSelect userFinded = user.GetUser(username);

            return ((userFinded) != null); 
        }

        public static bool Exists(string username)
        {
            ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UsersTableAdapter usersTbAdpt = new ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UsersTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker dts = new ProjectTracker.DAO.dtsProjectTracker();
            
            usersTbAdpt.FillByOption(dts.Users, username,0);

            return (dts.Users.Rows.Count > 0);
        }

        public static string Name(string username)
        {
            User u = new User();
            ADUserSelect userSearch = u.GetUser(username);

            if (userSearch == null)
                return "";
            return userSearch.FirstName + " "+ userSearch.LastName;
        }
        
		private SearchResultCollection SearchUsers(string FirstName, string LastName, string UserName)
		{
            FirstName = FirstName == "" ? "" : string.Format("{0}*", FirstName);
            LastName = LastName == "" ? "" : string.Format("{0}*", LastName);
            UserName = UserName == "" ? "" : string.Format("{0}*", UserName);
            // Substitui os parametros na string de busca
            string searchFilter = string.Format(ConfigurationManager.AppSettings["SearchAD"], FirstName, LastName, UserName);
			// string[] propertiesToLoad = ConfigurationSettings.AppSettings["PropertiesAD"].Split(';');
			string[] propertiesToLoad = {"givenName", "sn", "samAccountName"};
			// Cria um Directory Entry
			DirectoryEntry de = ADConnection();
			// Cria um Directory Searcher
			DirectorySearcher ds = new DirectorySearcher();
			// Define as propriedades do DS
			ds.SearchRoot = de;
			ds.SearchScope = SearchScope.Subtree;
			foreach(string s in propertiesToLoad)
			{
				ds.PropertiesToLoad.Add(s);
			}
			ds.Filter = searchFilter;
			// Retorna os resultados da busca...
			return ds.FindAll();
			
		}

		private DirectoryEntry ADConnection()
		{
            string ldap = ConfigurationManager.AppSettings["LDAP_PATH"];
            string user = ConfigurationManager.AppSettings["LDAP_DOMAINUSER"];
            string pass = ConfigurationManager.AppSettings["LDAP_PASS"]; //check
            //// Cria o objeto de comunicação com o AD
            //DirectoryEntry de = new DirectoryEntry(ldap, user, pass, AuthenticationTypes.Secure); //check
            DirectoryEntry de = new DirectoryEntry(ldap, user, pass, AuthenticationTypes.Secure);
            // Retorna o objeto
            return de;
		}

		private ADUserSearch[] GetUsers(SearchResultCollection Users)
		{
			int count = Users.Count;
			if(count > 0)
			{
				ADUserSearch[] gridUsers = new ADUserSearch[count];
				// Pega um DirectoryEntry para cada resultado
				for(int i=0; i<count; i++)
				{
					DirectoryEntry de = Users[i].GetDirectoryEntry();
					ADUserSearch usr = new ADUserSearch();
					usr.FirstName = (de.Properties["givenName"].Value==null)?"":de.Properties["givenName"].Value.ToString();
					usr.LastName = (de.Properties["sn"].Value==null)?"":de.Properties["sn"].Value.ToString();
					usr.UserName = (de.Properties["samAccountName"].Value==null)?"":de.Properties["samAccountName"].Value.ToString();
					gridUsers[i] = usr;
				}
				return gridUsers;
			}
			else
			{
				return null;
			}
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

                // Cria o objeto do usuário...
                adSel = new ADUserSelect();
                mailManager = adSel.Email = de.Properties["mail"].Value == null ? "" : de.Properties["mail"].Value.ToString();
            }

            return mailManager;
        }

        public ADUserSelect GetUser(string firstName, string lastName, string loginname)
        {
            string search = string.Format("(&(objectClass=user)(sn={1})(givenName={0}))", firstName, lastName);
            search = string.Format("(&(objectClass=user)(samAccountName={0}))", loginname);//Added by guoxin 2011-01-30
            string[] propertiesToLoad = Convert.ToString("samAccountName; title; company; department; phisicalDeliveryOfficeName; st; l; streetAddress; postalCode; telephoneNumber; otherTelephone; extensionAttribute1; extensionAttribute2; extensionAttribute3; extensionAttribute4; pager; manager; facSmileTelephoneNumber; otherHomePhone; info; mobile; msExchAssistantName; telephoneAssistant; description; homePhone; ").Split(';');

            DirectorySearcher ds = new DirectorySearcher();
            ds.SearchRoot = ADConnection();
            ds.SearchScope = SearchScope.Subtree;

            foreach (string s in propertiesToLoad)
            {
                ds.PropertiesToLoad.Add(s);
            }

            if (!object.Equals(ConfigurationManager.AppSettings["TestMode"], null))
            {
                if (ConfigurationManager.AppSettings["TestMode"].ToString() == "1")
                {
                    return null;
                }
            }

            ds.Filter = search;
            ADUserSelect adSel = null;
            if (ds.FindAll().Count > 0)
            {
                DirectoryEntry de = ds.FindOne().GetDirectoryEntry();

                // Cria o objeto do usuário...
                adSel = new ADUserSelect();

                adSel.Email = de.Properties["mail"].Value == null ? "" : de.Properties["mail"].Value.ToString();
                adSel.AssistantPhone = de.Properties["telephoneAssistant"].Value == null ? "" : de.Properties["telephoneAssistant"].Value.ToString();
                adSel.City = de.Properties["l"].Value == null ? "" : de.Properties["l"].Value.ToString();
                adSel.Company = de.Properties["company"].Value == null ? "" : de.Properties["company"].Value.ToString();
                adSel.Description = de.Properties["Description"].Value == null ? "" : de.Properties["Description"].Value.ToString();
                adSel.ExchAssistantName = de.Properties["msExchAssisantName"].Value == null ? "" : de.Properties["msExchAssisantName"].Value.ToString();
                adSel.Fax = de.Properties["facSmileTelephoneNumber"].Value == null ? "" : de.Properties["facSmileTelephoneNumber"].Value.ToString();
                adSel.FirstName = de.Properties["givenName"].Value == null ? "" : de.Properties["givenName"].Value.ToString();

                adSel.HomePhone = de.Properties["homePhone"].Value == null ? "" : de.Properties["homePhone"].Value.ToString();
                adSel.Info = de.Properties["info"].Value == null ? "" : de.Properties["info"].Value.ToString();
                adSel.LastName = de.Properties["sn"].Value == null ? "" : de.Properties["sn"].Value.ToString();
                adSel.Manager = de.Properties["manager"].Value == null ? "" : de.Properties["manager"].Value.ToString();
                adSel.Mobile = de.Properties["mobile"].Value == null ? "" : de.Properties["mobile"].Value.ToString();
                adSel.OfficeLocation = de.Properties["physicalDeliveryOfficeName"].Value == null ? "" : de.Properties["physicalDeliveryOfficeName"].Value.ToString();
                adSel.OtherHomePhone = de.Properties["otherHomePhone"].Value == null ? "" : de.Properties["otherHomePhone"].Value.ToString();
                adSel.OtherPhone = de.Properties["otherPhone"].Value == null ? "" : de.Properties["otherPhone"].Value.ToString();
                adSel.Pager = de.Properties["pager"].Value == null ? "" : de.Properties["pager"].Value.ToString();
                adSel.Phone = de.Properties["telephoneNumber"].Value == null ? "" : de.Properties["telephoneNumber"].Value.ToString();
                adSel.PostalCode = de.Properties["postalCode"].Value == null ? "" : de.Properties["postalCode"].Value.ToString();
                adSel.State = de.Properties["st"].Value == null ? "" : de.Properties["st"].Value.ToString();
                adSel.Street = de.Properties["l"].Value == null ? "" : de.Properties["l"].Value.ToString();
                adSel.Title = de.Properties["title"].Value == null ? "" : de.Properties["title"].Value.ToString();
                adSel.UserName = de.Properties["samAccountName"].Value == null ? "" : de.Properties["samAccountName"].Value.ToString();
                adSel.VOIP = new string[4];
                adSel.VOIP[0] = de.Properties["extensionAttribute1"].Value == null ? "" : de.Properties["extensionAttribute1"].Value.ToString();
                adSel.VOIP[1] = de.Properties["extensionAttribute2"].Value == null ? "" : de.Properties["extensionAttribute2"].Value.ToString();
                adSel.VOIP[2] = de.Properties["extensionAttribute3"].Value == null ? "" : de.Properties["extensionAttribute3"].Value.ToString();
                adSel.VOIP[3] = de.Properties["extensionAttribute4"].Value == null ? "" : de.Properties["extensionAttribute4"].Value.ToString();
            }

            return adSel;
        }

        public ADUserSelect GetUser(string UserName)
        {
            ADUserSelect userInfo = new ADUserSelect();
            string loginname = UserName;

            string URL = ConfigurationSettings.AppSettings.Get("FlexADURL") + "filter=(samaccountname=" + loginname + ")";// +"&ptl=displayname,sn,telephonenumber,mail";

            System.Net.WebClient webRequest = new System.Net.WebClient();
            byte[] requestedHTML = webRequest.DownloadData(URL);
            UTF8Encoding UTF8 = new UTF8Encoding();
            string RequestedHTMLUnicode = UTF8.GetString(requestedHTML);

            XmlDataDocument oXML = new XmlDataDocument();
            oXML.LoadXml(RequestedHTMLUnicode);

            XmlNodeList oNodes = oXML.SelectNodes("ResultSet/ADUserInfo");

            if (oNodes.Count == 0)
                return null;

            XmlNode oNode = oNodes.Item(0);


            userInfo.Email = oNode["mail"].InnerText;
            userInfo.FirstName = oNode["givenname"].InnerText;
            userInfo.LastName = oNode["sn"].InnerText;

            if (!object.Equals(ConfigurationManager.AppSettings["TestMode"], null))
            {
                if (ConfigurationManager.AppSettings["TestMode"].ToString() == "1")
                {
                    return userInfo;
                }
            }

            //Get manager
            ADUserSelect managerInformation = GetUser(userInfo.FirstName, userInfo.LastName, loginname);//Updated by Guoxin 2011-01-30
            userInfo.Manager = managerInformation.Manager;

            //userInfo.Manager = oNode["manager"].InnerText;

            //string search = string.Format("(&(objectClass=user)(samAccountName={0}))", UserName);
            //string[] propertiesToLoad = Convert.ToString("samAccountName; title; company; department; phisicalDeliveryOfficeName; st; l; streetAddress; postalCode; telephoneNumber; otherTelephone; extensionAttribute1; extensionAttribute2; extensionAttribute3; extensionAttribute4; pager; manager; facSmileTelephoneNumber; otherHomePhone; info; mobile; msExchAssistantName; telephoneAssistant; description; homePhone; ").Split(';');

            //DirectorySearcher ds = new DirectorySearcher();
            //ds.SearchRoot = ADConnection();
            //ds.SearchScope = SearchScope.Subtree;

            //foreach (string s in propertiesToLoad)
            //{
            //    ds.PropertiesToLoad.Add(s);
            //}

            //ds.Filter = search;
            //ADUserSelect adSel = null;
            //if (ds.FindAll().Count > 0)
            //{
            //    DirectoryEntry de = ds.FindOne().GetDirectoryEntry();

            //    // Cria o objeto do usuário...
            //    adSel = new ADUserSelect();

            //    adSel.Email = de.Properties["mail"].Value == null ? "" : de.Properties["mail"].Value.ToString();
            //    adSel.AssistantPhone = de.Properties["telephoneAssistant"].Value == null ? "" : de.Properties["telephoneAssistant"].Value.ToString();
            //    adSel.City = de.Properties["l"].Value == null ? "" : de.Properties["l"].Value.ToString();
            //    adSel.Company = de.Properties["company"].Value == null ? "" : de.Properties["company"].Value.ToString();
            //    adSel.Description = de.Properties["Description"].Value == null ? "" : de.Properties["Description"].Value.ToString();
            //    adSel.ExchAssistantName = de.Properties["msExchAssisantName"].Value == null ? "" : de.Properties["msExchAssisantName"].Value.ToString();
            //    adSel.Fax = de.Properties["facSmileTelephoneNumber"].Value == null ? "" : de.Properties["facSmileTelephoneNumber"].Value.ToString();
            //    adSel.FirstName = de.Properties["givenName"].Value == null ? "" : de.Properties["givenName"].Value.ToString();

            //    adSel.HomePhone = de.Properties["homePhone"].Value == null ? "" : de.Properties["homePhone"].Value.ToString();
            //    adSel.Info = de.Properties["info"].Value == null ? "" : de.Properties["info"].Value.ToString();
            //    adSel.LastName = de.Properties["sn"].Value == null ? "" : de.Properties["sn"].Value.ToString();
            //    adSel.Manager = de.Properties["manager"].Value == null ? "" : de.Properties["manager"].Value.ToString();
            //    adSel.Mobile = de.Properties["mobile"].Value == null ? "" : de.Properties["mobile"].Value.ToString();
            //    adSel.OfficeLocation = de.Properties["physicalDeliveryOfficeName"].Value == null ? "" : de.Properties["physicalDeliveryOfficeName"].Value.ToString();
            //    adSel.OtherHomePhone = de.Properties["otherHomePhone"].Value == null ? "" : de.Properties["otherHomePhone"].Value.ToString();
            //    adSel.OtherPhone = de.Properties["otherPhone"].Value == null ? "" : de.Properties["otherPhone"].Value.ToString();
            //    adSel.Pager = de.Properties["pager"].Value == null ? "" : de.Properties["pager"].Value.ToString();
            //    adSel.Phone = de.Properties["telephoneNumber"].Value == null ? "" : de.Properties["telephoneNumber"].Value.ToString();
            //    adSel.PostalCode = de.Properties["postalCode"].Value == null ? "" : de.Properties["postalCode"].Value.ToString();
            //    adSel.State = de.Properties["st"].Value == null ? "" : de.Properties["st"].Value.ToString();
            //    adSel.Street = de.Properties["l"].Value == null ? "" : de.Properties["l"].Value.ToString();
            //    adSel.Title = de.Properties["title"].Value == null ? "" : de.Properties["title"].Value.ToString();
            //    adSel.UserName = de.Properties["samAccountName"].Value == null ? "" : de.Properties["samAccountName"].Value.ToString();
            //    adSel.VOIP = new string[4];
            //    adSel.VOIP[0] = de.Properties["extensionAttribute1"].Value == null ? "" : de.Properties["extensionAttribute1"].Value.ToString();
            //    adSel.VOIP[1] = de.Properties["extensionAttribute2"].Value == null ? "" : de.Properties["extensionAttribute2"].Value.ToString();
            //    adSel.VOIP[2] = de.Properties["extensionAttribute3"].Value == null ? "" : de.Properties["extensionAttribute3"].Value.ToString();
            //    adSel.VOIP[3] = de.Properties["extensionAttribute4"].Value == null ? "" : de.Properties["extensionAttribute4"].Value.ToString();
            //}


            return userInfo;
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
