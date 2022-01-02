<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddDefense.aspx.cs" Inherits="PostGradSystem.AddDefense" %>

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
                    ADD DEFENSE
                  </p>

                  <form class="mx-1 mx-md-4" runat="server">
                    <div class="d-flex flex-row align-items-center mb-4">
                      <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                      <div class="form-outline flex-fill mb-0">
                        <asp:TextBox type="date" textmode="Date" ID="defense_date" class="form-control" runat="server"
                          placeholder="Defense Date" required="true" />
                      </div>
                    </div>



                     <div class="form-group">
                                              <div class="form-outline flex-fill mb-0">
                                                  <label for="thesis_dropdown">Thesis</label>
                                                  <asp:DropDownList runat="server" CssClass="form-control"
                                                      ID="thesis_dropdownList">
                                                     
                                                      <asp:ListItem selected hidden>Select Thesis</asp:ListItem>
                                                  </asp:DropDownList>
                                              </div>

                                          </div>
                      <br />
                      <br />


                    <div class="d-flex flex-row align-items-center mb-4">
                      <i class="fas fa-user fa-lg me-3 fa-fw"></i>
                      <div class="form-outline flex-fill mb-0">
                        <asp:TextBox type="text" ID="defense_location" class="form-control" runat="server"
                          placeholder="Defense Location" required="true" />
                      </div>
                    </div>

                    <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                      <asp:Button ID="add_defense" runat="server" Text="Add Defense" onClick="add_defense_Click"
                        class="btn btn-primary btn-lg" style="width: 360px" />
                    </div>
                    <asp:panel id="panel1" runat="server" visible="false">


                      <div class="alert alert-success alert-dismissible" id="divbox">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                        <strong>Success!</strong> You Added An Examiner.



                      </div>
                    </asp:panel>
                    <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                      <a class="btn btn-warning" href="Home.aspx" role="button">Go Back</a>
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