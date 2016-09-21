using System;
using System.Collections.Generic;
using System.Data.Services.Client;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using KomplitWebApp.BPMReference;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;

namespace KomplitWebApp
{
    public class LoginClass
    {
        public const string authServiceUri = "http://185.47.152.138:1423/ServiceModel/AuthService.svc/Login";
        public static CookieContainer AuthCookie = new CookieContainer();
        public static bool TryLogin(string userName, string userPassword)
        {
            var authRequest = HttpWebRequest.Create(authServiceUri) as HttpWebRequest;
            authRequest.Method = "POST";
            authRequest.ContentType = "application/json";
            authRequest.CookieContainer = AuthCookie;
            using (var requesrStream = authRequest.GetRequestStream())
            {
                using (var writer = new StreamWriter(requesrStream))
                {
                    writer.Write(@"{
                ""UserName"":""" + userName + @""",
                ""UserPassword"":""" + userPassword + @"""
            }");
                }
            }
            using (var response = (HttpWebResponse)authRequest.GetResponse())
            {
                if (AuthCookie.Count > 0)
                {
                    return true;
                }
            }
            return false;
        }


    }
}