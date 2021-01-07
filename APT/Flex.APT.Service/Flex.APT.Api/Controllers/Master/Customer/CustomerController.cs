using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Flex.APT.Application.Master.Customer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Flex.APT.Api.Controllers.Master.Customer
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomerController : APTBaseController
    {
        [HttpGet, AllowAnonymous]
        public List<CustomerDto> GetAllCustomer()
            => Mediator.Send(new GetAllCustomerQuery()).Result.ToList();
    }
}