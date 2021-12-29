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
    public partial class Publications : System.Web.UI.Page
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

        private static SqlDataReader getStudentPublications(String user_id, String user_type)
        {
            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            SqlCommand cmd;

            if(user_type == "GUCian") {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT P.title 'Publication Title', P.[date] 'Date', P.host 'Host', P.place 'Location', P.isAccepted 'Accepted'
                        FROM Thesis_Publication TP
                        INNER JOIN Publication P ON TP.Publication_ID = P.id
                        INNER JOIN GUCianRegisterThesis GRT ON TP.thesisSerialNumber = GRT.thesisSerialNumber
                        WHERE GRT.GUCianID = @studentID
                        "
                    ),
                    db_connection.getConnection()
                );
            }
            else {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT P.title 'Publication Title', P.[date] 'Date', P.host 'Host', P.place 'Location', P.isAccepted 'Accepted'
                        FROM Thesis_Publication TP
                        INNER JOIN Publication P ON TP.Publication_ID = P.id
                        INNER JOIN NonGUCianRegisterThesis GRT ON TP.thesisSerialNumber = GRT.thesisSerialNumber
                        WHERE GRT.NonGUCianID = @studentID
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
            Table publicationsTable = new Table();

            publicationsTable.CssClass = "table table-striped table-bordered table-hover";
            publicationsTable.ID = "publicationsTable";
            publicationsTable.Attributes.Add("style", "width: 100%;");
            publicationsTable.Attributes.Add("cellspacing", "0");
            publicationsTable.Attributes.Add("cellpadding", "0");
            publicationsTable.Attributes.Add("border", "0");
            publicationsTable.Attributes.Add("align", "center");
            publicationsTable.Attributes.Add("style", "margin-top: 20px;");

            TableHeaderRow headerRow = new TableHeaderRow();
            headerRow.TableSection = TableRowSection.TableHeader;

            TableHeaderCell titleHeader = new TableHeaderCell();
            titleHeader.Text = "Publication Title";
            titleHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(titleHeader);

            TableHeaderCell dateHeader = new TableHeaderCell();
            dateHeader.Text = "Date";
            dateHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(dateHeader);

            TableHeaderCell hostHeader = new TableHeaderCell();
            hostHeader.Text = "Host";
            hostHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(hostHeader);
            
            TableHeaderCell locationHeader = new TableHeaderCell();
            locationHeader.Text = "Location";
            locationHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(locationHeader);

            TableHeaderCell isAcceptedHeader = new TableHeaderCell();
            isAcceptedHeader.Text = "Accepted";
            isAcceptedHeader.Attributes.Add("style", "text-align: center;");
            headerRow.Cells.Add(isAcceptedHeader);

            publicationsTable.Rows.Add(headerRow);

            return publicationsTable;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["user_id"] == null) {
                Response.Redirect("Login.aspx");
            }
            else {
                String user_id = Session["user_id"].ToString();
                String user_type = Session["user_type"].ToString();

                Table publicationsTable = initReportsTable();

                SqlDataReader reports = getStudentPublications(user_id, user_type);

                while(reports.Read()) {
                    TableRow row = new TableRow();
                    row.TableSection = TableRowSection.TableBody;

                    TableCell titleCell = new TableCell();
                    titleCell.Text = reports["Publication Title"].ToString();
                    titleCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(titleCell);

                    TableCell dateCell = new TableCell();
                    dateCell.Text = reports["Date"].ToString();
                    dateCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(dateCell);

                    TableCell hostCell = new TableCell();
                    hostCell.Text = reports["Host"].ToString();
                    hostCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(hostCell);

                    TableCell locationCell = new TableCell();
                    locationCell.Text = reports["Location"].ToString();
                    locationCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(locationCell);

                    TableCell isAcceptedCell = new TableCell();
                    isAcceptedCell.Text = reports["Accepted"].ToString();
                    isAcceptedCell.Attributes.Add("style", "text-align: center;");
                    row.Cells.Add(isAcceptedCell);

                    publicationsTable.Rows.Add(row);
                }

                reports.Close();

                publicationsDiv.Controls.Add(publicationsTable);
            }
        }
    }
}