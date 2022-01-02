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
            if (reader[key] != DBNull.Value) user_info.Add(key, reader[key].ToString());
            else user_info.Add(key, null);
        }

        private static Dictionary<String, String> getUserInfo(String user_id, String user_type)
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
                            SELECT PostGradUser.email email, Supervisor.firstName firstName, Supervisor.lastName lastName, Supervisor.faculty faculty
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

        private static void showMyStudents(String user_id, ref HtmlGenericControl Div2)
        {
            int superVisorID = Convert.ToInt32(user_id);
            SqlCommand cmd = new SqlCommand(@"SELECT GUCianStudent.firstName , GUCianStudent.lastName, T1.years
                                FROM GUCianRegisterThesis
                                    INNER JOIN Supervisor S1 On S1.id = GUCianRegisterThesis.supervisor_id
                                    INNER JOIN Thesis T1 on T1.serialNumber = GUCianRegisterThesis.thesisSerialNumber
                                    INNER JOIN GUCianStudent ON GUCianStudent.id = GUCianRegisterThesis.GUCianID
                                    WHERE T1.endDate > GETDATE() AND S1.id = @superVisorID

                                UNION

                                SELECT NonGUCianStudent.firstName, NonGUCianStudent.lAStName,T2.years
                                FROM NonGUCianRegisterThesis
                                    INNER JOIN Supervisor S2 On S2.id = NonGUCianRegisterThesis.supervisor_id
                                    INNER JOIN Thesis T2 on T2.serialNumber = NonGUCianRegisterThesis.thesisSerialNumber
                                    INNER JOIN NonGUCianStudent ON NonGUCianStudent.id = NonGUCianRegisterThesis.NonGUCianID
                                    WHERE T2.endDate > GETDATE() AND S2.id = @superVisorID",
                    db_connection.getConnection());

            //Check if the connection is open
            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }

            cmd.Parameters.AddWithValue("@superVisorId", superVisorID);

            //Create a table
            Table table = new Table();
            table.GridLines = GridLines.None;
            table.CssClass = "table table-bordered table-striped";
            table.Width = Unit.Percentage(40);
            table.CellSpacing = 0;
            table.CellPadding = 0;
            table.GridLines = GridLines.None;

            //Create a table header row
            TableHeaderRow headerRow = new TableHeaderRow();

            //Add header row to the table
            table.Rows.Add(headerRow);

            //Create a new cell and add it to the row
            TableHeaderCell headerCell = new TableHeaderCell();
            headerCell.Text = "First Name";
            headerCell.Width = Unit.Percentage(20);
            headerRow.Cells.Add(headerCell);

            //Create a new cell and add it to the row
            headerCell = new TableHeaderCell();
            headerCell.Text = "Last Name";
            headerCell.Width = Unit.Percentage(20);
            headerRow.Cells.Add(headerCell);

            //Create a new cell and add it to the row
            headerCell = new TableHeaderCell();
            headerCell.Text = "Years";
            headerCell.Width = Unit.Percentage(10);
            headerRow.Cells.Add(headerCell);
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                //Make table and insert data to it
                TableRow row = new TableRow();
                TableCell cell1 = new TableCell();
                TableCell cell2 = new TableCell();
                TableCell cell3 = new TableCell();
                cell1.Text = rdr["firstName"].ToString();
                cell2.Text = rdr["lastName"].ToString();
                cell3.Text = rdr["years"].ToString();
                row.Cells.Add(cell1);
                row.Cells.Add(cell2);
                row.Cells.Add(cell3);
                table.Rows.Add(row);
            }
            db_connection.getConnection().Close();
            Div2.Controls.Add(table);
        }

        private static ArrayList getUserPhoneNumbers(String user_id, String user_type)
        {
            ArrayList phone_numbers = new ArrayList();

            SqlCommand cmd;

            if (user_type == "GUCian")
            {
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
            else
            {
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

            if (user_type == "GUCian" || user_type == "Non-GUCian")
            {
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
            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }

            if (Session["user_id"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                if (!Page.IsPostBack)
                {
                    int user_id = Convert.ToInt32(Session["user_id"]);
                    String user_type = Convert.ToString(Session["user_type"]);

                    user_info = getUserInfo(user_id.ToString(), user_type);

                    if (user_type == "Supervisor") {
                        showButton.Visible = true;
                        pnl_addPhone.Visible = false;
                        pnl_editProfile.Visible = false;
                    }
                    else {
                        showButton.Visible = false;
                    }

                    in_firstName.Text = user_info["firstName"];
                    in_lastName.Text = user_info["lastName"];
                    in_email.Text = user_info["email"];
                    if(user_type == "GUCian" || user_type == "NonGUCian") in_address.Text = user_info["address"];
                    if(user_type == "GUCian") {
                        in_undergradID.Visible = true;
                        in_undergradID.Text = user_info["underGradID"];
                    }

                    writeToPage(ref profileDiv, user_info, user_id.ToString(), user_type);

                    showMyStudents(user_id.ToString(), ref Div2);
                }

            }
        }

        protected void addPhoneNumber(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("editProfile");

            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
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
            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }

            SqlCommand editProfile_sp = new SqlCommand("editMyProfile", db_connection.getConnection());
            editProfile_sp.CommandType = System.Data.CommandType.StoredProcedure;
            editProfile_sp.Parameters.AddWithValue("@studentId", Session["user_id"]);
            editProfile_sp.Parameters.AddWithValue("@type", Session["user_type"]);

            editProfile_sp.Parameters.AddWithValue("@firstname", in_firstName.Text);
            editProfile_sp.Parameters.AddWithValue("@lastName", in_lastName.Text);
            editProfile_sp.Parameters.AddWithValue("@password", in_pass.Text);
            editProfile_sp.Parameters.AddWithValue("@email", in_email.Text);
            editProfile_sp.Parameters.AddWithValue("@address", in_address.Text);

            editProfile_sp.ExecuteNonQuery();

            Response.Redirect(Request.RawUrl);
        }
    }
}
