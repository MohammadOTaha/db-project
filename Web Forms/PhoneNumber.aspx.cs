using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI.WebControls;

namespace PostGradSystem
{
    public partial class PhoneNumber : System.Web.UI.Page
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

            return Convert.ToBoolean(cmd.Parameters["@is_gucian"].Value);
        }

        private static List<String> getStudentsPhoneNumbers(String user_id) {
            SqlCommand cmd;
            if(isGUCian) {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT phoneNumber FROM GUCStudentPhoneNumber WHERE GUCianID = @user_id
                        "
                    ), 
                    db_connection.getConnection()
                );
            }
            else {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT phoneNumber FROM NonGUCianPhoneNumber WHERE NonGUCianID = @user_id
                        "
                    ), 
                    db_connection.getConnection()
                );
            }
            cmd.Parameters.AddWithValue("@user_id", user_id);

            SqlDataReader reader = cmd.ExecuteReader();

            List<String> phoneNumbers = new List<String>();
            while(reader.Read()) {
                phoneNumbers.Add(reader.GetString(0));
            }
            
            reader.Close();

            return phoneNumbers;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            int user_id = Convert.ToInt32(Session["user_id"]);

            if(user_id == 0) {
                Response.Redirect("~/Login.aspx");
            }
            else {
                if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                    db_connection.getConnection().Open();
                }

                isGUCian = is_gucian(user_id.ToString());

                List<String> phoneNumbers = getStudentsPhoneNumbers(user_id.ToString());

                foreach(String phoneNumber in phoneNumbers) {
                    ListItem item = new ListItem(phoneNumber, phoneNumber);
                    ul.Items.Add(item);
                }

                db_connection.getConnection().Close();
            }
        }

        protected void AddPhoneNumber(object sender, EventArgs e)
        {
            int user_id = Convert.ToInt32(Session["user_id"]);
            
            if(!String.IsNullOrEmpty(tb_add_phone.Text)) {
                if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                    db_connection.getConnection().Open();
                }

                SqlCommand addPhone_sp = new SqlCommand("addMobile", db_connection.getConnection());
                addPhone_sp.CommandType = System.Data.CommandType.StoredProcedure;

                addPhone_sp.Parameters.AddWithValue("@ID", user_id);
                addPhone_sp.Parameters.AddWithValue("@mobile_number", tb_add_phone.Text);

                addPhone_sp.ExecuteNonQuery();

                db_connection.getConnection().Close();

                Response.Redirect("~/PhoneNumber.aspx");
            }
        }

    }
}