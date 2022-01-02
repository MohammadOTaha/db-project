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
    public partial class AddDefense : System.Web.UI.Page
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

        private static int is_gucian(int thesis_serial)
        {
            SqlCommand cmd = new SqlCommand((
                    @"
                    IF EXISTS (SELECT * FROM GUCianRegisterThesis WHERE GUCianRegisterThesis.thesisSerialNumber = @thesis_serial)
                        BEGIN
                            SET @is_gucian = 1;
                        END
                    ELSE IF EXISTS (SELECT * FROM NonGUcianRegisterThesis Where NonGUcianRegisterThesis.thesisSerialNumber=@thesis_serial)
                        BEGIN
                            SET @is_gucian = 0;
                        END
                        ELSE
                        BEGIN
                        SET @is_gucian=-1;
                        END 
                    "
                    ),
                    db_connection.getConnection()
                );

            cmd.Parameters.AddWithValue("@thesis_serial", thesis_serial);
            cmd.Parameters.Add("@is_gucian", System.Data.SqlDbType.Int);
            cmd.Parameters["@is_gucian"].Direction =
            System.Data.ParameterDirection.Output;
            db_connection.getConnection().Open();
            cmd.ExecuteNonQuery();
            db_connection.getConnection().Close();

            return Convert.ToInt16(cmd.Parameters["@is_gucian"].Value);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //Check if session user_Id is null
            if (Session["user_Id"] == null)
            {
                //Redirect to login page
                Response.Redirect("Login.aspx");
            }
            if (!Page.IsPostBack)
            {
                thesis_info.Clear();
                addingThesis(ref thesis_dropdownList, Convert.ToInt32(Session["user_id"]));
            }
        }

        protected void add_defense_Click(object sender, EventArgs e)
        {
            int serial_number = thesis_info[thesis_dropdownList.SelectedIndex];
            String defenseDate = defense_date.Text;
            String defenseLocation = defense_location.Text;

            // Looping Around The id and check if its gucian bit or not

            int isGucian = is_gucian(serial_number);

            if (isGucian == 1)
            {
                SqlCommand cmd = new SqlCommand("AddDefenseGucian", db_connection.getConnection());
                cmd.Parameters.Add(new SqlParameter("@thesisSerialNo", serial_number));
                cmd.Parameters.Add(new SqlParameter("@defenseDate", defenseDate));
                cmd.Parameters.Add(new SqlParameter("@defenseLocation", defenseLocation));
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                db_connection.getConnection().Open();
                panel1.Visible = true;
                cmd.ExecuteNonQuery();

                db_connection.getConnection().Close();
            }
            else if (isGucian == 0)
            {
                //AddDefenseNonGucian and Success Bit
                SqlCommand cmd = new SqlCommand("AddDefenseNonGucian",db_connection.getConnection());
                cmd.Parameters.Add(new SqlParameter("@thesisSerialNo", serial_number));
                cmd.Parameters.Add(new SqlParameter("@defenseDate", defenseDate));
                cmd.Parameters.Add(new SqlParameter("@defenseLocation", defenseLocation));
                cmd.Parameters.Add(new SqlParameter("@Success",System.Data.SqlDbType.Bit));
                cmd.Parameters["@Success"].Direction = System.Data.ParameterDirection.Output;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                db_connection.getConnection().Open();
                cmd.ExecuteNonQuery();
                db_connection.getConnection().Close();
                if (Convert.ToBoolean(cmd.Parameters["@Success"].Value))
                {
                    panel1.Visible = true;
                }
            }
            else
            {
                Response.Write("<script>alert('Defense Adding Failed')</script>");
            }
        }
    }
}