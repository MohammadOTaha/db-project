<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentPublications.aspx.cs" Inherits="PostGradSystem.StudentPublications" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
  <head runat="server">
    <title>Add Publication</title>
  </head>
  <body>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.min.js"></script>
    <section class="vh-100" style="background-color: #eee">
      <div class="container h-100">
        <div class="row d-flex justify-content-center align-items-center h-100">
          <div class="col-lg-12 col-xl-11">
            <div class="card text-black" style="border-radius: 25px">
              <div class="card-body p-md-5">
                <div class="row justify-content-center">
                  <div class="col-md-10 col-lg-6 col-xl-5 order-2 order-lg-1">
                    <p class="text-center h1 fw-bold mb-5 mx-1 mx-md-4 mt-4">
                     VIEW PUBLICATION
                    </p>

                    <form class="mx-1 mx-md-4" runat="server">               
                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                            Student ID
                          <asp:TextBox
                            type="number"
                            textmode="number"
                            ID="student_Id"
                            class="form-control"
                            runat="server"
                            placeholder="Student ID"
                            required="true"
                          />
                        </div>
                      </div>
                      <div
                        class="d-flex justify-content-center mx-4 mb-3 mb-lg-4"
                      >
                        <asp:Button
                          ID="btn_addReport"
                          runat="server"
                          Text="View Publications"
                          onClick="viewAllPublications"
                          class="btn btn-primary btn-lg"
                          style="width: 360px"
                        />
                      </div>
                          <div class="container" id="publicationsDiv" runat="server">
                             <div class="row">
                                
                             </div>
                                </div>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </body>
</html>