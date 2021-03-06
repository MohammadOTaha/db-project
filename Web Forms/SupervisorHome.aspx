<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SupervisorHome.aspx.cs" Inherits="PostGradSystem.SupervisorHome" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link
      rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"
    />
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
          <button
            type="button"
            class="navbar-toggle"
            data-toggle="collapse"
            data-target="#myNavbar"
          >
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Student Home</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
          <ul class="nav navbar-nav navbar-right">
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
    <div class="container" id="coursesDiv">
      <div class="row">
        <div class="col-sm-4">
            <div class="panel panel-success">
              <div class="panel-heading">
                  <a href="viewPublications.aspx">VIEW PUBLICATIONS</a>
              </div>
              <div class="panel-body">
                View publications of specfic Student
              </div>
            </div>
        </div>
        <div class="col-sm-4">
          <div class="panel panel-success">
            <div class="panel-heading">
                <a href="AddDefense.aspx">ADD DEFENSE</a>
            </div>
            <div class="panel-body">Adding Defense for Student</div>
          </div>
        </div>
        <div class="col-sm-4">
          <div class="panel panel-success">
            <div class="panel-heading">
                <a href="AddExaminer.aspx">ADD EXAMINER</a>
            </div>
            <div class="panel-body">
                Add Examiner to Evaluate Defense
            </div>
          </div>
        </div>
      </div>
         <div class="col-sm-13">
          <div class="panel panel-success">
            <div class="panel-heading">
                <a href="EvaluateProgressReport.aspx">EVALUATE PROGRESS REPORT</a>
            </div>
            <div class="panel-body">
               Evaluate Progress Report of specfic Student
            </div>
          </div>
              <div class="col-sm-14">
          <div class="panel panel-success">
            <div class="panel-heading">
                <a href="cancelThesis.aspx">CANCEL THESIS</a>
            </div>
            <div class="panel-body">
               Cancel Thesis
            </div>
          </div>
        </div>
      </div>
    </div>
    <br />
    
    <br /><br />
  </body>
</html>
