using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PostGradSystem
{
    public partial class StudentHome : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["user_id"] == null) {
                Response.Redirect("Login.aspx");
            }

            if(Session["user_type"].ToString() == "GUCian") {
                coursesDiv.Visible = false;
            }
        }
    }
}