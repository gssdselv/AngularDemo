using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Flex.APT.Application.User.GetUserDetail;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Flex.APT.Api.Controllers.User
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class UserController : APTBaseController
    {
        [HttpGet, AllowAnonymous]
        public List<UserDetailDto> GetUserDetail(string userEmail)
        {
            return Mediator.Send(new GetUserQuery(userEmail)).Result.ToList();
        }
    }
}