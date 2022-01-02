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
    public partial class ExaminerPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void editExaminer(object sender, EventArgs e)
        {
            String connStr = WebConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            string name = namex.Text;
            String Field = field.Text;
            int id = Convert.ToInt32(Session["user_id"]);

            if (namex.Text != "" && field.Text != "")
            {
                SqlCommand editProc = new SqlCommand("editExaminer", conn);
                editProc.CommandType = CommandType.StoredProcedure;

                editProc.Parameters.Add(new SqlParameter("@ID", id));
                editProc.Parameters.Add(new SqlParameter("@Name", name));
                editProc.Parameters.Add(new SqlParameter("@Field", Field));

                //SqlParameter sucess = loginProc.Parameters.Add("@success", SqlDbType.Bit);

                //SqlParameter type = loginProc.Parameters.Add("@type", SqlDbType.Int);

                //sucess.Direction = System.Data.ParameterDirection.Output;
                //type.Direction = System.Data.ParameterDirection.Output;
                conn.Open();
                editProc.ExecuteNonQuery();
                conn.Close();

                Response.Write("Done!");

            }
            else
            {
                Response.Write("Missing INformation !!");
            }
        }



        protected void addGrade(object sender, EventArgs e)
        {
            String connStr = WebConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            int serialNO = short.Parse(serialNo.Text);
            DateTime date = Convert.ToDateTime(dateGrade.Text);
            decimal Grade = decimal.Parse(grade.Text);

            if (serialNo.Text != "" && dateGrade.Text != "" && grade.Text != "")
            {
                SqlCommand addGrade = new SqlCommand("AddDefenseGrade", conn);
                addGrade.CommandType = CommandType.StoredProcedure;

                addGrade.Parameters.Add(new SqlParameter("@ThesisSerialNo", serialNO));
                addGrade.Parameters.Add(new SqlParameter("@DefenseDate", date));
                addGrade.Parameters.Add(new SqlParameter("@grade", Grade));

                SqlParameter sucess = addGrade.Parameters.Add("@success", SqlDbType.Bit);

                //SqlParameter type = loginProc.Parameters.Add("@type", SqlDbType.Int);

                sucess.Direction = System.Data.ParameterDirection.Output;
                //type.Direction = System.Data.ParameterDirection.Output;
                conn.Open();
                addGrade.ExecuteNonQuery();
                conn.Close();
                if (sucess.Value.ToString() == "True")
                {
                    Response.Write("Done!");
                }
                else
                {
                    Response.Write("Wrong Thesis Number!");

                }



            }
            else
            {
                Response.Write("Missing INformation !!");
            }
        }

        protected void Button4_Click(object sender, EventArgs e)
        {
            String connStr = WebConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            int serialNO = Int16.Parse(thesisSerialNO.Text);
            DateTime date = Convert.ToDateTime(Date.Text);
            String Comment = comment.Text;

            if (thesisSerialNO.Text != "" && Date.Text != "" && comment.Text != "")
            {
                SqlCommand addComment = new SqlCommand("AddCommentsGrade", conn);
                addComment.CommandType = CommandType.StoredProcedure;

                addComment.Parameters.Add(new SqlParameter("@ThesisSerialNo", serialNO));
                addComment.Parameters.Add(new SqlParameter("@DefenseDate", date));
                addComment.Parameters.Add(new SqlParameter("@comments", Comment));

                SqlParameter sucess = addComment.Parameters.Add("@success", SqlDbType.Bit);

                //SqlParameter type = loginProc.Parameters.Add("@type", SqlDbType.Int);

                sucess.Direction = System.Data.ParameterDirection.Output;
                //type.Direction = System.Data.ParameterDirection.Output;
                conn.Open();
                addComment.ExecuteNonQuery();
                conn.Close();
                if (sucess.Value.ToString() == "True")
                {
                    Response.Write("Done!");
                }
                else
                {
                    Response.Write("Wrong Thesis Number!");

                }



            }
            else
            {
                Response.Write("Missing INformation !!");
            }
        }

        protected void search(object sender, EventArgs e)
        {
            Session["title"] = keyWord.Text;
            Response.Redirect("ThesisFound.aspx");
        }
    }
}