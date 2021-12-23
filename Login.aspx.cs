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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void login(object sender, EventArgs e)
        {
            String input_mail = in_email.Text;
            String input_pass = in_pass.Text;

            String connString = WebConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            SqlConnection conn = new SqlConnection(connString);

            // get the id of the user with the given email using select statement
            SqlCommand getId = new SqlCommand("SELECT id FROM PostGradUser WHERE email = @input_mail", conn);
            getId.Parameters.AddWithValue("@input_mail", input_mail);

            // use the stored procedure to login the user
            SqlCommand loginProc = new SqlCommand("userLogin", conn);
            SqlParameter out_bit = new SqlParameter("@success", System.Data.SqlDbType.Bit);

            conn.Open();
            int id = Convert.ToInt32(getId.ExecuteScalar());

            loginProc.Parameters.AddWithValue("@id", id);
            loginProc.Parameters.AddWithValue("@password", input_pass);
            loginProc.Parameters.Add(out_bit);
            out_bit.Direction = System.Data.ParameterDirection.Output;

            loginProc.CommandType = System.Data.CommandType.StoredProcedure;
            loginProc.ExecuteNonQuery();
            bool success = (bool)out_bit.Value;
            conn.Close();

            Response.Write(success);
        }
    }
}