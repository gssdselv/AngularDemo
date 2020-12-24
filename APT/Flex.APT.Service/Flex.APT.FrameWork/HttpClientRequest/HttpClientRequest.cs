using Flex.APT.FrameWork.Contract.HttpClientRequest;
using Flex.APT.FrameWork.Resources;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;

namespace Flex.APT.FrameWork.HttpclientRequest
{
    public class HttpClientRequest : IHttpClientRequest
    {
        public HttpResponseMessage CallHttpClientPost(string serviceURI, string serializedObj, string token)
        {
            using (HttpClient httpClient = new HttpClient())
            {
                SetToken(httpClient, token);
                HttpContent content = SetParams(serializedObj);
                httpClient.Timeout = TimeSpan.FromMinutes(5);
                return httpClient.PostAsync(serviceURI, content).Result;
            }
        }

        public HttpResponseMessage CallHttpClientGet(string serviceURI, string token)
        {
            using (HttpClient httpClient = new HttpClient())
            {
                SetToken(httpClient, token);
                httpClient.Timeout = TimeSpan.FromMinutes(5);
                return httpClient.GetAsync(serviceURI).Result;
            }
        }
        private void SetToken(HttpClient httpClient, string token)
        {
            token.When(() => !String.IsNullOrEmpty(token), () => httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + token));
        }
        private HttpContent SetParams(string serializedObj)
        {
            if (!String.IsNullOrEmpty(serializedObj))
            {
                return new StringContent(serializedObj, Encoding.UTF8, "application/json");
            }
            return null;
        }
    }
}
