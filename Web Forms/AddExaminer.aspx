<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddExaminer.aspx.cs" Inherits="PostGradSystem.AddExaminer" %>

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
                                            Add Examiner
                                        </p>

                                        <form class="mx-1 mx-md-4" runat="server">
                                            <div class="form-group">
                                                <div class="form-outline flex-fill mb-0">
                                                    <label for="examiners_dropdown">Thesis</label>
                                                    <asp:DropDownList runat="server" CssClass="form-control"
                                                        ID="thesis_dropdownList"
                                                        OnSelectedIndexChanged="defenseDateSelection"
                                                        AutoPostBack="true">
                                                        <asp:ListItem selected hidden>Select Examiner</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>

                                            </div>
                                            <br />
                                            <br />

                                            <div class="form-group">
                                                <div class="form-outline flex-fill mb-0">
                                                    <label for="examiners_dropdown">Examiner</label>
                                                    <asp:DropDownList runat="server" CssClass="form-control"
                                                        ID="examiners_dropdownList">
                                                        <asp:ListItem selected hidden>Select Examiner</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>

                                            </div>
                                            <br />
                                            <br />
                                            <div class="form-group">
                                                <div class="form-outline flex-fill mb-0">

                                                    <asp:DropDownList runat="server" Visible="false"
                                                        CssClass="form-control" ID="date_dropdownList">
                                                        <asp:ListItem selected hidden>Select Examiner</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                                </br>
                                            </div>


                                            <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                                                <asp:Button runat="server" Text="Add Examiner"
                                                    onClick="add_examiner_Click" class="btn btn-primary btn-lg" />
                                            </div>
                                          <asp:panel id="panel1" runat="server" visible="false">
                                               
                                          
                                            <div class="alert alert-success alert-dismissible" id="divbox" >
                                                <a href="#" class="close" data-dismiss="alert"
                                                    aria-label="close">&times;</a>
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