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
    public partial class LinkPublication : System.Web.UI.Page
    {

        static DBConnection db_connection = new DBConnection();
        static Dictionary<int, int> thesis_info;
        static Dictionary<int, int> publication_info;
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

        private static SqlDataReader getStudentTheses(String user_id, String user_type)
        {
            if (db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            SqlCommand cmd;
            
            if(user_type == "GUCian") {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title, T.serialNumber
                        FROM Thesis T
                        INNER JOIN GUCianRegisterThesis ST ON T.serialNumber = ST.thesisSerialNumber
                        WHERE ST.GUCianID = @studentID
                        "
                    ), 
                    db_connection.getConnection()
                );
            }
            else {
                cmd = new SqlCommand(
                    (
                        @"
                        SELECT T.title, T.serialNumber 
                        FROM Thesis T
                        INNER JOIN NonGUCianRegisterThesis ST ON T.serialNumber = ST.thesisSerialNumber
                        WHERE ST.NonGUCianID = @studentID
                        "
                    ), 
                    db_connection.getConnection()
                );
            }

            cmd.Parameters.AddWithValue("@studentID", user_id);

            return cmd.ExecuteReader();
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
                        SELECT P.id, P.title
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
                        SELECT P.id, P.title
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

        private static void fillThesesDropList(String user_id, String user_type, ref DropDownList thesis_droplist)
        {
            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }
                        
            SqlDataReader reader = getStudentTheses(user_id, user_type);

            thesis_info = new Dictionary<int, int>();

            int idx = 1;
            while(reader.Read()) {
                String thesis_title = reader.GetString(0);
                int thesis_serial_number = reader.GetInt32(1);

                thesis_info.Add(idx, thesis_serial_number);

                thesis_droplist.Items.Add(thesis_title);

                idx++;
            }

            reader.Close();
        }

        private static void fillPublicationsDropList(String user_id, String user_type, ref DropDownList publications_droplist)
        {
            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            SqlDataReader reader = getStudentPublications(user_id, user_type);

            publication_info = new Dictionary<int, int>();

            int idx = 1;
            while(reader.Read()) {
                String publication_title = reader.GetString(1);
                int publication_id = reader.GetInt32(0);

                publication_info.Add(idx, publication_id);

                publications_droplist.Items.Add(publication_title);

                idx++;
            }

            reader.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["user_id"] == null) {
                Response.Redirect("~/Login.aspx");
            }
            else {
                if(!IsPostBack) {
                    String user_id = Session["user_id"].ToString();
                    String user_type = Session["user_type"].ToString();

                    fillThesesDropList(user_id, user_type, ref theses_droplist);
                    fillPublicationsDropList(user_id, user_type, ref publications_droplist);
                }
            }

        }

        protected void linkPublication(object sender, EventArgs e)
        {
            if(db_connection.getConnection().State == System.Data.ConnectionState.Closed) {
                db_connection.getConnection().Open();
            }

            int pub_id = publication_info[publications_droplist.SelectedIndex];
            int thesis_serial_number = thesis_info[theses_droplist.SelectedIndex];

            SqlCommand link_pub_thesis_sp = new SqlCommand("linkPubThesis", db_connection.getConnection());
            link_pub_thesis_sp.CommandType = System.Data.CommandType.StoredProcedure;

            link_pub_thesis_sp.Parameters.AddWithValue("@PubID", pub_id);
            link_pub_thesis_sp.Parameters.AddWithValue("@thesisSerialNo", thesis_serial_number);

            link_pub_thesis_sp.ExecuteNonQuery();
        }
    }
}