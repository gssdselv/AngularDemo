using Microsoft.Security.Application;
using System;
using System.Security.Cryptography;

namespace ProjectTracker.Common
{
    public class CheckmarxHelper
    {
        /// <summary>
        /// Escapes the LDAP search filter to prevent LDAP injection attacks.
        /// Pre-requisite: Please add the following nuget package: AntiXss v4.3.0
        /// </summary>
        /// <param name="searchFilter">The search filter.</param>
        /// <see cref="http://msdn.microsoft.com/en-us/library/aa746475.aspx" />
        /// <returns>The escaped search filter.</returns>
        public static string EscapeLdapSearchFilter(string searchFilter)
        {
            return Encoder.LdapFilterEncode(searchFilter);
        }

        public static string EscapeReflectedXss(string inputString)
        {
            return Encoder.HtmlEncode(inputString);
        }

        public static string CryptoRandomString()
        {
            string cryptRandom = string.Empty;
            using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
            {
                // Buffer storage.
                byte[] data = new byte[4];
                // Fill buffer.
                rng.GetBytes(data);
                // Convert to int.
                Int32 value = BitConverter.ToInt32(data, 0);
                if (value < 0) value = -value;
                cryptRandom = value.ToString();
            }
            return cryptRandom;
        }
    }
}