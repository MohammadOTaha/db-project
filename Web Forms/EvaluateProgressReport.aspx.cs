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
        static Dictionary<int, int> thesis_info = new Dictionary<int, int>();


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
            //clear dictonary

            if (Session["user_id"] == null)
            {
                Response.Redirect("login.aspx");
            }

            if (!Page.IsPostBack)
            {
               
                addingThesis(ref thesis_dropdownList, Convert.ToInt32(Session["user_id"]));


            }





        }


        private static void addingThesis(ref DropDownList thesis_dropdownList, int superVisorID)
        {
            SqlCommand cmd = new SqlCommand(@"
                                                 SELECT PostGradUser.email, t.serialNumber, t.title
                                                FROM NonGUCianRegisterThesis ng
                                                INNER JOIN Thesis t ON ng.thesisSerialNumber = t.serialNumber
                                                INNER JOIN NonGUCianProgressReport  ON NonGUCianProgressReport.thesisSerialNumber = t.serialNumber
                                                INNER JOIN PostGradUser on PostGradUser.id = ng.NonGucianID
                                                WHERE ng.supervisor_id = @superVisorId AND NonGUCianProgressReport.supervisor_id = @superVisorID

                                                UNION ALL

                                                SELECT  PostGradUser.email, t.serialNumber, t.title
                                                FROM GUCianRegisterThesis g
                                                 INNER JOIN PostGradUser on PostGradUser.id = g.GucianID
                                                INNER JOIN Thesis t ON g.thesisSerialNumber = t.serialNumber
                                                INNER JOIN GUCianProgressReport NGP ON NGP.thesisSerialNumber = t.serialNumber
                                                WHERE g.supervisor_id = @supervisorID and NGP.supervisor_id = @superVisorID", db_connection.getConnection());
            //make reader to read from cmd
            cmd.Parameters.AddWithValue("@supervisorID", superVisorID);
            //Check if connection is Open
            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }

            SqlDataReader reader = cmd.ExecuteReader();


            thesis_info= new Dictionary<int, int>();
            //while there is a next row
            int idx = 1;
            while (reader.Read())
            {
                //add the email to the dropdown list
                thesis_dropdownList.Items.Add(reader.GetString(2) + ", " + reader.GetString(0));

                //Check if the thesis is already in the dict


                thesis_info.Add(idx, reader.GetInt32(1));

                idx++;







            }
            reader.Close();
            db_connection.getConnection().Close();

        }

        protected void evaluate_report_Click(object sender, EventArgs e)
        {



            System.Diagnostics.Debug.WriteLine("-------------------------- " + thesis_dropdownList.SelectedIndex);

            int serialNumber = thesis_info[thesis_dropdownList.SelectedIndex];
            int progressReportNumber = Int32.Parse(progressReportID.Text);
            int evaluationMark = Int32.Parse(evaluate_mark.Text);
            int superVisorId = Convert.ToInt32(Session["user_id"]);


            SqlCommand cmd = new SqlCommand("EvaluateProgressReport", db_connection.getConnection());
            cmd.Parameters.Add(new SqlParameter("@supervisorID", Session["user_id"]));
            cmd.Parameters.Add(new SqlParameter("@thesisSerialNo", serialNumber));
            cmd.Parameters.Add(new SqlParameter("@progressReportNo", progressReportNumber));
            cmd.Parameters.Add(new SqlParameter("@evaluation", evaluationMark));
            cmd.Parameters.Add(new SqlParameter("@Success", System.Data.SqlDbType.Bit));
            cmd.Parameters["@Success"].Direction = System.Data.ParameterDirection.Output;

            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }
            cmd.ExecuteNonQuery();
            if (cmd.Parameters["@Success"].Value.ToString() == "True")
            {
                Response.Write("<script>alert('Evaluation Successful')</script>");
                Response.Redirect("Home.aspx");
            }
            else
            {
                Response.Write("<script>alert('Evaluation Failed. Check Progress Report Number')</script>");
            }



            db_connection.getConnection().Close();

        }
    }
}