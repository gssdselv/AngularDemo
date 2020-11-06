using System;
using System.Data.SqlClient;
using System.Data;

namespace EmailComponent
{
    public class GetEmailIdsFromDB
    {
        public string ConnectionString
        {
            get;
            set;
        }
        public string StoredProcName
        {
            get;
            set;
        }
        public DataSet GetMailIds()
        {
            try
            {
                DataSet ds = new DataSet();
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    SqlCommand command = new SqlCommand(StoredProcName, conn);
                    command.CommandType = CommandType.StoredProcedure;

                    SqlDataAdapter sda = new SqlDataAdapter(command);
                    sda.Fill(ds);
                }
                return ds;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
