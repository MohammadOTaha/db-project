using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Web.Security; 

namespace PostGradSystem
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

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

        private static void registerStudent(bool is_gucian, Dictionary<String, String> user_info)
        {
            SqlCommand register;
            if(is_gucian) {
                register = new SqlCommand(
                    "INSERT INTO GUCianStudent (id, firstName, lastName, type, faculty, address, underGradID) VALUES (@id, @first_name, @last_name, @type, @faculty, @address, @underGradID)", 
                    db_connection.getConnection()
                );
            }
            else {
                register = new SqlCommand(
                    "INSERT INTO NonGUCianStudent (id, firstName, lastName, type, faculty, address) VALUES (@id, @first_name, @last_name, @type, @faculty, @address)", 
                    db_connection.getConnection()
                );
            }

            register.Parameters.AddWithValue("@id", user_info["user_id"]);
            register.Parameters.AddWithValue("@first_name", user_info["first_name"]);
            register.Parameters.AddWithValue("@last_name", user_info["last_name"]);
            register.Parameters.AddWithValue("@type", user_info["type"]);
            register.Parameters.AddWithValue("@faculty", user_info["faculty"]);
            register.Parameters.AddWithValue("@address", user_info["address"]);
            if(is_gucian) register.Parameters.AddWithValue("@underGradID", user_info["underGradID"]);

            register.ExecuteNonQuery();
        }

        private static void registerSupervisor(Dictionary<String, String> user_info) 
        {
            SqlCommand register = new SqlCommand(
                "INSERT INTO Supervisor (id, name, faculty) VALUES (@id, @name, @faculty)", 
                db_connection.getConnection()
            );

            String name = user_info["first_name"] + " " + user_info["last_name"];
            register.Parameters.AddWithValue("@id", user_info["user_id"]);
            register.Parameters.AddWithValue("@name", name);
            register.Parameters.AddWithValue("@faculty", user_info["faculty"]);

            register.ExecuteNonQuery();
        }

        private static void registerExaminer(Dictionary<String, String> user_info)
        {
            SqlCommand register = new SqlCommand(
                "INSERT INTO Examiner (id, name, fieldOfWork, isNational) VALUES (@id, @name, @fieldOfWork, @isNational)", 
                db_connection.getConnection()
            );

            String name = user_info["first_name"] + " " + user_info["last_name"];
            register.Parameters.AddWithValue("@id", user_info["user_id"]);
            register.Parameters.AddWithValue("@name", name);
            register.Parameters.AddWithValue("@fieldOfWork", user_info["fieldOfWork"]);
            register.Parameters.AddWithValue("@isNational", user_info["isNational"]);

            register.ExecuteNonQuery();
        }

        private static void registerAdmin(Dictionary<String, String> user_info)
        {
            SqlCommand register = new SqlCommand(
                "INSERT INTO Admin (id) VALUES (@id)", 
                db_connection.getConnection()
            );

            register.Parameters.AddWithValue("@id", user_info["user_id"]);

            register.ExecuteNonQuery();
        }

        private static int getRegisteredUserID(Dictionary<String, String> user_info)
        {
            SqlCommand insertUser = new SqlCommand("INSERT INTO PostGradUser (email, password) VALUES (@email, @password) SELECT scope_identity()", db_connection.getConnection());
            insertUser.Parameters.AddWithValue("@email", user_info["email"]);
            insertUser.Parameters.AddWithValue("@password", user_info["password"]);

            return Convert.ToInt32(insertUser.ExecuteScalar());
        }

        private static Boolean isUserTypeChosen(ref DropDownList user_type)
        {
            return user_type.SelectedIndex != 0;
        }

        protected void register(object sender, EventArgs e)
        {
            if(!isUserTypeChosen(ref usertypedroplist)) {
                Response.Write("<script>alert('Please choose a user type.');</script>");
                return;
            }

            Dictionary<String, String> user_info = new Dictionary<String, String>();
            user_info.Add("first_name", firstname.Text);
            user_info.Add("last_name", lastname.Text);
            user_info.Add("address", address.Text);
            user_info.Add("email", email.Text);
            user_info.Add("password", password.Text);
            user_info.Add("faculty", faculty.Text);
            user_info.Add("type", usertypedroplist.SelectedValue);
            user_info.Add("underGradID", underGradID.Text);
            
            db_connection.getConnection().Open();
            
            int user_id = getRegisteredUserID(user_info);
            user_info.Add("user_id", user_id.ToString());

            switch(user_info["type"]) {
                case "GUCian":
                    registerStudent(true, user_info);
                    break;
                case "Non-GUCian":
                    registerStudent(false, user_info);
                    break;
                case "Supervisor":
                    registerSupervisor(user_info);
                    break;
                case "Examiner":
                    registerExaminer(user_info);
                    break;
                case "Admin":
                    registerAdmin(user_info);
                    break;
            }
            
            db_connection.getConnection().Close();
        }

        protected void usertype_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(usertypedroplist.SelectedValue == "GUCian") {
                underGradID.Visible = true;
            }
            else {
                underGradID.Visible = false;
            }
        }
    }
}