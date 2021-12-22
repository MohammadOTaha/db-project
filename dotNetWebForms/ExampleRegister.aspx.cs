using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace PostGradSystem
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void register(object sender, EventArgs e)
        {
            String connString = WebConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            SqlConnection conn = new SqlConnection(connString);
            
            String firstName = firstname.Text;
            String lastName = lastname.Text;
            String user_address = address.Text;
            String mail = email.Text;
            String pass = password.Text;
            String fac = faculty.Text;
            String type = usertypedroplist.SelectedValue;

            // use the stored procedure to register the user
            SqlCommand registerProc = new SqlCommand("StudentRegister", conn);
            registerProc.Parameters.AddWithValue("@first_name", firstName);
            registerProc.Parameters.AddWithValue("@last_name", lastName);
            registerProc.Parameters.AddWithValue("@address", user_address);
            registerProc.Parameters.AddWithValue("@email", mail);
            registerProc.Parameters.AddWithValue("@password", pass);
            registerProc.Parameters.AddWithValue("@faculty", fac);
            registerProc.Parameters.AddWithValue("@type", type);

            registerProc.CommandType = System.Data.CommandType.StoredProcedure;

            conn.Open();
            registerProc.ExecuteNonQuery();
            conn.Close();
        }
    }
}