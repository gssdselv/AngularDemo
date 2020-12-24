using Flex.APT.Application.User.GetUserDetail;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Flex.APT.Application.Data_Contract.User
{
    public interface IUserRepository
    {
        List<UserDetailDto> GetUserDetail(GetUserQuery request);
    }
}
