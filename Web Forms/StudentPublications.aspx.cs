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
                conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["DefaultConnection"].ToString());
            }

            public SqlConnection getConnection()
            {
                return conn;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        protected void viewAllPublications(object sender, EventArgs e)
        {

            //There is a textField
            int id = Int32.Parse(student_Id.Text);
            SqlCommand cmd = new SqlCommand("ViewAStudentPublications", db_connection.getConnection());
            cmd.Parameters.Add(new SqlParameter("@studentID", id));
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            db_connection.getConnection().Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            Table publicationTable = new Table();
            publicationTable.CssClass = "table table-striped table-bordered table-hover";
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
            headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
            headerCell.Width = Unit.Percentage(40);
            headerRow.Cells.Add(headerCell);

            headerCell = new TableHeaderCell();
            headerCell.Text = "Place";
            headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
            headerCell.Width = Unit.Percentage(25);
            headerRow.Cells.Add(headerCell);

            headerCell = new TableHeaderCell();
            headerCell.Text = "Host";
            headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
            headerCell.Width = Unit.Percentage(10);
            headerRow.Cells.Add(headerCell);

            headerCell = new TableHeaderCell();
            headerCell.Text = "IsAccepted";
            headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
            headerCell.Width = Unit.Percentage(1);
            headerRow.Cells.Add(headerCell);

            headerCell = new TableHeaderCell();
            headerCell.Text = "Date";
            headerCell.Attributes.Add("style", "text-align: center; vertical-align: middle;");
            headerCell.Width = Unit.Percentage(40);
            headerRow.Cells.Add(headerCell);


            publicationTable.Rows.Add(headerRow);
            while (rdr.Read())
            {
                TableRow row = new TableRow();
                row.TableSection = TableRowSection.TableBody;
                TableCell title = new TableCell();
                TableCell place = new TableCell();
                TableCell host = new TableCell();
                TableCell isAccepted = new TableCell();
                TableCell date = new TableCell();
                title.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                title.Text = rdr["title"].ToString();
                title.CssClass = "text-center";
                row.Cells.Add(title);


                place.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                place.Text = rdr["place"].ToString();
                place.CssClass = "text-center";
                row.Cells.Add(place);


                host.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                host.Text = rdr["host"].ToString();
                host.CssClass = "text-center";
                row.Cells.Add(host);


                isAccepted.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                isAccepted.Text = rdr["isAccepted"].ToString();
                isAccepted.CssClass = "text-center";
                row.Cells.Add(isAccepted);


                date.Attributes.Add("style", "text-align: center; vertical-align: middle;");
                date.Text = rdr["date"].ToString();
                date.CssClass = "text-center";
                row.Cells.Add(date);



                publicationTable.Rows.Add(row);
            }

            publicationsDiv.Controls.Add(publicationTable);
            db_connection.getConnection().Close();



        }



    }
}