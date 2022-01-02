<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LinkPublication.aspx.cs"
    Inherits="PostGradSystem.LinkPublication" %>

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
                                            LINK PUBLICATION
                                        </p>

                                        <form class="mx-1 mx-md-4" runat="server">
                                            <div class="form-group">
                                                <div class="form-outline flex-fill mb-0">
                                                    <label for="publications_droplist">Publication</label>
                                                    <asp:DropDownList runat="server" CssClass="form-control"
                                                        ID="publications_droplist">
                                                        <asp:ListItem selected hidden>Select Publication</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                                </br>
                                            </div>

                                            <div class="form-group">
                                                <div class="form-outline flex-fill mb-0">
                                                    <label for="theses_droplist">Thesis</label>
                                                    <asp:DropDownList runat="server" CssClass="form-control"
                                                        ID="theses_droplist">
                                                        <asp:ListItem selected hidden>Select Thesis</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                                </br>
                                            </div>

                                            <div class="d-flex justify-content-center mx-4 mb-3 mb-lg-4">
                                                <asp:Button runat="server" Text="Link Publication"
                                                    onClick="linkPublication" class="btn btn-primary btn-lg" />
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