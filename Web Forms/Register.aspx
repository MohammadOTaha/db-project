<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="PostGradSystem.Register" %>

  <!DOCTYPE html>

  <html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <title>Student Register</title>
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
                      REGISTER
                    </p>

                    <form class="mx-1 mx-md-4" runat="server">
                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="text" ID="firstname" class="form-control" runat="server"
                            placeholder="First Name" required="true" maxlength="20" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="text" ID="lastname" class="form-control" runat="server"
                            placeholder="Last Name" required="true" maxlength="20" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="email" ID="email" class="form-control" runat="server"
                            placeholder="Email Address" required="true" maxlength="255" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="password" ID="password" class="form-control" runat="server"
                            placeholder="Password" required="true" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="text" ID="address" class="form-control" runat="server"
                            placeholder="Address" required="true" maxlength="50" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="text" ID="faculty" class="form-control" runat="server"
                            placeholder="Faculty" required="true" maxlength="10" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <asp:DropDownList ID="usertypedroplist" runat="server"
                          CssClass="form-control form-outline flex-fill mb-0"
                          onselectedindexchanged="usertype_SelectedIndexChanged" AutoPostBack="True">
                          <asp:ListItem>Select User Type</asp:ListItem>
                          <asp:ListItem>GUCian</asp:ListItem>
                          <asp:ListItem>Non-GUCian</asp:ListItem>
                          <asp:ListItem>Supervisor</asp:ListItem>
                          <asp:ListItem>Examiner</asp:ListItem>
                          <asp:ListItem>Admin</asp:ListItem>
                        </asp:DropDownList>

                        <asp:TextBox type="text" ID="underGradID" class="form-control" runat="server"
                          placeholder="Under Graduate ID" required="true" maxlength="50" visible="false" />
                      </div>


                      <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                        <asp:Button ID="btn_register" runat="server" Text="Register" onClick="register"
                          class="btn btn-primary btn-lg" />
                      </div>
                    </form>
                  </div>
                  <div class="
                      col-md-10 col-lg-6 col-xl-7
                      d-flex
                      align-items-center
                      order-1 order-lg-2
                    ">
                    <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-registration/draw1.webp"
                      class="img-fluid" alt="Sample image" />
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