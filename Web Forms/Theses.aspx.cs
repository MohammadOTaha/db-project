using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI.WebControls;

namespace PostGradSystem
{
    public partial class Theses : System.Web.UI.Page
    {

        static int user_id;
        static string user_type;
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

        private static SqlDataReader getStudentTheses(String user_id)
        {
            SqlCommand cmd;
            if(user_type == "GUCian") {
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

            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            return cmd.ExecuteReader();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            user_id = Convert.ToInt32(Session["user_id"]);
            user_type = Session["user_type"].ToString();

            if(user_id == 0) {
                Response.Redirect("Login.aspx");
            }
            else {
                SqlDataReader reader = getStudentTheses(user_id.ToString());

                Table thesesTable = new Table();
                thesesTable.CssClass = "table table-striped table-bordered table-hover";
                thesesTable.ID = "coursesTable";
                thesesTable.Width = Unit.Percentage(100);
                thesesTable.CellSpacing = 0;
                thesesTable.CellPadding = 0;
                thesesTable.GridLines = GridLines.None;

                // initialize headerRow
                TableHeaderRow headerRow = new TableHeaderRow();
                headerRow.TableSection = TableRowSection.TableHeader;

                // initialize headerCell
                TableHeaderCell headerCell = new TableHeaderCell();
                headerCell.Text = "Title";
                headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(20);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Type";
                headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(10);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Field";
                headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(20);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Start Date";
                headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(10);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "End Date";
                headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(10);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Defense Date";
                headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(10);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Grade";
                headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(10);
                headerRow.Cells.Add(headerCell);

                headerCell = new TableHeaderCell();
                headerCell.Text = "Number of Extensions";
                headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                headerCell.Width = Unit.Percentage(10);
                headerRow.Cells.Add(headerCell);

                thesesTable.Rows.Add(headerRow);

                // view the data
                while(reader.Read()) {
                    TableRow row = new TableRow();
                    row.TableSection = TableRowSection.TableBody;

                    TableCell titleCell = new TableCell();
                    titleCell.Text = reader["title"].ToString();
                    titleCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                    row.Cells.Add(titleCell);

                    TableCell typeCell = new TableCell();
                    typeCell.Text = reader["type"].ToString();
                    typeCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                    row.Cells.Add(typeCell);

                    TableCell fieldCell = new TableCell();
                    fieldCell.Text = reader["field"].ToString();
                    fieldCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                    row.Cells.Add(fieldCell);

                    TableCell startDateCell = new TableCell();
                    startDateCell.Text = reader["startDate"].ToString();
                    startDateCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                    row.Cells.Add(startDateCell);

                    TableCell endDateCell = new TableCell();
                    endDateCell.Text = reader["endDate"].ToString();
                    endDateCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                    row.Cells.Add(endDateCell);

                    TableCell defenseDateCell = new TableCell();
                    defenseDateCell.Text = reader["defenseDate"].ToString();
                    defenseDateCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                    row.Cells.Add(defenseDateCell);

                    TableCell gradeCell = new TableCell();
                    gradeCell.Text = reader["grade"].ToString();
                    gradeCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                    row.Cells.Add(gradeCell);

                    TableCell noExtensionCell = new TableCell();
                    noExtensionCell.Text = reader["noExtension"].ToString();
                    noExtensionCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                    row.Cells.Add(noExtensionCell);

                    thesesTable.Rows.Add(row);
                }

                // add the table to div
                thesesDiv.Controls.Add(thesesTable);

                reader.Close();
            }
        }
    }
}