<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PostGradSystem.Login" %>

  <!DOCTYPE html>

  <html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.min.js"></script>

    <title>Student Login</title>
  </head>

  <body>
    <form id="form1" runat="server">
      <section class="vh-100" style="background-color: #eee">
        <div class="container h-100">
          <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="col-lg-12 col-xl-11">
              <div class="card text-black" style="border-radius: 25px">
                <div class="card-body p-md-5">
                  <div class="row justify-content-center">
                    <div class="col-md-10 col-lg-6 col-xl-5 order-2 order-lg-1">
                      <p class="text-center h1 fw-bold mb-5 mx-1 mx-md-4 mt-4">
                        Login
                      </p>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-envelope fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox TextMode="email" runat="server" id="in_email" class="form-control"></asp:TextBox>

                          <label class="form-label" for="form3Example3c">Your Email</label>
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-lock fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox TextMode="password" runat="server" id="in_pass" class="form-control">
                          </asp:TextBox>
                          <label class="form-label" for="form3Example4c">Password</label>
                        </div>
                      </div>

                      <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                        <asp:Button ID="btnLogin" runat="server" OnClick="login" Text="Log In"
                          class="btn btn-primary btn-lg" style="width: 300px; font-size: 16pt;" />
                      </div>

                      <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                        <a class="btn btn-warning" href="Register.aspx" role="button" style="width: 300px; font-size: 16pt;">Register</a>
                      </div>
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
    </form>
  </body>

  </html>