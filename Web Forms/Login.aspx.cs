using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace PostGradSystem
{
    public partial class Login : System.Web.UI.Page
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

            db_connection.getConnection().Open();
            int id = Convert.ToInt32(getId.ExecuteScalar());

            loginProc.Parameters.AddWithValue("@id", id);
            loginProc.Parameters.AddWithValue("@password", input_pass);
            loginProc.Parameters.Add(out_bit);
            out_bit.Direction = System.Data.ParameterDirection.Output;

            loginProc.CommandType = System.Data.CommandType.StoredProcedure;
            loginProc.ExecuteNonQuery();
            bool success = (bool)out_bit.Value;
            
            if(success) Session["user_id"] = id;
            else Response.Write("<script>alert('Invalid email or password')</script>");

            db_connection.getConnection().Close();
        }
    }
}