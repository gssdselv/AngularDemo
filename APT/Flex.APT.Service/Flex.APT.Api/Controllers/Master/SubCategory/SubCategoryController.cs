using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Flex.APT.Api.Controllers.Master.SubCategory
{
    [Route("api/[controller]")]
    [ApiController]
    public class SubCategoryController : APTBaseController
    {
        //[HttpGet, AllowAnonymous]
        //public List<SubCategoryDto> GetAllSubCategory()
        //    => Mediator.Send(new GetAllSubCategoryQuery()).Result.ToList();
    }
}