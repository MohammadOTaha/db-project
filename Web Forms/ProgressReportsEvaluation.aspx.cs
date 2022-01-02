using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI.WebControls;

namespace PostGradSystem
{
    public partial class ProgressReportsEvaluation : System.Web.UI.Page
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

        private static SqlDataReader getStudentReports(String user_id, String user_type)
        {
            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            SqlCommand cmd;

            if(user_type == "GUCian") {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title 'Thesis Title', T.field 'Field', T.defenseDate 'Defense Date', PR.evaluation 'Evaluation', PR.[date] 'Report Date', S.name 'Supervisor Name'
                        FROM GUCianProgressReport PR
                        INNER JOIN Thesis T ON PR.thesisSerialNumber = T.serialNumber
                        INNER JOIN Supervisor S ON S.id = PR.supervisor_id
                        WHERE PR.student_id = @studentId
                        "
                    ),
                    db_connection.getConnection()
                );
            }
            else {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title 'Thesis Title', T.field 'Field', T.defenseDate 'Defense Date', PR.evaluation 'Evaluation', PR.[date] 'Report Date', S.name 'Supervisor Name'
                        FROM NonGUCianProgressReport PR
                        INNER JOIN Thesis T ON PR.thesisSerialNumber = T.serialNumber
                        INNER JOIN Supervisor S ON S.id = PR.supervisor_id
                        WHERE PR.student_id = @studentId
                        "
                    ),
                    db_connection.getConnection()
                );
            }

            cmd.Parameters.AddWithValue("@studentId", user_id);

            return cmd.ExecuteReader();
        }

        private static Table initReportsTable()
        {
            Table reportsTable = new Table();

            reportsTable.CssClass = "table table-striped table-bordered table-hover";
            reportsTable.ID = "reportsTable";
            reportsTable.Attributes.Add("style", "width: 100%;");
            reportsTable.Attributes.Add("cellspacing", "0");
            reportsTable.Attributes.Add("cellpadding", "0");
            reportsTable.Attributes.Add("border", "0");
            reportsTable.Attributes.Add("align", "center");
            reportsTable.Attributes.Add("style", "margin-top: 20px;");

            TableHeaderRow headerRow = new TableHeaderRow();
            headerRow.TableSection = TableRowSection.TableHeader;

            TableHeaderCell titleHeader = new TableHeaderCell();
            titleHeader.Text = "Thesis Title";
            titleHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(titleHeader);

            TableHeaderCell fieldHeader = new TableHeaderCell();
            fieldHeader.Text = "Field";
            fieldHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(fieldHeader);

            TableHeaderCell defenseDateHeader = new TableHeaderCell();
            defenseDateHeader.Text = "Defense Date";
            defenseDateHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(defenseDateHeader);
            
            TableHeaderCell evaluationHeader = new TableHeaderCell();
            evaluationHeader.Text = "Evaluation";
            evaluationHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(evaluationHeader);

            TableHeaderCell reportDateHeader = new TableHeaderCell();
            reportDateHeader.Text = "Report Date";
            reportDateHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(reportDateHeader);

            TableHeaderCell supervisorHeader = new TableHeaderCell();
            supervisorHeader.Text = "Supervisor Name";
            supervisorHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(supervisorHeader);

            reportsTable.Rows.Add(headerRow);

            return reportsTable;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["user_id"] == null) {
                Response.Redirect("Login.aspx");
            }
            else {
                String user_id = Session["user_id"].ToString();
                String user_type = Session["user_type"].ToString();

                Table reportsTable = initReportsTable();

                SqlDataReader reports = getStudentReports(user_id, user_type);

                while(reports.Read()) {
                    TableRow row = new TableRow();
                    row.TableSection = TableRowSection.TableBody;

                    TableCell titleCell = new TableCell();
                    titleCell.Text = reports["Thesis Title"].ToString();
                    titleCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(titleCell);

                    TableCell fieldCell = new TableCell();
                    fieldCell.Text = reports["Field"].ToString();
                    fieldCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(fieldCell);

                    TableCell defenseDateCell = new TableCell();
                    defenseDateCell.Text = reports["Defense Date"].ToString();
                    defenseDateCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(defenseDateCell);

                    TableCell evaluationCell = new TableCell();
                    evaluationCell.Text = reports["Evaluation"].ToString();
                    evaluationCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(evaluationCell);

                    TableCell reportDateCell = new TableCell();
                    reportDateCell.Text = reports["Report Date"].ToString();
                    reportDateCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(reportDateCell);

                    TableCell supervisorCell = new TableCell();
                    supervisorCell.Text = reports["Supervisor Name"].ToString();
                    supervisorCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(supervisorCell);

                    reportsTable.Rows.Add(row);
                }

                reports.Close();

                reportsDiv.Controls.Add(reportsTable);
            }
        }
    }
}