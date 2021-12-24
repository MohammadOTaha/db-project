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
    public partial class Courses : System.Web.UI.Page
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

        private static SqlDataReader getStudentCourses(String user_id)
        {
            SqlCommand cmd = new SqlCommand(
                (
                    @"
                    SELECT C.code, SC.grade, C.creditHours, C.fees
                    FROM NonGUCianTakeCourse SC
                    INNER JOIN Course C ON SC.course_id = C.id
                    WHERE SC.NonGUCianID = @user_id
                    "
                ), 
                db_connection.getConnection()
            );

            cmd.Parameters.AddWithValue("@user_id", user_id);

            return cmd.ExecuteReader();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int user_id = Convert.ToInt32(Session["user_id"]);

            if(user_id == 0) {
                Response.Redirect("Login.aspx");
            }
            else {
                db_connection.getConnection().Open();

                SqlDataReader reader = getStudentCourses(user_id.ToString());

                // initialize coursesTable
                Table coursesTable = new Table();
                coursesTable.CssClass = "table table-striped table-bordered table-hover";
                coursesTable.ID = "coursesTable";
                coursesTable.Width = Unit.Percentage(100);
                coursesTable.CellSpacing = 0;
                coursesTable.CellPadding = 0;
                coursesTable.GridLines = GridLines.None;

                // initialize headerRow
                TableHeaderRow headerRow = new TableHeaderRow();
                headerRow.TableSection = TableRowSection.TableHeader;

                // initialize headerCell
                TableHeaderCell headerCell = new TableHeaderCell();
                headerCell.Text = "Course Code";
                // headerCell.CssClass = "text-center";
                headerCell.Width = Unit.Percentage(25);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Grade";
                // headerCell.CssClass = "text-center";
                headerCell.Width = Unit.Percentage(25);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Credit Hours";
                // headerCell.CssClass = "text-center";
                headerCell.Width = Unit.Percentage(25);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Fees";
                // headerCell.CssClass = "text-center";
                headerCell.Width = Unit.Percentage(25);
                headerRow.Cells.Add(headerCell);

                coursesTable.Rows.Add(headerRow);

                while(reader.Read()) {
                    TableRow row = new TableRow();
                    TableCell code = new TableCell();
                    TableCell grade = new TableCell();
                    TableCell creditHours = new TableCell();
                    TableCell fees = new TableCell();

                    code.Text = reader["code"].ToString();
                    code.CssClass = "text-center";
                    row.Cells.Add(code);

                    grade.Text = reader["grade"].ToString() + "%";
                    grade.CssClass = "text-center";
                    row.Cells.Add(grade);

                    creditHours.Text = reader["creditHours"].ToString();
                    creditHours.CssClass = "text-center";
                    row.Cells.Add(creditHours);

                    fees.Text = "$" + reader["fees"].ToString();
                    fees.CssClass = "text-center";
                    row.Cells.Add(fees);

                    coursesTable.Rows.Add(row);
                }

                coursesTable.RenderControl(new HtmlTextWriter(Response.Output));

                db_connection.getConnection().Close();
            }
        }
    }
}