using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;

namespace PostGradSystem
{
    public partial class Home : System.Web.UI.Page
    {

        static DBConnection db_connection = new DBConnection();
        private class DBConnection
        {
            private static SqlConnection conn;

            public DBConnection() 
            {
                conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
            }

            public SqlConnection getConnection()
            {
                return conn;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["user_id"] == null) {
                Response.Redirect("Login.aspx");
            }

            String user_id = Convert.ToString(Session["user_id"]);
            String user_type = Convert.ToString(Session["user_type"]);

            switch (user_type) {
                case "GUCian":
                    Response.Redirect("/StudentHome.aspx");
                    break;
                
                case "NonGUCian":
                    Response.Redirect("/StudentHome.aspx");
                    break;

                case "Supervisor":
                    Response.Redirect("/SupervisorHome.aspx");
                    break;
                
                case "Examiner":
                    Response.Redirect("/ExaminerPage.aspx");
                    break;

                case "Admin":
                    Response.Redirect("/AdminHome.aspx");
                    break;
            }
        }
    }
}