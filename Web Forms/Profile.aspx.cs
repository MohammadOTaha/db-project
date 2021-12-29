using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI.HtmlControls;
using System.Web.Configuration;
using System.Web.UI.WebControls;
using System.Collections;

namespace PostGradSystem
{
    public partial class Profile : System.Web.UI.Page
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

        static Dictionary<string, string> user_info;
        public static void insertUserInfo(SqlDataReader reader, String key)
        {
            if(reader[key] != DBNull.Value) user_info.Add(key, reader[key].ToString());
            else user_info.Add(key, null);
        }

        private static Dictionary<String, String> getUserInfo (String user_id, String user_type)
        {
            user_info = new Dictionary<String, String>();

            SqlCommand cmd = new SqlCommand(
                (
                    @"
                    IF @user_type = 'GUCian'
                        BEGIN
                            SELECT P.email email, S.firstName firstName, S.lastName lastName, S.faculty faculty, S.address address, S.GPA GPA, S.underGradID underGradID  
                            FROM GUCianStudent S
                            INNER JOIN PostGradUser P ON S.id = P.id
                            WHERE S.id = @user_id;
                        END
                    ELSE IF @user_type = 'NonGUCian'
                        BEGIN
                            SELECT P.email email, S.firstName firstName, S.lastName lastName, S.faculty faculty, S.address address, S.GPA GPA  
                            FROM NonGUCianStudent S
                            INNER JOIN PostGradUser P ON S.id = P.id
                            WHERE S.id = @user_id;
                        END
                    ELSE IF @user_type = 'Examiner'
                        BEGIN
                            SELECT PostGradUser.email email, Examiner.name name, Examiner.fieldOfWork fieldOfWork, Examiner.isNational isNational
                            FROM Examiner 
                            INNER JOIN PostGradUser ON Examiner.id = PostGradUser.id
                            WHERE Examiner.id = @user_id;
                        END
                    ELSE IF @user_type = 'Supervisor'
                        BEGIN
                            SELECT PostGradUser.email email, Supervisor.name name, Supervisor.faculty faculty
                            FROM Supervisor 
                            INNER JOIN PostGradUser ON Supervisor.id = PostGradUser.id
                            WHERE Supervisor.id = @user_id;
                        END
                    ELSE 
                        BEGIN
                            SELECT PostGradUser.email email
                            FROM Admin
                            INNER JOIN PostGradUser ON Admin.id = PostGradUser.id
                            WHERE Admin.id = @user_id;
                        END
                    "
                ), 
                db_connection.getConnection()
            );

            cmd.Parameters.AddWithValue("@user_id", user_id);
            cmd.Parameters.AddWithValue("@user_type", user_type);

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    insertUserInfo(reader, reader.GetName(i));
                }
            }

            reader.Close();

            return user_info;
        }
        private static String prettifyOutputString(String input)
        {
            switch (input)
            {
                case "firstName":
                    return "First Name";
                case "lastName":
                    return "Last Name";
                case "underGradID":
                    return "Undergraduate ID";
                case "fieldOfWork":
                    return "Field of Work";
                case "isNational":
                    return "National";
                default:
                    return input.Substring(0, 1).ToUpper() + input.Substring(1);
            }
        }
        
        private static ArrayList getUserPhoneNumbers(String user_id, String user_type)
        {
            ArrayList phone_numbers = new ArrayList();

            SqlCommand cmd;

            if(user_type == "GUCian") {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT phoneNumber
                        FROM GUCStudentPhoneNumber
                        WHERE GUCianID = @user_id
                        "
                    ),
                    db_connection.getConnection()
                );
            }
            else {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT phoneNumber
                        FROM NonGUCianPhoneNumber
                        WHERE NonGUCianID = @user_id
                        "
                    ),
                    db_connection.getConnection()
                );
            }

            cmd.Parameters.AddWithValue("@user_id", user_id);

            SqlDataReader reader = cmd.ExecuteReader();
            
            while (reader.Read())
            {
                phone_numbers.Add(reader["phoneNumber"].ToString());
            }

            reader.Close();

            return phone_numbers;
        }
        private static void writeToPage(ref HtmlGenericControl profileDiv, Dictionary<String, String> user_info, String user_id, String user_type)
        {
            // create a table to hold the user info
            Table table = new Table();
            table.CssClass = "table table-striped table-bordered table-hover";
            table.Width = Unit.Percentage(100);
            table.CellSpacing = 0;
            table.CellPadding = 0;
            table.GridLines = GridLines.None;

            // create a row for each key/value pair
            foreach (KeyValuePair<String, String> pair in user_info)
            {
                TableRow row = new TableRow();
                TableCell key = new TableCell();
                TableCell value = new TableCell();

                key.Width = Unit.Percentage(20);
                value.Width = Unit.Percentage(80);

                key.Font.Bold = true;
                key.CssClass = "text-center text-uppercase text-info";
                value.CssClass = "text-center";

                key.Text = prettifyOutputString(pair.Key);
                value.Text = pair.Value;

                row.Cells.Add(key);
                row.Cells.Add(value);

                table.Rows.Add(row);
            }

            // add the table to the page
            profileDiv.Controls.Add(table);

            if(user_type == "GUCian" || user_type == "Non-GUCian") {
                // create a table to hold the user phone numbers
                Table phone_numbers_table = new Table();
                phone_numbers_table.CssClass = "table table-striped table-bordered table-hover";
                phone_numbers_table.Width = Unit.Percentage(100);
                phone_numbers_table.CellSpacing = 0;
                phone_numbers_table.CellPadding = 0;
                phone_numbers_table.GridLines = GridLines.None;

                // create a row for each phone number, numbered from 1
                int i = 1;
                foreach (String phone_number in getUserPhoneNumbers(user_id, user_type))
                {
                    TableRow row = new TableRow();
                    TableCell key = new TableCell();
                    TableCell value = new TableCell();

                    key.Width = Unit.Percentage(20);
                    value.Width = Unit.Percentage(80);

                    key.Font.Bold = true;
                    key.CssClass = "text-center text-uppercase text-info";
                    value.CssClass = "text-center";

                    key.Text = "Phone Number " + i;
                    value.Text = phone_number;

                    row.Cells.Add(key);
                    row.Cells.Add(value);

                    phone_numbers_table.Rows.Add(row);

                    i++;
                }

                // add the table to the page
                profileDiv.Controls.Add(phone_numbers_table);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            if (Session["user_id"] == null) {
                Response.Redirect("Login.aspx");
            }
            else {
                int user_id = Convert.ToInt32(Session["user_id"]);
                String user_type = Convert.ToString(Session["user_type"]);

                user_info = getUserInfo(user_id.ToString(), user_type);

                in_firstName.Text = user_info["firstName"];
                in_lastName.Text = user_info["lastName"];
                in_email.Text = user_info["email"];
                in_address.Text = user_info["address"];
               
                writeToPage(ref profileDiv, user_info, user_id.ToString(), user_type);
            }
        }

        protected void addPhoneNumber(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("editProfile");

            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }


            SqlCommand addPhone_sp = new SqlCommand("addMobile", db_connection.getConnection());
            addPhone_sp.CommandType = System.Data.CommandType.StoredProcedure;

            addPhone_sp.Parameters.AddWithValue("@ID", Session["user_id"]);
            addPhone_sp.Parameters.AddWithValue("@mobile_number", in_phone_number.Text);

            addPhone_sp.ExecuteNonQuery();

            Response.Redirect(Request.RawUrl);
        }

        protected void editProfile(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("------------------");

            System.Diagnostics.Debug.WriteLine(in_email.Text);

            System.Diagnostics.Debug.WriteLine("------------------");

            System.Diagnostics.Debug.WriteLine(in_address.Text);

            System.Diagnostics.Debug.WriteLine("------------------");



            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            SqlCommand editProfile_sp = new SqlCommand("editMyProfile", db_connection.getConnection());
            editProfile_sp.CommandType = System.Data.CommandType.StoredProcedure;

            editProfile_sp.Parameters.AddWithValue("@studentId", Session["user_id"]);
            editProfile_sp.Parameters.AddWithValue("@type", "a7a");
            editProfile_sp.Parameters.AddWithValue("@firstname", in_firstName.Text);
            editProfile_sp.Parameters.AddWithValue("@lastName", in_lastName.Text);
            editProfile_sp.Parameters.AddWithValue("@password", in_pass.Text);
            editProfile_sp.Parameters.AddWithValue("@email", in_email.Text);
            editProfile_sp.Parameters.AddWithValue("@address", in_address.Text);

            editProfile_sp.ExecuteNonQuery();

        }
    }
}
