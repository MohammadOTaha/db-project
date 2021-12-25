<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="PostGradSystem.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="label_fn" runat="server" Text="First Name: "></asp:Label>
            <asp:TextBox ID="firstname" runat="server" Text=""></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="firstname" Display="Dynamic" ErrorMessage="This field is required!" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
        </div>
        <div>
            <asp:Label ID="label_ln" runat="server" Text="Last Name: "></asp:Label>
            <asp:TextBox ID="lastname" runat="server" Text=""></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="lastname" Display="Dynamic" ErrorMessage="This field is required!" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
        </div>
        <div>
            <asp:Label ID="label_address" runat="server" Text="Address: "></asp:Label>
            <asp:TextBox ID="address" runat="server" Text=""></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="address" Display="Dynamic" ErrorMessage="This field is required!" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
        </div>
        <div>
            <asp:Label ID="label_email" runat="server" Text="Email: "></asp:Label>
            <asp:TextBox ID="email" runat="server" Text="" name="em"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="email" Display="Dynamic" ErrorMessage="This field is required!" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="mailRegExValidator" runat="server" 
                ControlToValidate="email" Display="Dynamic" 
                ErrorMessage="Please, enter a valid email!" 
                ForeColor="Red" SetFocusOnError="True"
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
            </asp:RegularExpressionValidator>
        </div>
        <div>
            <asp:Label ID="label_pass" runat="server" Text="Password: "></asp:Label>
            <asp:TextBox ID="password" runat="server" TextMode="Password" Text=""></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="password" Display="Dynamic" ErrorMessage="This field is required!" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="passRegExValidator" runat="server" 
                ControlToValidate="password" Display="Dynamic" 
                ErrorMessage="Please, enter a stronger password! (>= 8 characters, >= 1 digits, >= 1 special character)" 
                ForeColor="Red" SetFocusOnError="True"
                ValidationExpression="^.*(?=.{8,})(?=.*[\d])(?=.*[\W]).*$"></asp:RegularExpressionValidator>
        </div>
        <div>
            <asp:Label ID="label_fac" runat="server" Text="Faculty: "></asp:Label>
            <asp:TextBox ID="faculty" runat="server" Text=""></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="faculty" Display="Dynamic" ErrorMessage="This field is required!" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
        </div>
        <div>
            <asp:Label ID="label_utype" runat="server" Text="User Type: "></asp:Label>
            <asp:DropDownList ID="usertypedroplist" runat="server" AutoPostBack="False">
                <asp:ListItem>GUCian Student</asp:ListItem>
                <asp:ListItem>Non-GUCian Student</asp:ListItem>
                <asp:ListItem>Admin</asp:ListItem>
                <asp:ListItem>Examiner</asp:ListItem>
                <asp:ListItem>Supervisor</asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="usertypedroplist" Display="Dynamic" ErrorMessage="This field is required!" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
        </div>


        <div>
            <asp:Button ID="Button1" runat="server" Text="Register" OnClick="register"/>
        </div>
    </form>
</body>
</html>
