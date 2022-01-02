﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentHome.aspx.cs" Inherits="PostGradSystem.StudentHome" %>

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
    <div class="jumbotron jumbotron-fluid">
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
          <a class="navbar-brand" href="#">Student Home</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
          <ul class="nav navbar-nav navbar-right">
            <li>
              <a href="Profile.aspx">
                <span class="glyphicon glyphicon-user"></span> My Account
              </a>add
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

    <div class="container">
      <div class="row">
        <div class="col-sm-4" style="width: 34%;">
          <div class="panel panel-success">
            <div class="panel-heading" style="text-align: center; font-weight: bolder">
              <a href="AddPublication.aspx">ADD PUBLICATIONS</a>
            </div>
            <div class="panel-body" style="text-align: center;">
              Add and link Publications to an ongoing Thesis
            </div>
          </div>
        </div>

        <div class="col-sm-4" style="width: 33%;">
          <div class="panel panel-success">
            <div class="panel-heading" style="text-align: center; font-weight: bolder">
              <a href="LinkPublication.aspx">LINK PUBLICATIONS</a>
            </div>
            <div class="panel-body" style="text-align: center;">
              Link a Publication to Thesis
            </div>
          </div>
        </div>

        <div class="col-sm-4" style="width: 33%;">
          <div class="panel panel-success">
            <div class="panel-heading" style="text-align: center; font-weight: bolder">
              <a href="Publications.aspx">VIEW PUBLICATIONS</a>
            </div>
            <div class="panel-body" style="text-align: center;">
              View all my Publications
            </div>
          </div>
        </div>


      </div>
    </div>

    <div class="container">
      <div class="row">
        <div class="col-sm-4" style="width: 100%;">
          <div class="panel panel-success">
            <div class="panel-heading" style="text-align: center; font-weight: bolder;">
              <a href="Theses.aspx">THESES</a>
            </div>
            <div class="panel-body" style="text-align: center;">View all Theses</div>
          </div>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="row">
        <div class="col-sm-4" style="width: 50%;">
          <div class="panel panel-success">
            <div class="panel-heading" style="text-align: center; font-weight: bolder">
              <a href="ProgressReport.aspx">ADD PROGRESS REPORTS</a>
            </div>
            <div class="panel-body" style="text-align: center;">
              Add and fill Progress Reports for an ongoing Thesis
            </div>
          </div>
        </div>

        <div class="col-sm-4" style="width: 50%;">
          <div class="panel panel-success">
            <div class="panel-heading" style="text-align: center; font-weight: bolder">
              <a href="ProgressReportsEvaluation.aspx">VIEW PROGRESS REPORTS</a>
            </div>
            <div class="panel-body" style="text-align: center;">
              View all my Progress Reports with their Evaluations
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="container" id="coursesDiv" runat="server">
      <div class="row">
        <div class="col-sm-4" style="width: 100%">
          <div class="panel panel-success">
            <div class="panel-heading" style="text-align: center; font-weight: bolder;">
              <a href="Courses.aspx">COURSES</a>
            </div>
            <div class="panel-body" style="text-align: center;">
              View all Courses with their respective Grades
            </div>
          </div>
        </div>
      </div>
    </div>

    <br />

    <br /><br />
  </body>

  </html>