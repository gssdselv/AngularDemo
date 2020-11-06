using System.Web.Security;
using System.Configuration.Provider;
using System.Collections.Specialized;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Diagnostics;
using System.Web;
using System.Globalization;
using System.Collections;

namespace Fit.Base
{

    public sealed class BaseRoleProvider : RoleProvider
    {
        
        #region Attributes

        private string applicationName;

        private string[] existingRoles = new string[] { "ADM", "NOR", "GUEST" };

        #endregion

        #region Non Implemented Inherited Methods

        public override void AddUsersToRoles(string[] usernames, string[] roleNames)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override bool DeleteRole(string roleName, bool throwOnPopulatedRole)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override void RemoveUsersFromRoles(string[] usernames, string[] roleNames)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string[] FindUsersInRole(string roleName, string usernameToMatch)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string[] GetUsersInRole(string roleName)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override void CreateRole(string roleName)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string[] GetAllRoles()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        #endregion

        #region Inherited Properties

        public override string ApplicationName
        {
            get
            {
                return this.applicationName;
            }
            set
            {
                this.applicationName = value;
            }
        }

        #endregion

        #region Inherited Methods

        public override void Initialize(string name, NameValueCollection config)
        {
            if (String.IsNullOrEmpty(name))
            {
                name = "BaseMembershipProvider";
            }
            if (String.IsNullOrEmpty(config["description"]))
            {
                config.Remove("description");
                config.Add("description", "Project Tracker Membership Provider");
            }
            // Call the initializer from abstract class...
            base.Initialize(name, config);
        }

        public override bool IsUserInRole(string username, string roleName)
        {
            string[] userDomain = username.Split('\\');
            username = userDomain[userDomain.Length - 1];            
            // Get the user...            
            string[] roles = GetRolesForUser(username);
            // Verify if it exist...
            foreach (string value in roles)
            {
                if (value.ToUpper() == roleName.ToUpper())
                    return true;
            }
            return false;
        }

        public override string[] GetRolesForUser(string username)
        {
            string[] userDomain = username.Split('\\');
            username = userDomain[userDomain.Length - 1];
            // Get the user...
            BaseMembershipUser user = ((Membership.Provider as BaseMembershipProvider).GetUser(username) as BaseMembershipUser);
            // Verify if user has roles..
            if (user != null)
            {
                // Get their roles..
                if (user.IsAdmin)
                {                    
                    return new string[1] { "ADM" };
                }
                else if (user.IsGuest)
                {                   
                    return new string[1] { "GUEST" };
                }
                else
                {                    
                    return new string[1] { "NOR" };
                }
            }            
            return new string[1] { "" };
        }

        public override bool RoleExists(string roleName)
        {
            return Array.IndexOf<string>(existingRoles, roleName.ToUpper()) > -1;
        }

        #endregion

    }

    
}