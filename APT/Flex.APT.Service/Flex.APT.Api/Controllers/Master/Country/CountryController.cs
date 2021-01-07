using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Flex.APT.Api.Controllers.Master.Country
{
    [Route("api/[controller]")]
    [ApiController]
    public class CountryController : APTBaseController
    {
        //[HttpGet, AllowAnonymous]
        //public List<CountryDto> GetAllCountry()
        //    => Mediator.Send(new GetAllCountryQuery()).Result.ToList();
    }
}