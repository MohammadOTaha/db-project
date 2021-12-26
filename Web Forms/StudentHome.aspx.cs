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
            String user_id = Convert.ToString(Session["user_id"]);
            String user_type = Convert.ToString(Session["user_type"]);

            if(user_type == "GUCian") {
                courses_panel.Visible = false;
            }
        }
    }
}