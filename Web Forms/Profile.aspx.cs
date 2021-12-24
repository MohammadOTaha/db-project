using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Configuration;

namespace PostGradSystem
{
    public partial class Profile : System.Web.UI.Page
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

        private static String getUserType(String user_id)
        {
            SqlCommand cmd = new SqlCommand(
                (
                    @"IF EXISTS (SELECT * FROM GUCianStudent WHERE id = @user_id)
                    BEGIN
                        SET @type = 'GUCian';
                    END
                    ELSE IF EXISTS (SELECT * FROM NonGUCianStudent WHERE id = @user_id)
                    BEGIN
                        SET @type = 'NonGUCian';
                    END
                    ELSE IF EXISTS (SELECT * FROM Examiner WHERE id = @user_id)
                    BEGIN
                        SET @type = 'Examiner';
                    END
                    ELSE IF EXISTS (SELECT * FROM Supervisor WHERE id = @user_id)
                    BEGIN
                        SET @type = 'Supervisor';
                    END
                    ELSE 
                    BEGIN
                        SET @type = 'Admin';
                    END"
                ), 
                db_connection.getConnection());

            cmd.Parameters.AddWithValue("@user_id", user_id);
            cmd.Parameters.Add("@type", System.Data.SqlDbType.VarChar, 50);
            cmd.Parameters["@type"].Direction = System.Data.ParameterDirection.Output;

            cmd.ExecuteNonQuery();

            return cmd.Parameters["@type"].Value.ToString();
        }

        public static void insertUserInfo(ref Dictionary<String, String> user_info, SqlDataReader reader, String key)
        {
            if(reader[key] != DBNull.Value) user_info.Add(key, reader[key].ToString());
            else user_info.Add(key, null);
        }

        private static Dictionary<String, String> getUserInfo (String user_id, String user_type)
        {
            Dictionary<String, String> user_info = new Dictionary<String, String>();

            SqlCommand cmd = new SqlCommand(
                (
                    @"
                    IF @user_type = 'GUCian'
                        BEGIN
                            SELECT P.email email, S.firstName firstName, S.lastName lastName, S.faculty faculty, S.address address, S.GPA GPA, S.underGradID underGradID  
                            FROM GUCianStudent S
                            INNER JOIN PostGradUser P ON S.id = P.id
                            WHERE S.id = @user_id;
                        END
                    ELSE IF @user_type = 'NonGUCian'
                        BEGIN
                            SELECT P.email email, S.firstName firstName, S.lastName lastName, S.faculty faculty, S.address address, S.GPA GPA  
                            FROM NonGUCianStudent S
                            INNER JOIN PostGradUser P ON S.id = P.id
                            WHERE S.id = @user_id;
                        END
                    ELSE IF @user_type = 'Examiner'
                        BEGIN
                            SELECT PostGradUser.email email, Examiner.name name, Examiner.fieldOfWork fieldOfWork, Examiner.isNational isNational
                            FROM Examiner 
                            INNER JOIN PostGradUser ON Examiner.id = PostGradUser.id
                            WHERE Examiner.id = @user_id;
                        END
                    ELSE IF @user_type = 'Supervisor'
                        BEGIN
                            SELECT PostGradUser.email email, Supervisor.name name, Supervisor.faculty faculty
                            FROM Supervisor 
                            INNER JOIN PostGradUser ON Supervisor.id = PostGradUser.id
                            WHERE Supervisor.id = @user_id;
                        END
                    ELSE 
                        BEGIN
                            SELECT PostGradUser.email email
                            FROM Admin
                            INNER JOIN PostGradUser ON Admin.id = PostGradUser.id
                            WHERE Admin.id = @user_id;
                        END
                    "
                ), 
                db_connection.getConnection()
            );

            cmd.Parameters.AddWithValue("@user_id", user_id);
            cmd.Parameters.AddWithValue("@user_type", user_type);

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    insertUserInfo(ref user_info, reader, reader.GetName(i));
                }
            }

            return user_info;
        }
        
        private static void loadStudentInfo()
        {
            
        }

        private static void loadExaminerInfo()
        {

        }

        private static void loadSupervisorInfo()
        {

        }

        private static void loadAdminInfo()
        {

        }

        private static void writeToPage(ref HttpResponse r, Dictionary<String, String> user_info)
        {
            if(user_info.ContainsKey("email")) r.Write(user_info["email"] + "<br>");
            if(user_info.ContainsKey("firstName")) r.Write(user_info["firstName"] + "<br>");
            if(user_info.ContainsKey("lastName")) r.Write(user_info["lastName"] + "<br>");
            if(user_info.ContainsKey("faculty")) r.Write(user_info["faculty"] + "<br>");
            if(user_info.ContainsKey("address")) r.Write(user_info["address"] + "<br>");
            if(user_info.ContainsKey("GPA")) r.Write(user_info["GPA"] + "<br>");
            if(user_info.ContainsKey("underGradID")) r.Write(user_info["underGradID"] + "<br>");
            if(user_info.ContainsKey("name")) r.Write(user_info["name"] + "<br>");
            if(user_info.ContainsKey("fieldOfWork")) r.Write(user_info["fieldOfWork"] + "<br>");
            if(user_info.ContainsKey("isNational")) r.Write(user_info["isNational"] + "<br>");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int user_id = Convert.ToInt32(Session["user_id"]);

            if (user_id == 0) {
                Response.Redirect("Login.aspx");
            }
            else {
                db_connection.getConnection().Open();

                Dictionary<String, String> user_info = getUserInfo(user_id.ToString(), getUserType(user_id.ToString()));

                HttpResponse r = HttpContext.Current.Response;

                writeToPage(ref r, user_info);

                db_connection.getConnection().Close();
            }

        }
    }
}
