using Dapper;
using Flex.APT.Application.Data_Contract.Master.Customer;
using Flex.APT.Application.Master.Customer;
using Flex.APT.Data.Common;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Flex.APT.Data.Master.Customer
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly IDbConnection dbConnection;
        public CustomerRepository(IConfiguration configuration)
        {
            dbConnection = new SqlConnection(configuration.GetConnectionString("APT"));
        }
        public List<CustomerDto> GetAllCustomer()
            => this.dbConnection.Query<CustomerDto>(SQLQuery.SP_GET_ALL_CUSTOMER, new DynamicParameters(), commandType: CommandType.StoredProcedure).ToList();
        
    }
}
