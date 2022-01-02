<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="PostGradSystem.Profile" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <style>
      /* Remove the navbar's default rounded borders and increase the bottom margin */
      .navbar {
        margin-bottom: 50px;
        border-radius: 0;
      }

      /* Remove the jumbotron's default bottom margin */
      .jumbotron {
        margin-bottom: 0;
      }

      /* Add a gray background color and some padding to the footer */
      footer {
        background-color: #f2f2f2;
        padding: 25px;
      }
    </style>
  </head>

  <body>
    <div class="jumbotron">
      <div class="container text-center">
        <h1>German University in Cairo</h1>
      </div>
    </div>
    <nav class="navbar navbar-inverse">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Student Courses</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
          <ul class="nav navbar-nav navbar-right">
            <li>
              <a href="Home.aspx">
                <span class="glyphicon glyphicon-home"></span> Home
              </a>
            </li>
            <li>
              <a href="Profile.aspx">
                <span class="glyphicon glyphicon-user"></span> My Account
              </a>
            </li>
            <li>
              <a href="Logout.aspx">
                <span class="glyphicon glyphicon-log-out"></span>Logout
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
    <div class="container" id="profileDiv" runat="server">
      <div class="row"></div>
    </div>
    <form runat="server">
      <div class="container bg-light">
        <div class="col-md-12 text-center">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal1"
            data-whatever="@mdo">Edit My Profile</button>
          <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#exampleModal"
            data-whatever="@mdo">Add Phone Number</button>
          <asp:panel id="phone_numberpanel" runat="server" visible="false">
            <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#exampleModal2"
              data-whatever="@mdo">Show My Students</button>
          </asp:panel>
          <br />
          <br />
          <br />
          <br />

          <asp:panel id="showButton" runat="server" visible="false">
            <button type="button" iD="Button1" class="btn btn-warning" data-toggle="modal" data-target="#exampleModal2"
              data-whatever="@mdo">Show My Students</button>
          </asp:panel>
        </div>
      </div>
      <div class="modal fade" id="exampleModal2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-mw" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel2">New message</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <div class="container" id="Div2" runat="server">
                  <div class="row"></div>
                </div>

              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>

            </div>
          </div>
        </div>
      </div>
      <div class="modal fade" id="exampleModal1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel1">New message</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label for="recipient-name" class="col-form-label">Email:</label>
                <asp:TextBox type="email" runat="server" id="in_email" class="form-control" required="true">
                </asp:TextBox>
              </div>
              <div class="form-group">
                <label for="recipient-name" class="col-form-label">First Name:</label>
                <asp:TextBox runat="server" id="in_firstName" class="form-control" required="true"></asp:TextBox>
              </div>
              <div class="form-group">
                <label for="recipient-name" class="col-form-label">Last Name:</label>
                <asp:TextBox runat="server" id="in_lastName" class="form-control" required="true"></asp:TextBox>
              </div>
              <div class="form-group">
                <label for="recipient-name" class="col-form-label">Password:</label>
                <asp:TextBox TextMode="password" runat="server" id="in_pass" class="form-control" required="true">
                </asp:TextBox>
              </div>
              <div class="form-group">
                <label for="recipient-name" class="col-form-label">Address:</label>
                <asp:TextBox runat="server" id="in_address" class="form-control" required="true"></asp:TextBox>
              </div>
              <div class="form-group">
                <label for="recipient-name" class="col-form-label">Under Graduate ID:</label>
                <asp:TextBox runat="server" id="in_undergradID" class="form-control" required="true"></asp:TextBox>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              <asp:Button type="button" class="btn btn-primary" runat="server" Text="Edit" OnClick="editProfile" />
            </div>
          </div>
        </div>
      </div>

      <div class="modal fade" id="exampleModal3" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel">New message</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label for="recipient-name" class="col-form-label">Phone Number:</label>
                <asp:TextBox TextMode="number" runat="server" id="in_phone_number" class="form-control"></asp:TextBox>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              <asp:Button type="button" class="btn btn-warning" runat="server" UseSubmitBehavior="false"
                Text="Add Phone Number" OnClick="addPhoneNumber" />
            </div>
          </div>
        </div>
      </div>
      <br />
      <br />
    </form>
    <br />
    <br /><br />
  </body>

  </html>