using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace PostGradSystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["user_id"] != null)
            {
                Response.Redirect("~/Home.aspx");
            }
        }

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

        private static String getUserType(String user_id)
        {
            SqlCommand cmd = new SqlCommand(
                (
                    @"IF EXISTS (SELECT * FROM GUCianStudent WHERE id = @user_id)
                    BEGIN
                        SET @type = 'GUCian';
                    END
                    ELSE IF EXISTS (SELECT * FROM NonGUCianStudent WHERE id = @user_id)
                    BEGIN
                        SET @type = 'NonGUCian';
                    END
                    ELSE IF EXISTS (SELECT * FROM Examiner WHERE id = @user_id)
                    BEGIN
                        SET @type = 'Examiner';
                    END
                    ELSE IF EXISTS (SELECT * FROM Supervisor WHERE id = @user_id)
                    BEGIN
                        SET @type = 'Supervisor';
                    END
                    ELSE 
                    BEGIN
                        SET @type = 'Admin';
                    END"
                ), 
                db_connection.getConnection());

            cmd.Parameters.AddWithValue("@user_id", user_id);
            cmd.Parameters.Add("@type", System.Data.SqlDbType.VarChar, 50);
            cmd.Parameters["@type"].Direction = System.Data.ParameterDirection.Output;

            cmd.ExecuteNonQuery();

            return cmd.Parameters["@type"].Value.ToString();
        }

        protected void login(object sender, EventArgs e)
        {
            String input_mail = in_email.Text;
            String input_pass = in_pass.Text;

            // get the id of the user with the given email using select statement
            SqlCommand getId = new SqlCommand("SELECT id FROM PostGradUser WHERE email = @input_mail", db_connection.getConnection());
            getId.Parameters.AddWithValue("@input_mail", input_mail);

            // use the stored procedure to login the user
            SqlCommand loginProc = new SqlCommand("userLogin", db_connection.getConnection());
            SqlParameter out_bit = new SqlParameter("@success", System.Data.SqlDbType.Bit);

            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }

            int id = Convert.ToInt32(getId.ExecuteScalar());

            loginProc.Parameters.AddWithValue("@id", id);
            loginProc.Parameters.AddWithValue("@password", input_pass);
            loginProc.Parameters.Add(out_bit);
            out_bit.Direction = System.Data.ParameterDirection.Output;

            loginProc.CommandType = System.Data.CommandType.StoredProcedure;
            loginProc.ExecuteNonQuery();
            bool success = (bool)out_bit.Value;
            
            if(success) {
                Session.Add("user_id", id);
                Session.Add("user_type", getUserType(id.ToString()));

                Response.Redirect("/Home.aspx");
            }
            else Response.Write("<script>alert('Invalid email or password')</script>");
        }
    }
}