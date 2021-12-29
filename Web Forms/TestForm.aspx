<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestForm.aspx.cs"
Inherits="PostGradSystem.TestForm" %>

<!DOCTYPE html>

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
					<a class="navbar-brand" href="#">Student Courses</a>
				</div>
				<div class="collapse navbar-collapse" id="myNavbar">
					<ul class="nav navbar-nav navbar-right">
						<li>
							<a href="Profile.aspx">
								<span class="glyphicon glyphicon-user"></span>
								My Account
							</a>
						</li>
						<li>
							<a href="Login.aspx">
								<span class="glyphicon glyphicon-log-out"></span
								>Logout
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
					<asp:Button
						type="button"
						class="btn btn-primary"
						runat="server"
						data-toggle="modal"
						data-target="#exampleModal"
						data-whatever="@mdo"
						Text="Edit Profile Details"
					/>
					<asp:Button
						type="button"
						class="btn btn-warning"
						runat="server"
						Text="Add Phone Number"
					/>
					<div
						class="modal fade"
						id="exampleModal"
						tabindex="-1"
						role="dialog"
						aria-labelledby="exampleModalLabel"
						aria-hidden="true"
					>
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<h5
										class="modal-title"
										id="exampleModalLabel"
									>
										New message
									</h5>
									<button
										type="button"
										class="close"
										data-dismiss="modal"
										aria-label="Close"
									>
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<div class="modal-body">
									<form>
										<div class="form-group">
											<label
												for="recipient-name"
												class="col-form-label"
												>Recipient:</label
											>
											<input
												type="text"
												class="form-control"
												id="recipient-name"
											/>
										</div>
										<div class="form-group">
											<label
												for="message-text"
												class="col-form-label"
												>Message:</label
											>
											<textarea
												class="form-control"
												id="message-text"
											></textarea>
										</div>
									</form>
								</div>
								<div class="modal-footer">
									<button
										type="button"
										class="btn btn-secondary"
										data-dismiss="modal"
									>
										Close
									</button>
									<button
										type="button"
										class="btn btn-primary"
									>
										Send message
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>

		<br />
		<br /><br />
	</body>
</html>
