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
        }

        protected void add_defense_Click(object sender, EventArgs e)
        {
            int serial_number = Int32.Parse(thesis_serial.Text);
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