using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using KomplitWebApp.BPMReference;
using System.Data.Services.Client;
using System.Net;
using System.IO;
using System.Xml.Linq;
using System.Xml;


namespace KomplitWebApp
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    [ServiceBehavior(InstanceContextMode=InstanceContextMode.Single)]
    public class ContactService : IContactService
    {
        private static Uri serverUri = new Uri(" http://185.47.152.138:1423/0/ServiceModel/EntityDataService.svc/");
        private static readonly XNamespace ds = "http://schemas.microsoft.com/ado/2007/08/dataservices";
        private static readonly XNamespace dsmd = "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata";
        private static readonly XNamespace atom = "http://www.w3.org/2005/Atom"; 

        //request

        public IEnumerable<Contact> GetContacts()
        {
                WebOperationContext.Current.OutgoingResponse.Headers.Add("Cache-Control", "no-cache");
                var context = new BPMonline(serverUri);
                context.SendingRequest += new EventHandler<SendingRequestEventArgs>(OnSendingRequestCookie);
                int ContactCollectionLenght = context.ContactCollection.Count();
                return from o in context.ContactCollection.Take(ContactCollectionLenght)
                       select new Contact()
                       {
                           Name = o.Name,
                           Dear = o.Dear,
                           BirthDate = o.BirthDate.Value.ToShortDateString(),
                           JobTitle = o.JobTitle,
                           MobilePhone = o.MobilePhone,
                           Id = o.Id
                       };
        }
        //update
       public bool UpdateContact(Contact contact)
        {
            try
            {
                string contactId = contact.Id.ToString();
                var content = new XElement(dsmd + "properties",
                                  new XElement(ds + "Name", contact.Name),
                                  new XElement(ds + "Dear", contact.Dear),
                                  new XElement(ds + "JobTitle", contact.JobTitle),
                                  new XElement(ds + "MobilePhone", contact.MobilePhone),
                                  new XElement(ds + "BirthDate", (DateTime?)Convert.ToDateTime(contact.BirthDate)));
                var entry = new XElement(atom + "entry",
                        new XElement(atom + "content",
                                new XAttribute("type", "application/xml"),
                                content)
                        );

                var request = (HttpWebRequest)HttpWebRequest.Create(serverUri
                        + "ContactCollection(guid'" + contactId + "')");
                request.Credentials = new NetworkCredential("Supervisor", "Supervisor");
                request.Method = "PUT";
                request.Accept = "application/atom+xml";
                request.ContentType = "application/atom+xml;type=entry";

                using (var writer = XmlWriter.Create(request.GetRequestStream()))
                {
                    entry.WriteTo(writer);
                }

                using (WebResponse response = request.GetResponse())
                {
                    return true;
                }
            }
           catch(Exception e)
            {
                return false;
            }
        }
        //delete
        public bool DeleteContact(string personId)
        {
            try
            {
                string contactId = personId;
                var request = (HttpWebRequest)HttpWebRequest.Create(serverUri
                        + "ContactCollection(guid'" + contactId + "')");
                request.Credentials = new NetworkCredential("Supervisor", "Supervisor");
                request.Method = "DELETE";

                using (WebResponse response = request.GetResponse())
                {
                    response.ToString();
                    return true;
                }
            }
            catch(Exception e)
            {
                return false;
            }
        }
        //create
        public bool CreateContact(Contact contact)
        {
            try
            {
                var content = new XElement(dsmd + "properties",
                  new XElement(ds + "Name", contact.Name),
                  new XElement(ds + "Dear", contact.Dear),
                  new XElement(ds + "JobTitle", contact.JobTitle),
                  new XElement(ds + "MobilePhone", contact.MobilePhone),
                  new XElement(ds + "BirthDate", (DateTime?)Convert.ToDateTime(contact.BirthDate)));
                var entry = new XElement(atom + "entry",
                            new XElement(atom + "content",
                            new XAttribute("type", "application/xml"), content));

                var request = (HttpWebRequest)HttpWebRequest.Create(serverUri + "ContactCollection/");
                request.Credentials = new NetworkCredential("Supervisor", "Supervisor");
                request.Method = "POST";
                request.Accept = "application/atom+xml";
                request.ContentType = "application/atom+xml;type=entry";

                using (var writer = XmlWriter.Create(request.GetRequestStream()))
                {
                    entry.WriteTo(writer);
                }

                using (WebResponse response = request.GetResponse())
                {
                    if (((HttpWebResponse)response).StatusCode == HttpStatusCode.Created)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            catch(Exception e)
            {
                return false;
            }
        }
        static void OnSendingRequestCookie(object sender, SendingRequestEventArgs e)
        {

            LoginClass.TryLogin("Пользователь 1", "Пользователь 1");
            var req = e.Request as HttpWebRequest;
            req.CookieContainer = LoginClass.AuthCookie;
            e.Request = req;
        }
        
    }
}
