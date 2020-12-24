using Flex.APT.FrameWork.Exceptions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

namespace Flex.APT.Api.Common
{
    public class ExceptionFilter : ExceptionFilterAttribute
    {
        /// <summary>
        /// On exception catch event.
        /// </summary>
        /// <param name="context">Current context.</param>
        public override void OnException(ExceptionContext context)
        {
            HttpStatusCode status;
            string message;
            if (context.Exception is BaseBusinessException)
            {
                Log.Error(context.Exception.GetBaseException().ToString());
                status = HttpStatusCode.BadRequest;
                message = context.Exception.Message;
            }
            else
            {
                Log.Error(context.Exception.GetBaseException().ToString());
                status = HttpStatusCode.InternalServerError;
                message = "Internal server error. Please contact administrator or IT team for help.";
            }
            context.Result = new JsonResult(message);
            context.HttpContext.Response.StatusCode = (int)status;
        }
    }
}
