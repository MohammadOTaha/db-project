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
    public partial class StudentPublications : System.Web.UI.Page
    {
        static DBConnection db_connection = new DBConnection();

        private class DBConnection
        {
            private static SqlConnection conn;

            public DBConnection()
            {
                conn =
                    new SqlConnection(WebConfigurationManager
                            .ConnectionStrings["DefaultConnection"]
                            .ToString());
            }

            public SqlConnection getConnection()
            {
                return conn;
            }
        }

        private static void addingStudents(
            ref DropDownList student_dropdownList,
            int superVisorID
        )
        {
            SqlCommand cmd =
                new SqlCommand(@"SELECT PostGradUser.email
                                FROM GUCianRegisterThesis
                                    INNER JOIN Supervisor S1 On S1.id = GUCianRegisterThesis.supervisor_id
                                    INNER JOIN Thesis T1 on T1.serialNumber = GUCianRegisterThesis.thesisSerialNumber
                                    INNER JOIN GUCianStudent ON GUCianStudent.id = GUCianRegisterThesis.GUCianID
                                    INNER JOIN PostGradUser on PostGradUser.id = GucianStudent.id
                                    WHERE T1.endDate > GETDATE() AND S1.id = @superVisorID

                                UNION

                                SELECT PostGradUser.email
                                FROM NonGUCianRegisterThesis
                                    INNER JOIN Supervisor S2 On S2.id = NonGUCianRegisterThesis.supervisor_id
                                    INNER JOIN Thesis T2 on T2.serialNumber = NonGUCianRegisterThesis.thesisSerialNumber
                                    INNER JOIN NonGUCianStudent ON NonGUCianStudent.id = NonGUCianRegisterThesis.NonGUCianID
                                    INNER JOIN PostGradUser on PostGradUser.id = NonGucianStudent.id
                                    WHERE T2.endDate > GETDATE() AND S2.id = @superVisorID",
                    db_connection.getConnection());

            //Check if the connection is open
            if (
                db_connection.getConnection().State ==
                System.Data.ConnectionState.Closed
            )
            {
                db_connection.getConnection().Open();
            }

            cmd.Parameters.AddWithValue("@superVisorId", superVisorID);
            SqlDataReader reader = cmd.ExecuteReader();

            //Adding the results to student_dropdownList
            while (reader.Read())
            {
                student_dropdownList.Items.Add(reader.GetString(0));
            }
            reader.Close();
            db_connection.getConnection().Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user_id"] == null) Response.Redirect("login.aspx");

            if (!Page.IsPostBack)
            {
                addingStudents(ref student_dropdownList,
                Convert.ToInt32(Session["user_id"]));
            }
        }

        protected void viewAllPublications(object sender, EventArgs e)
        {
            //There is a textField
            //get the selected email
            //If connection closed , open it
            if (
                db_connection.getConnection().State ==
                System.Data.ConnectionState.Closed
            )
            {
                db_connection.getConnection().Open();
            }
            string selected_email = student_dropdownList.SelectedValue;

            //Get the id of the selected email from the database
            if (student_dropdownList.SelectedIndex!=0)
            {
                SqlCommand cmd2 =
                    new SqlCommand(@"select id from PostGradUser where PostGradUser.email = @email",
                        db_connection.getConnection());
                cmd2.Parameters.AddWithValue("@email", selected_email);

                int student_id = (int) cmd2.ExecuteScalar();
                SqlCommand cmd =
                    new SqlCommand("ViewAStudentPublications",
                        db_connection.getConnection());
                cmd.Parameters.Add(new SqlParameter("@studentID", student_id));
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                SqlDataReader rdr = cmd.ExecuteReader();

                Table publicationTable = new Table();
                publicationTable.CssClass =
                    "table table-striped table-bordered table-hover";
                publicationTable.ID = "coursesTable";
                publicationTable.Width = Unit.Percentage(160);
                publicationTable.CellSpacing = 0;
                publicationTable.CellPadding = 0;
                publicationTable.GridLines = GridLines.None;

                // initialize headerRow
                TableHeaderRow headerRow = new TableHeaderRow();
                headerRow.TableSection = TableRowSection.TableHeader;

                // initialize headerCell
                TableHeaderCell headerCell = new TableHeaderCell();
                headerCell.Text = "Title";
                headerCell
                    .Attributes
                    .Add("style",
                    "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(40);
                headerRow.Cells.Add (headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Place";
                headerCell
                    .Attributes
                    .Add("style",
                    "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(25);
                headerRow.Cells.Add (headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Host";
                headerCell
                    .Attributes
                    .Add("style",
                    "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(10);
                headerRow.Cells.Add (headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "IsAccepted";
                headerCell
                    .Attributes
                    .Add("style",
                    "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(1);
                headerRow.Cells.Add (headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Date";
                headerCell
                    .Attributes
                    .Add("style",
                    "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(40);
                headerRow.Cells.Add (headerCell);

                publicationTable.Rows.Add (headerRow);
                while (rdr.Read())
                {
                    TableRow row = new TableRow();
                    row.TableSection = TableRowSection.TableBody;
                    TableCell title = new TableCell();
                    TableCell place = new TableCell();
                    TableCell host = new TableCell();
                    TableCell isAccepted = new TableCell();
                    TableCell date = new TableCell();
                    title
                        .Attributes
                        .Add("style",
                        "text-align: center; vertical-align: middle;");
                    title.Text = rdr["title"].ToString();
                    title.CssClass = "text-center";
                    row.Cells.Add (title);

                    place
                        .Attributes
                        .Add("style",
                        "text-align: center; vertical-align: middle;");
                    place.Text = rdr["place"].ToString();
                    place.CssClass = "text-center";
                    row.Cells.Add (place);

                    host
                        .Attributes
                        .Add("style",
                        "text-align: center; vertical-align: middle;");
                    host.Text = rdr["host"].ToString();
                    host.CssClass = "text-center";
                    row.Cells.Add (host);

                    isAccepted
                        .Attributes
                        .Add("style",
                        "text-align: center; vertical-align: middle;");
                    isAccepted.Text = rdr["isAccepted"].ToString();
                    isAccepted.CssClass = "text-center";
                    row.Cells.Add (isAccepted);

                    date
                        .Attributes
                        .Add("style",
                        "text-align: center; vertical-align: middle;");
                    date.Text = rdr["date"].ToString();
                    date.CssClass = "text-center";
                    row.Cells.Add (date);

                    publicationTable.Rows.Add (row);
                }

                publicationsDiv.Controls.Add (publicationTable);
                db_connection.getConnection().Close();
               
                
            }
        }


    }
}