using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Flex.APT.Api.Controllers.Master.Segment
{
    [Route("api/[controller]")]
    [ApiController]
    public class SegmentController : APTBaseController
    {
        //[HttpGet, AllowAnonymous]
        //public List<SegmentDto> GetAllSegment()
        //    => Mediator.Send(new GetAllSegmentQuery()).Result.ToList();
    }
}