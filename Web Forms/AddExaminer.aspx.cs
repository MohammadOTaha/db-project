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
    public partial class AddExaminer : System.Web.UI.Page
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
            if (Session["user_Id"] == null)
            {
                Response.Redirect("login.aspx");
            }
            SqlCommand cmd1 = new SqlCommand(@"Select PostGradUser.email
                                    From Examiner Inner JOIN 
                                    PostGradUser On PostGradUser.id = Examiner.id", db_connection.getConnection());
            db_connection.getConnection().Open();
            SqlDataReader emails = cmd1.ExecuteReader();

            if (emails != null)
            {
                while (emails.Read())
                {

                    String email = emails.GetString(0);
                    Console.Write(email);
                    //Check if email is not in the dropdownlist
                    if (!examiners_dropdownList.Items.Contains(new ListItem(email)))
                    {
                        //Add email to dropdownlist
                        examiners_dropdownList.Items.Add(email);
                    }



                }
            }
            db_connection.getConnection().Close();
            SqlCommand cmd2 = new SqlCommand(@"Select thesisSerialNumber from Defense", db_connection.getConnection());
            db_connection.getConnection().Open();
            SqlDataReader thesisIDs = cmd2.ExecuteReader();
            if (thesisIDs != null)
            {
                while (thesisIDs.Read())
                {
                    int id = thesisIDs.GetInt32(0);
                    //Check if id already exists in dropdownlist
                    if (!thesis_dropdownList.Items.Contains(new ListItem(id.ToString())))
                    {
                        thesis_dropdownList.Items.Add(id.ToString());
                    }


                }
            }
            db_connection.getConnection().Close();


        }

        protected void add_examiner_Click(object sender, EventArgs e)
        {
            //Get the selected thesisId
            int thesisId = Convert.ToInt32(thesis_dropdownList.SelectedValue);
            //Get the selected email
            String email = examiners_dropdownList.SelectedValue;
            //Get the examiner with this email
            SqlCommand cmd = new SqlCommand(@"Select id from PostGradUser where email = @email", db_connection.getConnection());
            cmd.Parameters.AddWithValue("@email", email);
            db_connection.getConnection().Open();
            int examiner_id = (int)cmd.ExecuteScalar();
            db_connection.getConnection().Close();

            //Get the selected date
            String date = date_dropdownList.SelectedValue;
            System.Diagnostics.Debug.WriteLine("------------------------");
            System.Diagnostics.Debug.WriteLine(date);

            //Call the procedure to add examiner
            SqlCommand cmd2 = new SqlCommand(@"AddExaminer", db_connection.getConnection());
            cmd2.CommandType = System.Data.CommandType.StoredProcedure;
            cmd2.Parameters.AddWithValue("@thesisSerialNo", thesisId);
            cmd2.Parameters.AddWithValue("@ExaminerID", examiner_id);
            cmd2.Parameters.AddWithValue("@DefenseDate", date);
            db_connection.getConnection().Open();
            cmd2.ExecuteNonQuery();
            db_connection.getConnection().Close();
            //Set visibilty of panel is tryue
            panel1.Visible = true;
            //Redirect to addingExaminer page


        }

        protected void defenseDateSelection(object sender, EventArgs e)
        {

            if (date_dropdownList.SelectedValue != "Select Thesis")
            {
                date_dropdownList.Items.Clear();
                SqlCommand cmd = new SqlCommand(@"Select date from Defense where thesisSerialNumber = @thesisSerialNumber", db_connection.getConnection());
                cmd.Parameters.AddWithValue("@thesisSerialNumber", thesis_dropdownList.SelectedValue);
                db_connection.getConnection().Open();
                SqlDataReader dates = cmd.ExecuteReader();
                if (dates != null)
                {
                    while (dates.Read())
                    {
                        String date_of_defense = (dates["date"]).ToString();
                        date_dropdownList.Items.Add(date_of_defense);
                    }
                }
                //set visibility of date dropdownlist  
                date_dropdownList.Visible = true;
                db_connection.getConnection().Close();
            }

        }

        protected void goBack(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx");
        }

    }
}