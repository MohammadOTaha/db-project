using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace PostGradSystem
{
    public partial class Theses : System.Web.UI.Page
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

        private static SqlDataReader getStudentTheses(String user_id)
        {
            SqlCommand cmd;
            if(is_gucian(user_id)) {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title, T.type, T.field, T.startDate, T.endDate, T.defenseDate, T.grade, T.noExtension
                        FROM  GUCianRegisterThesis ST
                        INNER JOIN Thesis T ON ST.thesisSerialNumber = T.serialNumber
                        WHERE ST.GUCianID = @user_id
                        "
                    ), 
                    db_connection.getConnection()
                );
            }
            else {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title, T.type, T.field, T.startDate, T.endDate, T.defenseDate, T.grade, T.noExtension
                        FROM  NonGUCianRegisterThesis ST
                        INNER JOIN Thesis T ON ST.thesisSerialNumber = T.serialNumber
                        WHERE ST.NonGUCianID = @user_id
                        "
                    ), 
                    db_connection.getConnection()
                );
            }

            cmd.Parameters.AddWithValue("@user_id", user_id);

            return cmd.ExecuteReader();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            int user_id = 6;

            if(user_id == 0) {
                Response.Redirect("Login.aspx");
            }
            else {
                db_connection.getConnection().Open();

                SqlDataReader reader = getStudentTheses(user_id.ToString());

                // view the data
                while(reader.Read()) {
                    Response.Write(reader["title"] + "<br />");
                    Response.Write(reader["type"] + "<br />");
                    Response.Write(reader["field"] + "<br />");
                    Response.Write(reader["startDate"] + "<br />");
                    Response.Write(reader["endDate"] + "<br />");
                    Response.Write(reader["defenseDate"] + "<br />");
                    Response.Write(reader["grade"] + "<br />");
                    Response.Write(reader["noExtension"] + "<br />");
                }

                db_connection.getConnection().Close();
            }
        }
    }
}