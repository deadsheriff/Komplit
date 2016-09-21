using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Runtime.Serialization;

namespace KomplitWebApp
{
    [DataContract]
    public class Contact
    {
        [DataMember]
        public Guid Id { get; set; }
        [DataMember]
        public string Name { get; set; }
        [DataMember]
        public string MobilePhone { get; set; }
        [DataMember]
        public string Dear { get; set; }
        [DataMember]
        public string JobTitle { get; set; }
        [DataMember]
        public string BirthDate { get; set; }
    }
}
