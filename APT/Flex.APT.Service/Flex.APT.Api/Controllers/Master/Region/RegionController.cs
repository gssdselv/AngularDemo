using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Flex.APT.Api.Controllers.Master.Region
{
    [Route("api/[controller]")]
    [ApiController]
    public class RegionController : APTBaseController
    {
        //[HttpGet, AllowAnonymous]
        //public List<RegionDto> GetAllRegion()
        //    => Mediator.Send(new GetAllRegionQuery()).Result.ToList();
    }
}