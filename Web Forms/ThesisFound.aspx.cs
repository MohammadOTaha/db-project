using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PostGradSystem
{
    public partial class ThesisFound : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            String connStr = WebConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand Found = new SqlCommand("search", conn);

            String Title = (string)Session["title"];

            Found.Parameters.Add(new SqlParameter("@keyWord", Title));

            SqlParameter success = Found.Parameters.Add("@Success", SqlDbType.Bit);

            success.Direction = System.Data.ParameterDirection.Output;




            Found.CommandType = System.Data.CommandType.StoredProcedure;
            conn.Open();
            SqlDataReader rdr = Found.ExecuteReader(CommandBehavior.CloseConnection);
            if (success.Value.ToString() == "True")
            {

                Table m = new Table();
                m.CellSpacing = 10;
                m.CellPadding = 10;
                m.Width = Unit.Pixel(100);
                m.GridLines = GridLines.Both;
                m.HorizontalAlign = HorizontalAlign.Center;
                TableCell oo = new TableCell();
                oo.Font.Bold = true;
                oo.Text = "serialNumber";
                TableCell hh = new TableCell();
                hh.Font.Bold = true;
                hh.Text = "field";
                TableCell cc = new TableCell();
                cc.Font.Bold = true;
                cc.Text = "type";
                TableCell rr = new TableCell();
                rr.Font.Bold = true;
                rr.Text = "title";
                TableCell ww = new TableCell();
                ww.Font.Bold = true;
                ww.Text = "startDate";
                TableCell bb = new TableCell();
                bb.Font.Bold = true;
                bb.Text = "endDate";
                TableCell gg = new TableCell();
                gg.Font.Bold = true;
                gg.Text = "defenseDate";
                TableCell ee = new TableCell();
                ee.Font.Bold = true;
                ee.Text = "years";
                TableCell qq = new TableCell();
                qq.Font.Bold = true;
                qq.Text = "grade";
                TableCell we = new TableCell();
                we.Font.Bold = true;
                we.Text = "payment_id";
                TableCell xx = new TableCell();
                xx.Font.Bold = true;
                xx.Text = "noOfExtensions";

                TableRow tableRow = new TableRow();


                tableRow.Cells.Add(oo);
                tableRow.Cells.Add(hh);
                tableRow.Cells.Add(cc);
                tableRow.Cells.Add(rr);
                tableRow.Cells.Add(ww);
                tableRow.Cells.Add(bb);
                tableRow.Cells.Add(gg);
                tableRow.Cells.Add(ee);
                tableRow.Cells.Add(qq);
                tableRow.Cells.Add(we);
                tableRow.Cells.Add(xx);

                m.Rows.Add(tableRow);
                while (rdr.Read())
                {
                    String serialNumber = rdr["serialNumber"].ToString();
                    string field = rdr.GetString(rdr.GetOrdinal("field"));
                    string type = rdr.GetString(rdr.GetOrdinal("type"));
                    string title = rdr.GetString(rdr.GetOrdinal("title"));
                    string startDate = rdr.GetDateTime(rdr.GetOrdinal("startDate")).ToString("dd/MM/yyyy");
                    string endDate = rdr.GetDateTime(rdr.GetOrdinal("endDate")).ToString("dd/MM/yyyy");
                    string defenseDate = rdr.GetDateTime(rdr.GetOrdinal("defenseDate")).ToString("dd/MM/yyyy");
                    string years = rdr["years"].ToString();
                    string grade = rdr["grade"].ToString();
                    string payment_id = rdr["payment_id"].ToString();
                    string noOfExtensions = rdr["noOfExtensions"].ToString();



                    TableRow row = new TableRow();


                    TableCell h = new TableCell();
                    h.Text = serialNumber;
                    TableCell y = new TableCell();
                    y.Text = field;
                    TableCell t = new TableCell();
                    t.Text = type;
                    TableCell n = new TableCell();
                    n.Text = title;
                    TableCell f = new TableCell();
                    f.Text = startDate;
                    TableCell mn = new TableCell();
                    mn.Text = endDate;
                    TableCell nm = new TableCell();
                    nm.Text = defenseDate;
                    TableCell pn = new TableCell();
                    pn.Text = years;
                    TableCell pn2 = new TableCell();
                    pn2.Text = grade;
                    TableCell pn3 = new TableCell();
                    pn3.Text = payment_id;
                    TableCell pn4 = new TableCell();
                    pn4.Text = noOfExtensions;
                    row.Cells.Add(h);
                    row.Cells.Add(y);
                    row.Cells.Add(t);
                    row.Cells.Add(n);
                    row.Cells.Add(f);
                    row.Cells.Add(mn);
                    row.Cells.Add(nm);
                    row.Cells.Add(pn);
                    row.Cells.Add(pn2);
                    row.Cells.Add(pn3);
                    row.Cells.Add(pn4);


                    m.Rows.Add(row);

                    form1.Controls.Add(m);
                }

            }
            else
            {
                Response.Write("Not Found !");
            }
        }
    }
}