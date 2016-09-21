using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace KomplitWebApp
{
    [ServiceContract(Namespace="Komplit")]
    public interface IContactService
    {
       [OperationContract]
        [WebGet(ResponseFormat=WebMessageFormat.Json)]
        IEnumerable<Contact> GetContacts();

       [OperationContract]
        [WebInvoke(Method="POST", RequestFormat=WebMessageFormat.Json)]
        bool UpdateContact(Contact person);

      [OperationContract]
        [WebInvoke(Method="POST")]
        bool DeleteContact(string personId);

      [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json)]
        bool CreateContact(Contact person);
    }
}

