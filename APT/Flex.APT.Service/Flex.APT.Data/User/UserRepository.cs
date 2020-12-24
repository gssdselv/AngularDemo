using Dapper;
using Flex.APT.Application.Data_Contract.User;
using Flex.APT.Application.User.GetUserDetail;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Linq;
using System.Threading.Tasks;

namespace Flex.APT.Data.User
{
    public class UserRepository : IUserRepository
    {
        private readonly IDbConnection dbConnection;
        public UserRepository(IConfiguration configuration)
        {
            dbConnection = new SqlConnection(configuration.GetConnectionString("APT"));
        }
        public List<UserDetailDto> GetUserDetail(GetUserQuery request)
        {
            return this.dbConnection.Query<UserDetailDto>("GetUserDetail", new DynamicParameters(),commandType: CommandType.StoredProcedure).ToList();
        }
    }
}
