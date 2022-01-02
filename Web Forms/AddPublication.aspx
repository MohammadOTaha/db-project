<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddPublication.aspx.cs"
  Inherits="PostGradSystem.AddPublication" %>

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
                      ADD PUBLICATION
                    </p>

                    <form class="mx-1 mx-md-4" runat="server">
                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="text" ID="pub_title" class="form-control" runat="server"
                            placeholder="Publication Title" required="true" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="date" textmode="Date" ID="pub_date" class="form-control" runat="server"
                            placeholder="Publication Date" required="true" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="text" ID="pub_host" class="form-control" runat="server"
                            placeholder="Publication Host" required="true" />
                        </div>
                      </div>

                      <div class="d-flex flex-row align-items-center mb-4">
                        <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                        <div class="form-outline flex-fill mb-0">
                          <asp:TextBox type="text" ID="pub_place" class="form-control" runat="server"
                            placeholder="Publication Place" required="true" />
                        </div>
                      </div>

                      <div class="form-row form-check-inline ">
                        <div class="d-flex flex-row align-items-center mb-4">
                          <div class="form-check form-check-inline">
                            <asp:RadioButton ID="rdoYes" runat="server" Text="Accepted" GroupName="rdo_accepted" />
                          </div>

                          <div class="form-check form-check-inline">
                            <asp:RadioButton ID="rdoNo" runat="server" Text="Not Accepted" GroupName="rdo_accepted" />
                          </div>
                        </div>

                        <asp:panel id="linkPubPanel" runat="server" visible="false">
                          <div class="d-flex flex-row align-items-center mb-4">
                            <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                            <asp:DropDownList ID="thesis_dropList" class="form-control" runat="server"
                              AutoPostBack="False" style="width: 100%">
                            </asp:DropDownList>

                            <label class="form-label" for="thesis_dropList">Your Email</label>
                          </div>
                        </asp:panel>

                        <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-15">
                          <asp:Button ID="btn_showLinkPub" runat="server" Text="Link Publication to Thesis"
                            onClick="showLink" class="btn btn-success btn-lg" style="width: 360px" />
                        </div>

                        <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                          <asp:Button ID="btn_register" runat="server" Text="Add Publication" onClick="addPublication"
                            class="btn btn-primary btn-lg" style="width: 360px" />
                        </div>
                    </form>

                    <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                      <a class="btn btn-warning" href="Home.aspx" role="button">Go Back</a>
                    </div>
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