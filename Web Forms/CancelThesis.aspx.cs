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
    public partial class CancelThesis : System.Web.UI.Page
    {
        static DBConnection db_connection = new DBConnection();
        static Dictionary<int, int> thesis_info;

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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user_id"] == null)
            {
                Response.Redirect("login.aspx");
            }
            if (!Page.IsPostBack)
            {
                addingThesis(ref thesis_dropdownList, Convert.ToInt32(Session["user_id"]));
            }
            //Check if session contains the user_id


        }
        //Make dictiornary save in it the idx and serial number of thesis



        private static void addingThesis(ref DropDownList thesis_dropdownList, int superVisorID)
        {
            SqlCommand cmd =
                new SqlCommand(@"SELECT T1.serialNumber,T1.title,PostGraduser.email 
             FROM GUCianRegisterThesis
        INNER JOIN PostGradUser on PostGradUser.id = GucianRegisterThesis.GucianID
        INNER JOIN Thesis T1 on T1.serialNumber = GUCianRegisterThesis.thesisSerialNumber
        INNER JOIN GUCianStudent ON GUCianStudent.id = GUCianRegisterThesis.GUCianID
        WHERE T1.endDate > GETDATE() and GucianRegisterThesis.supervisor_id = @superVisorID
    
    UNION
    
     SELECT T2.serialNumber,T2.title,PostGraduser.email 
    FROM NonGUCianRegisterThesis
        INNER JOIN PostGradUser on PostGradUser.id = NonGucianRegisterThesis.NonGucianID
        INNER JOIN Thesis T2 on T2.serialNumber = NonGUCianRegisterThesis.thesisSerialNumber
        INNER JOIN NonGUCianStudent ON NonGUCianStudent.id = NonGUCianRegisterThesis.NonGUCianID
        WHERE T2.endDate > GETDATE() and NonGucianRegisterThesis.supervisor_id = @superVisorID", db_connection.getConnection());

            cmd.Parameters.AddWithValue("@superVisorID", superVisorID);


            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }
            SqlDataReader reader = cmd.ExecuteReader();


            thesis_info = new Dictionary<int, int>();
            //while there is a next row
            int idx = 1;
            while (reader.Read())
            {
                //add the email to the dropdown list
                thesis_dropdownList.Items.Add(reader.GetString(1) + ", " + reader.GetString(2));
                //Check if the thesis is already in the dict
                if (!thesis_info.ContainsKey(idx))
                {
                    //add the thesis id to the dict
                    thesis_info.Add(idx, reader.GetInt32(0));
                    idx++;
                }



            }
            reader.Close();
            db_connection.getConnection().Close();

        }

        protected void cancel_thesis_Click(object sender, EventArgs e)
        {
            int thesis_id = thesis_info[thesis_dropdownList.SelectedIndex];
            int supervisor_id = Convert.ToInt32(Session["user_id"]);


            //Check if thesis_id Exsits in GUcianProgressReport
            SqlCommand cmd =
                new SqlCommand(@"Select * from GUcianProgressReport where thesisSerialNumber = @thesisSerialNumber",
                    db_connection.getConnection());
            cmd.Parameters.AddWithValue("@thesisSerialNumber", thesis_id);

            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
            {
                db_connection.getConnection().Open();
            }


            SqlDataReader reader = cmd.ExecuteReader();
            //Open connection if its closed


            if (reader.HasRows)
            {
                reader.Close();

                //Use cancel thesis proc



                //Get evaluation of the last Progress Report from GucianProgressReport
                SqlCommand cmd2 =
                    new SqlCommand(@"Select TOP 1 evaluation from GUcianProgressReport where thesisSerialNumber = @thesisSerialNumber ORDER BY date DESC",
                        db_connection.getConnection());
                cmd2.Parameters.AddWithValue("@thesisSerialNumber", thesis_id);
                //If the connection is closed open it
                if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
                {
                    db_connection.getConnection().Open();
                }




                int eval = -1;
                //Open the connection if its closed

                object a = cmd2.ExecuteScalar();
                if (a != null)
                    eval = (int)a;

                if (eval == 0)
                {
                    SqlCommand cmd1 =
                 new SqlCommand(@"exec cancelThesis @thesisSerialNumber",
                     db_connection.getConnection());
                    cmd1.Parameters.AddWithValue("@thesisSerialNumber", thesis_id);
                    if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
                    {
                        db_connection.getConnection().Open();
                    }
                    cmd1.ExecuteNonQuery();

                    Response.Write("<script>alert('Thesis Deleted');</script>");
                }
                else
                {
                    Response.Write("<script>alert('DEEEE Deleted');</script>");
                }
            }
            else
            {



                //Check if thesis_id exsits in NonGucianProgress Report
                SqlCommand cmd2 =
                    new SqlCommand(@"Select * from NonGucianProgressReport where thesisSerialNumber = @thesisSerialNumber",
                        db_connection.getConnection());
                cmd2.Parameters.AddWithValue("@thesisSerialNumber", thesis_id);
                if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
                {
                    db_connection.getConnection().Open();
                }
                SqlDataReader reader2 = cmd2.ExecuteReader();
                if (reader2.HasRows)
                {
                    reader2.Close();
                    //Use cancel thesis proc


                    SqlCommand cmd4 =
                        new SqlCommand(@"Select  TOP 1 evaluation from NonGucianProgressReport where thesisSerialNumber = @thesisSerialNumber ORDER BY date DESC",
                            db_connection.getConnection());
                    cmd4
                        .Parameters
                        .AddWithValue("@thesisSerialNumber", thesis_id);
                    if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
                    {
                        db_connection.getConnection().Open();
                    }
                    int eval = -1;
                    object a = cmd4.ExecuteScalar();
                    if (a != null)
                        eval = (int)a;

                    if (eval == 0)
                    {
                        SqlCommand cmd3 =
                      new SqlCommand(@"exec cancelThesis @thesisSerialNumber",
                          db_connection.getConnection());
                        cmd3
                            .Parameters
                            .AddWithValue("@thesisSerialNumber", thesis_id);
                        if (db_connection.getConnection().State == System.Data.ConnectionState.Closed)
                        {
                            db_connection.getConnection().Open();
                        }
                        cmd3.ExecuteNonQuery();

                        Response
                            .Write("<script>alert('Thesis Deleted');</script>");
                       
                        addingThesis(ref thesis_dropdownList, Convert.ToInt32(Session["user_id"]));
                    }
                    else
                    {
                        Response.Write("<script>alert('Can't BE  Deleted');</script>");
                    }

                }
                else
                {
                    Response
                        .Write("<script>alert('Thesis does not exist');</script>");
                }
            }
        }
    }
}
