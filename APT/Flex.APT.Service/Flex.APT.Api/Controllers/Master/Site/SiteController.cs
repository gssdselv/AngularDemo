using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Flex.APT.Api.Controllers.Master.Site
{
    [Route("api/[controller]")]
    [ApiController]
    public class SiteController : APTBaseController
    {
        //[HttpGet, AllowAnonymous]
        //public List<SiteDto> GetAllSite()
        //    => Mediator.Send(new GetAllSiteQuery()).Result.ToList();
    }
}