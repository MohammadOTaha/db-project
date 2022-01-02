using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PostGradSystem
{
    public partial class EvaluateProgressReport : System.Web.UI.Page
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
            //check user_id
            if (Session["user_id"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        protected void evaluate_report_Click(object sender, EventArgs e)
        {
            int superVisorId = Int32.Parse(super_visor_id.Text);
            int serialNumber = Int32.Parse(serial_number.Text);
            int progressReportNumber = Int32.Parse(report_number.Text);
            int evaluationMark = Int32.Parse(evaluate_mark.Text);
            SqlCommand cmd = new SqlCommand("EvaluateProgressReport", db_connection.getConnection());
            cmd.Parameters.Add(new SqlParameter("@supervisorID", superVisorId));
            cmd.Parameters.Add(new SqlParameter("@thesisSerialNo", serialNumber));
            cmd.Parameters.Add(new SqlParameter("@progressReportNo", progressReportNumber));
            cmd.Parameters.Add(new SqlParameter("@evaluation", evaluationMark));
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            db_connection.getConnection().Open();
            cmd.ExecuteNonQuery();
            db_connection.getConnection().Close();
            string message = "You have successfully evaluate.";
            string script = "window.onload = function(){ alert('";
            script += message;
            script += "')};";
            ClientScript.RegisterStartupScript(this.GetType(), "SuccessMessage", script, true);

        }
    }
}