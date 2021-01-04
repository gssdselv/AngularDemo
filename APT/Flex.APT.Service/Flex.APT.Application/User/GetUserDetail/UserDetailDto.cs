using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.Application.User.GetUserDetail
{
    public class UserDetailDto
    {
        public long UserId { get; set; }
        public string UserAdid { get; set; }
        public string Email { get; set; }
        public string FullName { get; set; }
    }
}
