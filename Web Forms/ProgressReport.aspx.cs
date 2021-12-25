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
        
        static Dictionary<String, String> thesis_info;

        static Boolean isGUCian;
        private static Boolean is_gucian(String user_id)
        {
            SqlCommand cmd = new SqlCommand(
                (
                    @"
                    IF EXISTS (SELECT * FROM GUCianStudent WHERE id = @user_id)
                        BEGIN
                            SET @is_gucian = 1;
                        END
                    ELSE 
                        BEGIN
                            SET @is_gucian = 0;
                        END
                    "
                ), 
                db_connection.getConnection());

            cmd.Parameters.AddWithValue("@user_id", user_id);
            cmd.Parameters.Add("@is_gucian", System.Data.SqlDbType.Bit);
            cmd.Parameters["@is_gucian"].Direction = System.Data.ParameterDirection.Output;

            cmd.ExecuteNonQuery();

            return isGUCian = Convert.ToBoolean(cmd.Parameters["@is_gucian"].Value);
        }

        private static SqlDataReader getStudentTheses(String user_id) 
        {
            if(is_gucian(user_id)) {
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

        private static void loadThesisDropDownList(SqlDataReader reader, ref DropDownList thesis_dropList)
        {
            thesis_info = new Dictionary<String, String>();

            while(reader.Read()) {
                String thesis_title = reader.GetString(0);
                String thesis_serial_number = reader.GetInt32(1).ToString();

                thesis_info.Add(thesis_title, thesis_serial_number);
                thesis_dropList.Items.Add(thesis_title);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // int user_id = Convert.ToInt32(Session["user_id"]);
            int user_id = 1;

            if(user_id == 0) {
                Response.Redirect("Login.aspx");
            }
            else {
                db_connection.getConnection().Open();

                loadThesisDropDownList(getStudentTheses(user_id.ToString()), ref thesis_dropList);

                db_connection.getConnection().Close();
            }
        }


        static Boolean fillProgressReport = false;
        protected void fillReport(object sender, EventArgs e)
        {
            fillProgressReport = true;

            pnl_fillReport.Visible = true;
            btn_fillReport.Visible = false;
        }

        
        private static int getLastReportNo(ref DropDownList thesis_dropList, String user_id) {
            SqlCommand cmd;
            
            if(isGUCian) {
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

            cmd.Parameters.AddWithValue("@thesisSerialNumber", thesis_info[thesis_dropList.SelectedItem.Text]);
            cmd.Parameters.AddWithValue("@user_id", user_id);


            return Convert.ToInt32(cmd.ExecuteScalar());
        }
        
        protected void addReport(object sender, EventArgs e)
        {
            db_connection.getConnection().Open();

            SqlCommand addReport_sb = new SqlCommand("AddProgressReport", db_connection.getConnection());
            addReport_sb.CommandType = System.Data.CommandType.StoredProcedure;

            addReport_sb.Parameters.AddWithValue("@thesisSerialNo", thesis_info[thesis_dropList.SelectedItem.Text]);
            addReport_sb.Parameters.AddWithValue("@progressReportDate", report_date.Text);
    
            addReport_sb.ExecuteNonQuery();

            if(fillProgressReport) {
                // int user_id = Convert.ToInt32(Session["user_id"]);
                int user_id = 1;

                SqlCommand fillReport_sb = new SqlCommand("FillProgressReport", db_connection.getConnection());
                fillReport_sb.CommandType = System.Data.CommandType.StoredProcedure;

                fillReport_sb.Parameters.AddWithValue("@thesisSerialNo", thesis_info[thesis_dropList.SelectedItem.Text]);
                fillReport_sb.Parameters.AddWithValue("@progressReportNo", getLastReportNo(ref thesis_dropList, user_id.ToString()));
                // add int value 
                int state = 0;
                Int32.TryParse(report_state.Text, out state);
                fillReport_sb.Parameters.AddWithValue("@state", state);
                fillReport_sb.Parameters.AddWithValue("@description", report_desc.Text);

                fillReport_sb.ExecuteNonQuery();
            }
            
            db_connection.getConnection().Close();
        }


    }
}