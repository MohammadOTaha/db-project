using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace PostGradSystem
{
    public partial class AddPublication : System.Web.UI.Page
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
        static Dictionary<String, String> thesis_info;
        static Boolean linkPubToThesis = false;

        private static Boolean is_gucian(String user_id)
        {
            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            SqlCommand cmd = new SqlCommand(
                (
                    @"
                    IF EXISTS (SELECT * FROM GUCianStudent WHERE id = @user_id)
                        BEGIN
                            SET @is_gucian = 1;
                        END
                    ELSE 
                        BEGIN
                            SET @is_gucian = 0;
                        END
                    "
                ), 
                db_connection.getConnection());

            cmd.Parameters.AddWithValue("@user_id", user_id);
            cmd.Parameters.Add("@is_gucian", System.Data.SqlDbType.Bit);
            cmd.Parameters["@is_gucian"].Direction = System.Data.ParameterDirection.Output;

            cmd.ExecuteNonQuery();

            return Convert.ToBoolean(cmd.Parameters["@is_gucian"].Value);
        }

        private static SqlDataReader getStudentTheses(String user_id) 
        {
            if(is_gucian(user_id)) {
                SqlCommand cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title, T.serialNumber
                        FROM Thesis T
                        INNER JOIN GUCianRegisterThesis ST ON T.serialNumber = ST.thesisSerialNumber
                        WHERE ST.GUCianID = @user_id
                        "
                    ), 
                    db_connection.getConnection()
                );

                cmd.Parameters.AddWithValue("@user_id", user_id);

                return cmd.ExecuteReader();
            }
            else {
                SqlCommand cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title, T.serialNumber 
                        FROM Thesis T
                        INNER JOIN NonGUCianRegisterThesis ST ON T.serialNumber = ST.thesisSerialNumber
                        WHERE ST.NonGUCianID = @user_id
                        "
                    ), 
                    db_connection.getConnection()
                );

                cmd.Parameters.AddWithValue("@user_id", user_id);

                return cmd.ExecuteReader();
            }
        }

        protected void showLink(object sender, EventArgs e)
        {
            btn_showLinkPub.Visible = false;

            linkPubToThesis = true;

            int user_id = Convert.ToInt32(Session["user_id"]);

            if(user_id == 0) {
                Response.Redirect("~/Login.aspx");
            }
            else {
                if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                    db_connection.getConnection().Open();
                }
                        
                SqlDataReader reader = getStudentTheses(user_id.ToString());

                thesis_info = new Dictionary<String, String>();

                while(reader.Read()) {
                    String thesis_title = reader.GetString(0);
                    String thesis_serial_number = reader.GetInt32(1).ToString();

                    thesis_info.Add(thesis_title, thesis_serial_number);

                    thesis_dropList.Items.Add(thesis_title);
                }
                
                linkPubPanel.Visible = true;

                reader.Close();
            }

        }

        protected void addPublication(object sender, EventArgs e)
        {
            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            // execute stored procedure
            SqlCommand add_pub_sp = new SqlCommand("addPublication", db_connection.getConnection());
            add_pub_sp.CommandType = System.Data.CommandType.StoredProcedure;

            // add parameters
            add_pub_sp.Parameters.AddWithValue("@title", pub_title.Text);
            add_pub_sp.Parameters.AddWithValue("@pubDate", pub_date.Text);
            add_pub_sp.Parameters.AddWithValue("@host", pub_host.Text);
            add_pub_sp.Parameters.AddWithValue("@place", pub_place.Text);
            add_pub_sp.Parameters.AddWithValue("@accepted", rdoYes.Checked ? 1 : 0);

            // execute stored procedure
            add_pub_sp.ExecuteNonQuery();
            
            // get the last inserted publication id

            if(linkPubToThesis) {
                SqlCommand cmd = new SqlCommand(
                (
                    @"
                    SELECT TOP 1 id
                    FROM Publication
                    ORDER BY id DESC
                    "
                ), 
                    db_connection.getConnection()
                );

                int pub_id = Convert.ToInt32(cmd.ExecuteScalar());

                SqlCommand link_pub_thesis_sp = new SqlCommand("linkPubThesis", db_connection.getConnection());
                link_pub_thesis_sp.CommandType = System.Data.CommandType.StoredProcedure;

                link_pub_thesis_sp.Parameters.AddWithValue("@PubID", pub_id);
                link_pub_thesis_sp.Parameters.AddWithValue("@thesisSerialNo", thesis_info[thesis_dropList.SelectedItem.Text]);

                link_pub_thesis_sp.ExecuteNonQuery();
            }   
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["user_id"] == null) {
                Response.Redirect("~/Login.aspx");
            }
        }
    }
}