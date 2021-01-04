using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;

namespace Flex.APT.FrameWork.Contract.HttpClientRequest
{
    public interface IHttpClientRequest
    {
        HttpResponseMessage CallHttpClientPost(string serviceURI, string serializedObj, string token);
        HttpResponseMessage CallHttpClientGet(string serviceURI, string token);
    }
}
