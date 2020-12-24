using MediatR;
using System;
using System.Collections.Generic;
using System.Text;

namespace Flex.APT.Application.User.GetUserDetail
{
    public class GetUserQuery : IRequest<List<UserDetailDto>>
    {
        public string UserEmail { get; }
        public GetUserQuery(string UserEmail)
        {
            this.UserEmail = UserEmail;
        }
    }
}
