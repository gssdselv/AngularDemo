using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Fit.Base
{
    /// <summary>
    /// The MembershipUser for TestStrategySurvey.
    /// </summary>
    public class BaseMembershipUser : MembershipUser
    {

        #region Attributes

        private bool isAdmin;
        private bool isGuest;
        private string name;
        private string language;        

        #endregion

        #region Properties

        /// <summary>
        /// The flag indicating if the user is a system admin or not.
        /// </summary>
        public bool IsAdmin
        {
            get { return isAdmin; }
            set { isAdmin = value; }
        }
        public bool IsGuest
        {
            get { return isGuest; }
            set { isGuest = value; }
        }
        public string Name
        {
          get { return name; }
          set { name = value; }
        }
        public string Language
        {
          get { return language; }
          set { language = value; }
        }
        

        #endregion

        #region Constructor

        /// <summary>
        /// Create a new SurveyMembershipUser.
        /// </summary>
        /// <param name="userName">The username that is created.</param>
        /// <param name="isAdmin">The flag indicating if it is admin or not.</param>
        public BaseMembershipUser(string userName, bool isAdmin, bool isGuest, string email, string name, string language, bool isAproved, bool isLocked)
            : base(Membership.Provider.Name, userName, null, email, "", "", isAproved, isLocked, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.Now)
        {
            this.isAdmin = isAdmin;
            this.isGuest = isGuest;
            this.name = name;
            this.language = language;
        }

        #endregion

    }
}
