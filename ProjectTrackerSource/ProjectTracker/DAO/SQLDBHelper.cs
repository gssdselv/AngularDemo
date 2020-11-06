using System;
using System.Collections.Generic;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ProjectTracker.DAO
{
    public class SQLDBHelper
    {
        private readonly string connString = string.Empty;
        private const string ConnStrKey = "d_PTConnectionString";

        public SQLDBHelper()
        {
            object obj = ConfigurationManager.ConnectionStrings[ConnStrKey];
            if (!object.Equals(obj, null))
            {
                connString = obj.ToString();
            }
            else
            {
                connString = string.Empty;
            }
        }

        public DataSet Query(string sql, SqlParameter[] paramArr)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    if (!object.Equals(paramArr, null))
                    {
                        foreach (SqlParameter param in paramArr)
                        {
                            cmd.Parameters.Add(param);
                        }
                    }
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    cmd.Parameters.Clear();
                }
                finally
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
            return ds;
        }

        public DataSet QueryBySP(string sp, SqlParameter[] paramArr)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sp, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (!object.Equals(paramArr, null))
                    {
                        foreach (SqlParameter param in paramArr)
                        {
                            cmd.Parameters.Add(param);
                        }
                    }
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    cmd.Parameters.Clear();
                }
                finally
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
            return ds;
        }

        public void ExecuteSQL(string sql, SqlParameter[] paramArr)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    if (!object.Equals(paramArr, null))
                    {
                        foreach (SqlParameter param in paramArr)
                        {
                            cmd.Parameters.Add(param);
                        }
                    }
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
        }

        public void ExecuteSQLBySP(string sp, SqlParameter[] paramArr)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sp, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (!object.Equals(paramArr, null))
                    {
                        foreach (SqlParameter param in paramArr)
                        {
                            cmd.Parameters.Add(param);
                        }
                    }
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
        }

        public object GetSingle(string sql, SqlParameter[] paramArr)
        {
            object obj = null;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql.Replace("'", ""), conn);
                    if (!object.Equals(paramArr, null))
                    {
                        foreach (SqlParameter param in paramArr)
                        {
                            cmd.Parameters.Add(param);
                        }
                    }
                    obj = cmd.ExecuteScalar();
                }
                finally
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
            return obj;
        }

        public bool Exists(string sql, SqlParameter[] paramArr)
        {
            object obj = GetSingle(sql, paramArr);
            if (object.Equals(obj, null)) return false;
            if (object.Equals(obj, DBNull.Value)) return false;
            int temp = System.Convert.ToInt32(obj);
            if (temp > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public int ExecuteSqlTran(List<CommandInfo> cmdList)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                SqlTransaction tx = conn.BeginTransaction();
                cmd.Transaction = tx;
                try
                {
                    int intCount = 0;
                    foreach (CommandInfo cmdInfo in cmdList)
                    {
                        cmd.CommandText = cmdInfo.CmdText.Replace("'", "");
                        if (!object.Equals(cmdInfo.ParamArr, null))
                        {
                            foreach (SqlParameter param in cmdInfo.ParamArr)
                            {
                                cmd.Parameters.Add(param);
                            }
                        }
                        intCount += cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                    }
                    tx.Commit();
                    return intCount;
                }
                catch 
                {
                    tx.Rollback();
                    throw ;
                }
                finally
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
        }
    }

    public class CommandInfo
    {
        public string CmdText = string.Empty;
        public SqlParameter[] ParamArr = null;

        public CommandInfo(string cmd_text, SqlParameter[] param_arr)
        {
            CmdText = cmd_text;
            ParamArr = param_arr;
        }
    }
}
