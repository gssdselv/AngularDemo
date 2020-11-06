using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Data.OleDb;
using Microsoft.Practices.EnterpriseLibrary.Data;
using System.Data.Common;

namespace Library
{
    public class Excel
    {
        Database db; 

        public Excel(Database db)
        {
            this.db = db;            
        }
        public static DataTable GetData(string connectionString,string regionRead)
        {
            //Initialize a DataTable 
            DataTable tb = new DataTable();
            
            
            //Initialize Connection 
            OleDbConnection conn = new OleDbConnection(connectionString);

            //Initialize Command
            OleDbCommand cmd = new OleDbCommand(String.Format("SELECT * FROM {0}",regionRead), conn);

            
            //Open connection
            conn.Open();
            //Create a new command with a query
            IDataReader dtr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            tb.Load(dtr);
        

              
            
            //Read Excel File
            
                        
            return tb;

 
        }
    }
}
