using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Flex.APT.Api.Controllers.Master.Category
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : APTBaseController
    {
        //[HttpGet, AllowAnonymous]
        //public List<CategoryDto> GetAllCatrgory()
        //    => Mediator.Send(new GetAllCategoryQuery()).Result.ToList();
    }
}