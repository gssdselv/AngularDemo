using System;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Common;

namespace Fit.Base
{
    /// <summary>
    /// The membership provider used for TestStrategySurvey.
    /// </summary>
    public class BaseMembershipProvider : MembershipProvider
    {

        #region Constants

        #region Statements

        /// <summary>
        /// String containing the name of the maintenance procedure.
        /// </summary>
        private const string maintenanceProcedure = "SP_FIT_MAINTENANCE_USERS";
        private Database db = DatabaseFactory.CreateDatabase("d_PTConnectionString");

        #endregion

        #endregion

        #region Attributes

        private string applicationName;

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

        public override bool EnablePasswordReset
        {
            get
            {
                return false;
            }
        }

        public override bool EnablePasswordRetrieval
        {
            get
            {
                return false;
            }
        }

        public override int MaxInvalidPasswordAttempts
        {
            get
            {
                return 0;
            }
        }

        public override int MinRequiredNonAlphanumericCharacters
        {
            get
            {
                return 0;
            }
        }

        public override int MinRequiredPasswordLength
        {
            get
            {
                return 0;
            }
        }

        public override bool RequiresQuestionAndAnswer
        {
            get
            {
                return false;
            }
        }

        public override int PasswordAttemptWindow
        {
            get
            {
                return 0;
            }
        }

        public override MembershipPasswordFormat PasswordFormat
        {
            get
            {
                return MembershipPasswordFormat.Clear;
            }
        }

        public override string PasswordStrengthRegularExpression
        {
            get
            {
                return "";
            }
        }

        public override bool RequiresUniqueEmail
        {
            get
            {
                return false;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Create a new MembershipUser.
        /// </summary>
        /// <param name="userName">The username to be created.</param>
        /// <param name="isAdmin">The admin flag.</param>
        /// <returns>The user created.</returns>
        public BaseMembershipUser CreateUser(string userName, bool isAdmin)
        {
            throw new Exception("This method didn´t go implemented");
        }

        /// <summary>
        /// Create a new MembershipUser.
        /// </summary>
        /// <param name="userName">The username to be created.</param>
        /// <param name="isAdmin">The admin flag.</param>
        /// <returns>The user created.</returns>
        public void CreateUser(MembershipUser user)
        {

            BaseMembershipUser u = (BaseMembershipUser)user;
            // Create a Command
            DbCommand dbc = db.GetSqlStringCommand("INSERT INTO TB_PT_PU_USERS "+
                                                    " (PU_USUARIO,PU_ATIVO,PU_NAME,PU_EMAIL,PI_CODIGO,PU_IS_ADMIN) "+
                                                    " VALUES(@USERNAME,@PU_ATIVO,@PU_NAME,@EMAIL,@LANGUAGE,@ISADMIN) ");
            
            
            // Set the parameters..
            db.AddInParameter(dbc,"@USERNAME",DbType.String,u.UserName);
            db.AddInParameter(dbc,"@PU_ATIVO",DbType.Boolean,!u.IsLockedOut);
            db.AddInParameter(dbc,"@PU_NAME",DbType.String,u.Name);
            db.AddInParameter(dbc,"@EMAIL",DbType.String,u.Email);
            db.AddInParameter(dbc,"@LANGUAGE",DbType.String,u.Language);
            db.AddInParameter(dbc,"@ISADMIN",DbType.String,u.IsAdmin);
                       
            
            // Execute the command...
            try
            {
                db.ExecuteNonQuery(dbc);
            }
            catch (DbException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }           
            
        }


        /// <summary>
        /// Get all the users in the system.
        /// </summary>
        /// <returns>A collection of users.</returns>
        public MembershipUserCollection GetAllUsers()
        {
            // Create a collection...
            MembershipUserCollection list = new MembershipUserCollection();
            // Create a new Command
            DbCommand dbc = db.GetSqlStringCommand("SELECT * FROM TB_PT_PU_USERS ORDER BY PU_NAME");
            // Set the parameters..

            IDataReader reader = db.ExecuteReader(dbc);
            try
            {
                while (reader.Read())
                {
                    BaseMembershipUser user = new BaseMembershipUser(reader.GetString(0), reader.GetBoolean(7), false, reader.GetString(5),
                        reader.GetString(2), reader.GetString(2), true, reader.GetBoolean(2));
                    list.Add(user);
                }
                // Return the list...
            }
            catch (DbException)
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
                throw new Exception("Error when try list the users.");
            }
            return list;
        }

        /// <summary>
        /// Get all the users in the system.
        /// </summary>
        /// <returns>A collection of users.</returns>
        public List<BaseMembershipUser> GetUsersList()
        {
            // Create a collection...
            List<BaseMembershipUser> list = new List<BaseMembershipUser>();
            // Create a new Command
            DbCommand dbc = db.GetSqlStringCommand("SELECT * FROM TB_PT_PU_USERS ORDER BY PU_NAME");
            // Set the parameters..

            IDataReader reader = db.ExecuteReader(dbc);
            try
            {
                while (reader.Read())
                {
                    BaseMembershipUser user = new BaseMembershipUser(reader.GetString(0), reader.GetBoolean(7), false, reader.GetString(5),
                        reader.GetString(2), reader.GetString(2), true, reader.GetBoolean(2));
                    list.Add(user);
                }
                // Return the list...
            }
            catch (DbException)
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
                throw new Exception("Error when try list the users.");
            }
            return list;
        }

        /// <summary>
        /// Get a specific user in the system.
        /// </summary>
        /// <param name="userName">The username that you want to find.</param>
        /// <returns>A membershipuser object.</returns>
        public MembershipUser GetUser(string userName)
        {
            // Create a collection...
            BaseMembershipUser user = null;
            // Create a new Command
            DbCommand dbc = db.GetSqlStringCommand("SELECT PU_USUARIO,PU_ATIVO,PU_NAME,PU_LAST_LOGIN,PU_LAST_ACTICITY,PU_EMAIL,PI_CODIGO,PU_IS_ADMIN FROM TB_PT_PU_USERS WHERE PU_USUARIO = @PU_USUARIO");
            // Set the parameters..

            db.AddInParameter(dbc, "@PU_USUARIO", DbType.String,userName);

            IDataReader reader = db.ExecuteReader(dbc);
            try
            {
                if (reader.Read())
                {
                    user = new BaseMembershipUser(reader.GetString(0), reader.GetBoolean(7), false, reader.GetString(5),
                        reader.GetString(2), reader.GetString(6), reader.GetBoolean(1), !reader.GetBoolean(1));
                }
                else
                {
                    user = new BaseMembershipUser(userName, false, true, string.Empty, "Guest User", "en-US", true, false);
                }
                // Return the list...
            }
            catch (DbException)
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
                throw new Exception("Error when try list the users.");
            }
            return user;
        }

        /// <summary>
        /// Delete the user.
        /// </summary>
        /// <param name="userName">The username that you want to delete.</param>
        /// <returns>A boolean indicating if user is deleted or not.</returns>
        public bool DeleteUser(string userName)
        {
            // Prepare statement
            string sqlDeleteUser = "DELETE FROM TB_PT_PU_USERS WHERE PU_USUARIO = @PU_USUARIO";

            // Create Command
            DbCommand dbc = db.GetSqlStringCommand(sqlDeleteUser);            

            // Set the parameters..
            db.AddInParameter(dbc, "@PU_USUARIO", DbType.String, userName);
            

            // Execute the command...
            try
            {
                db.ExecuteNonQuery(dbc);
            }
            catch (DataException)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Delete the user.
        /// </summary>
        /// <param name="user">The user that you want to delete.</param>
        /// <returns>A boolean indicating if user is deleted or not.</returns>
        public bool DeleteUser(BaseMembershipUser user)
        {
            // Prepare statement
            string sqlDeleteUser = "DELETE FROM TB_PT_PU_USERS WHERE PU_USUARIO = @PU_USUARIO";

            // Create Command
            DbCommand dbc = db.GetSqlStringCommand(sqlDeleteUser);

            // Set the parameters..
            db.AddInParameter(dbc, "@PU_USUARIO", DbType.String, user.UserName);


            // Execute the command...
            try
            {
                db.ExecuteNonQuery(dbc);
            }
            catch (DataException)
            {
                return false;
            }
            return true;
        }

        public void UpdateUser(BaseMembershipUser user)
        {
            UpdateUser(user);
        }

        #endregion

        #region Inherited Methods

        public override void Initialize(string name, NameValueCollection config)
        {
            if (String.IsNullOrEmpty(name))
            {
                name = "SurveyMembershipProvider";
            }
            if (String.IsNullOrEmpty(config["description"]))
            {
                config.Remove("description");
                config.Add("description", "Test Strategy Survey Membership Provider");
            }
            // Call the initializer from abstract class...
            base.Initialize(name, config);
        }

        public override MembershipUser CreateUser(string username, string password, string email, string passwordQuestion, string passwordAnswer, bool isApproved, object providerUserKey, out MembershipCreateStatus status)
        {
            MembershipUser newUser = null;
            // Try to create a user...
            try
            {
                newUser = CreateUser(username, false);
                // Set the status to success...
                status = MembershipCreateStatus.Success;
            }
            catch (DataException)
            {
                // Set the status to error...
                status = MembershipCreateStatus.ProviderError;
                return null;
            }
            return newUser;
        }

        public override void UpdateUser(MembershipUser user)
        {
            // Cast to a custom MemberShipUser
            BaseMembershipUser updateUser = user as BaseMembershipUser;
            
            //Create a Statement
            string sqlUpdateUser = "UPDATE TB_PT_PU_USERS " +
                                    " SET    PU_ATIVO = @PU_ATIVO, " +
                                            "PU_NAME = @PU_NAME, " +
                                            "PU_EMAIL = @PU_EMAIL, " +
                                            "PI_CODIGO = @PI_CODIGO, " +
                                            "PU_IS_ADMIN = @PU_IS_ADMIN " +
                                            "PU_LAST_LOGIN = @PU_LAST_LOGIN" +
                                            "PU_LAST_ACTICITY = @PU_LAST_ACTICITY"+
                                    " WHERE PU_USUARIO = @PU_USUARIO";

            // Create a command 
            DbCommand dbc = db.GetSqlStringCommand(sqlUpdateUser);

            // Set the parameters..
            db.AddInParameter(dbc, "@PU_ATIVO", DbType.Boolean, !updateUser.IsLockedOut);
            db.AddInParameter(dbc, "@PU_NAME", DbType.String, updateUser.Name);
            db.AddInParameter(dbc, "@PU_EMAIL", DbType.String, updateUser.Email);
            db.AddInParameter(dbc, "@PI_CODIGO", DbType.String, updateUser.Language);
            db.AddInParameter(dbc, "@PU_IS_ADMIN", DbType.String, updateUser.IsAdmin);
            db.AddInParameter(dbc, "@PU_LAST_LOGIN", DbType.DateTime, user.LastLoginDate);
            db.AddInParameter(dbc, "@PU_LAST_ACTICITY", DbType.DateTime, updateUser.LastActivityDate);
            db.AddInParameter(dbc, "@PU_USUARIO", DbType.String, updateUser.IsLockedOut);

            // Execute the command...
            try
            {
                db.ExecuteNonQuery(dbc);
            }
            catch (DataException ex)
            {
                throw ex;
            }
        }

        public override bool ValidateUser(string username, string password)
        {
            //GEt the user
            MembershipUser user = GetUser(username.ToLower());
            bool isValid = false;
            //if is a valid user
            if (user != null)
            {
                //Verifies if he is approved
                if (!user.IsApproved || user.IsLockedOut)
                    isValid = false;
                else
                    isValid = true;
            }

            return (isValid);
        }

        #endregion

        #region Non Implemented Inherited Methods

        public override bool ChangePassword(string username, string oldPassword, string newPassword)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override bool ChangePasswordQuestionAndAnswer(string username, string password, string newPasswordQuestion, string newPasswordAnswer)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override MembershipUserCollection FindUsersByEmail(string emailToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override int GetNumberOfUsersOnline()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string GetPassword(string username, string answer)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string GetUserNameByEmail(string email)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string ResetPassword(string username, string answer)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override MembershipUserCollection FindUsersByName(string usernameToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override MembershipUser GetUser(object providerUserKey, bool userIsOnline)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override bool UnlockUser(string userName)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override bool DeleteUser(string username, bool deleteAllRelatedData)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override MembershipUserCollection GetAllUsers(int pageIndex, int pageSize, out int totalRecords)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override MembershipUser GetUser(string username, bool userIsOnline)
        {
            return GetUser(username);
        }


        #endregion

    }
}
