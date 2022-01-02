using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PostGradSystem
{
    public partial class SupervisorHome : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Check if session user_Id is null
            if (Session["user_Id"] == null)
            {
                //Redirect to login page
                Response.Redirect("Login.aspx");
            }

        }
    }
}