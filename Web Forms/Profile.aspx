<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="PostGradSystem.Profile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div>
        <asp:Label ID="label1" runat="server" Text="Name: "></asp:Label>
        <asp:label ID="lbl_name" runat="server"></asp:label>
    </div>
    <div>
        <asp:Label ID="label2" runat="server" Text="Email: "></asp:Label>
        <asp:label ID="lbl_email" runat="server"></asp:label>
    </div>
    <div>
        <asp:Label ID="label3" runat="server" Text="Faculty: "></asp:Label>
        <asp:label ID="lbl_faculty" runat="server"></asp:label>
    </div>
    <div>
        <asp:Label ID="label4" runat="server" Text="Address: "></asp:Label>
        <asp:label ID="lbl_address" runat="server"></asp:label>
    </div>
    <div>
        <asp:Label ID="label5" runat="server" Text="Type: "></asp:Label>
        <asp:label ID="lbl_type" runat="server"></asp:label>
    </div>
    <div>
        <asp:Label ID="label6" runat="server" Text="Under graduate ID: "></asp:Label>
        <asp:label ID="lbl_undergradID" runat="server"></asp:label>
    </div>

    <div ID="phoneDiv" runat="server">
        <asp:Label ID="phoneCnt" runat="server" Text="Phone: "></asp:Label>
        <asp:label ID="lbl_phone" runat="server"></asp:label>
    </div>
</body>
</html>
