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
        </div>
        <div>
            <asp:Label ID="label_ln" runat="server" Text="Last Name: "></asp:Label>
            <asp:TextBox ID="lastname" runat="server" Text=""></asp:TextBox>
        </div>
        <div>
            <asp:Label ID="label_address" runat="server" Text="Address: "></asp:Label>
            <asp:TextBox ID="address" runat="server" Text=""></asp:TextBox>
        </div>
        <div>
            <asp:Label ID="label_email" runat="server" Text="Email: "></asp:Label>
            <asp:TextBox ID="email" runat="server" Text="" name="em"></asp:TextBox>
        </div>
        <div>
            <asp:Label ID="label_pass" runat="server" Text="Password: "></asp:Label>
            <asp:TextBox ID="password" runat="server" Text=""></asp:TextBox>
        </div>
        <div>
            <asp:Label ID="label_fac" runat="server" Text="Faculty: "></asp:Label>
            <asp:TextBox ID="faculty" runat="server" Text=""></asp:TextBox>
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
        </div>


        <div>
            <asp:Button ID="Button1" runat="server" Text="Register" OnClick="register"/>
        </div>
    </form>
</body>
</html>
