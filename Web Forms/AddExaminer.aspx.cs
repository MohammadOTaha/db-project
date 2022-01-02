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
        static Dictionary<int, int> thesis_info = new Dictionary<int, int>();
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
            else if (!Page.IsPostBack)
            {
                thesis_info.Clear();
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
                addingThesis(ref thesis_dropdownList, Convert.ToInt32(Session["user_id"]));

            }

        }


        protected void add_examiner_Click(object sender, EventArgs e)
        {
            //Get the selected thesisId
            int thesisId = 4;
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
            cmd2.Parameters.AddWithValue("@Success", System.Data.SqlDbType.Bit).Direction = System.Data.ParameterDirection.Output;
            db_connection.getConnection().Open();
            cmd2.ExecuteNonQuery();
            //Check if success
            db_connection.getConnection().Close();
            if (Convert.ToBoolean(cmd2.Parameters["@Success"].Value))
            {
                panel1.Visible = true;
              
               
            }
            else
            {
                Response.Write("<script>alert('There is already an Examiner')</script>");

            }
            
            //Set visibilty of panel is tryue
           
            //Redirect to addingExaminer page


        }
        private static void addingThesis(ref DropDownList thesis_dropdownList, int superVisorID)
        {
            SqlCommand cmd =
                new SqlCommand(@"select serialNumber ,title,email From Thesis INNER JOIN GUCianRegisterThesis on GUCianRegisterThesis.thesisSerialNumber = Thesis.serialNumber INNER JOIN PostGradUser on PostgradUser.id = GucianRegisterThesis.GucianID WHERE GUCianRegisterThesis.supervisor_id = @superVisorID
                                   UNION Select serialNumber,title,email From Thesis INNER JOIN NONGUCianRegisterThesis on NONGUCianRegisterThesis.thesisSerialNumber = Thesis.serialNumber INNER JOIN PostGradUser on PostgradUser.id = NonGucianRegisterThesis.NonGUCianID WHERE NONGUCianRegisterThesis.supervisor_id = @superVisorID", db_connection.getConnection());

            cmd.Parameters.AddWithValue("@superVisorID", superVisorID);


            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }
            SqlDataReader reader = cmd.ExecuteReader();



            //while there is a next row
            int idx = 1;
            while (reader.Read())
            {
                //add the email to the dropdown list
                thesis_dropdownList.Items.Add(reader.GetString(1) + ", " + reader.GetString(2));
                //Check if the thesis is already in the dict
              
                    //add the thesis id to the dict
                    thesis_info.Add(idx, reader.GetInt32(0));
                    idx++;
               



            }
            reader.Close();
            db_connection.getConnection().Close();

        }
        protected void defenseDateSelection(object sender, EventArgs e)
        {

            if (date_dropdownList.SelectedValue != "Select Thesis")
            {
                date_dropdownList.Items.Clear();
                SqlCommand cmd = new SqlCommand(@"Select date from Defense where thesisSerialNumber = @thesisSerialNumber", db_connection.getConnection());
                cmd.Parameters.AddWithValue("@thesisSerialNumber", thesis_info[thesis_dropdownList.SelectedIndex]);
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