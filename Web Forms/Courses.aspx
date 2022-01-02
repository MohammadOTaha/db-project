<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="PostGradSystem.Courses" %>

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

    <div class="container" id="coursesDiv" runat="server">
      <div class="row">

      </div>
    </div>
    <br />
    <br /><br />
  </body>

  </html>