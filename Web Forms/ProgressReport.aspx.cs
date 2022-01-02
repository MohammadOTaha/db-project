using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI.WebControls;

namespace PostGradSystem
{
    public partial class ProgressReport : System.Web.UI.Page
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
        
        static Dictionary<int, int> thesis_info;
        static Dictionary<int, int> supervisor_info;
        private static SqlDataReader getStudentTheses(String user_id, String user_type) 
        {
            if(user_type == "GUCian") {
                SqlCommand cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title, T.serialNumber
                        FROM Thesis T
                        INNER JOIN GUCianRegisterThesis ST ON T.serialNumber = ST.thesisSerialNumber
                        WHERE ST.GUCianID = @user_id AND T.startDate <= GETDATE() AND T.endDate >= GETDATE()
                        "
                    ), 
                    db_connection.getConnection()
                );

                cmd.Parameters.AddWithValue("@user_id", user_id);

                return cmd.ExecuteReader();
            }
            else {
                SqlCommand cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title, T.serialNumber 
                        FROM Thesis T
                        INNER JOIN NonGUCianRegisterThesis ST ON T.serialNumber = ST.thesisSerialNumber
                        WHERE ST.NonGUCianID = @user_id AND T.startDate <= GETDATE() AND T.endDate >= GETDATE()
                        "
                    ), 
                    db_connection.getConnection()
                );

                cmd.Parameters.AddWithValue("@user_id", user_id);

                return cmd.ExecuteReader();
            }
        }

        private static SqlDataReader getSupervisors()
        {
            SqlCommand cmd = new SqlCommand(
                (
                    @"
                    SELECT PostGradUser.email, S.id
                    FROM Supervisor S
                    INNER JOIN PostGradUser ON S.id = PostGradUser.id
                    "
                ),
                db_connection.getConnection()
            );

            return cmd.ExecuteReader();
        }

        private static void loadThesisDropDownList(SqlDataReader reader, ref DropDownList thesis_dropList)
        {
            thesis_info = new Dictionary<int, int>();

            int idx = 1;
            while(reader.Read()) {
                String thesis_title = reader.GetString(0);
                int thesis_serial_number = reader.GetInt32(1);

                thesis_info.Add(idx++, thesis_serial_number);
                thesis_dropList.Items.Add(thesis_title);
            }

            reader.Close();
        }

        private static void loadSupervisorDropDownList(SqlDataReader reader, ref DropDownList supervisor_dropList)
        {
            supervisor_info = new Dictionary<int, int>();

            int idx = 1;
            while(reader.Read()) {
                String supervisor_email = reader.GetString(0);
                int supervisor_id = reader.GetInt32(1);

                supervisor_info.Add(idx++, supervisor_id);
                supervisor_dropList.Items.Add(supervisor_email);
            }

            reader.Close();
        }


        protected void Page_Load(object sender, EventArgs e)
        {
  ;

            if(Session["user_id"] == null) {
                Response.Redirect("Login.aspx");
            }
            else {
                if(!Page.IsPostBack) {
                    if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                        db_connection.getConnection().Open();
                    }

                    int user_id = Convert.ToInt32(Session["user_id"]);
                    String user_type = Session["user_type"].ToString();

                    loadThesisDropDownList(getStudentTheses(user_id.ToString(), user_type), ref thesis_dropList);
                    
                    loadSupervisorDropDownList(getSupervisors(), ref supervisor_dropList);
                }

            }
        }

        private static int getLastReportNo(ref DropDownList thesis_dropList, String user_id, String user_type) {
            SqlCommand cmd;
            
            if(user_type == "GUCian") {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT MAX(progressReportNumber)
                        FROM GUCianProgressReport
                        WHERE thesisSerialNumber = @thesisSerialNumber AND student_id = @user_id
                        "
                    ), 
                    db_connection.getConnection()
                );
            }
            else {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT MAX(progressReportNumber)
                        FROM NonGUCianProgressReport
                        WHERE thesisSerialNumber = @thesisSerialNumber AND student_id = @user_id
                        "
                    ), 
                    db_connection.getConnection()
                );
            }

            cmd.Parameters.AddWithValue("@thesisSerialNumber", thesis_info[thesis_dropList.SelectedIndex]);
            cmd.Parameters.AddWithValue("@user_id", user_id);


            return Convert.ToInt32(cmd.ExecuteScalar());
        }
        
        protected void addReport(object sender, EventArgs e)
        {
            int user_id = Convert.ToInt32(Session["user_id"]);
            String user_type = Session["user_type"].ToString();

            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            if(thesis_dropList.SelectedIndex == 0) {
                Response.Write("<script>alert('Please select a thesis.')</script>");
                return;
            }

            SqlCommand addReport_sb = new SqlCommand("AddProgressReport", db_connection.getConnection());
            addReport_sb.CommandType = System.Data.CommandType.StoredProcedure;

            addReport_sb.Parameters.AddWithValue("@thesisSerialNo", thesis_info[thesis_dropList.SelectedIndex]);
            addReport_sb.Parameters.AddWithValue("@progressReportDate", report_date.Text);
    
            addReport_sb.ExecuteNonQuery();

            
            SqlCommand fillReport_sb = new SqlCommand("FillProgressReport", db_connection.getConnection());
            fillReport_sb.CommandType = System.Data.CommandType.StoredProcedure;

            fillReport_sb.Parameters.AddWithValue("@thesisSerialNo", thesis_info[thesis_dropList.SelectedIndex]);
            fillReport_sb.Parameters.AddWithValue("@progressReportNo", getLastReportNo(ref thesis_dropList, user_id.ToString(), user_type));
            // add int value 
            int state = 0;
            Int32.TryParse(report_state.Text, out state);
            fillReport_sb.Parameters.AddWithValue("@state", state);
            fillReport_sb.Parameters.AddWithValue("@description", report_desc.Text);

            fillReport_sb.ExecuteNonQuery();
            
            Response.Redirect("Home.aspx");
        }


    }
}