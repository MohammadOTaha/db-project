<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PostGradSystem.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="label_in_email" runat="server" Text="Email: "></asp:Label>
            <asp:TextBox ID="in_email" runat="server" Width="200"></asp:TextBox>
        </div>
        <div>
            <asp:Label ID="label_in_pass" runat="server" Text="Password: "></asp:Label>
            <asp:TextBox ID="in_pass" runat="server" Width="200"></asp:TextBox>
        </div>
        <div>
            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="login"></asp:Button>
        </div>
    </form>
</body>
</html>
