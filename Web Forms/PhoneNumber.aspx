<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PhoneNumber.aspx.cs" Inherits="PostGradSystem.PhoneNumber" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="lbl_phone" runat="server" Text="Phone Numbers:"></asp:Label>
            <asp:BulletedList id="ul" runat="server"/>
        </div>

        <div>
            <asp:Label ID="lbl_addPhone" runat="server" Text="Add Phone Number: "></asp:Label>
            <asp:TextBox ID="tb_add_phone" runat="server" Text=""></asp:TextBox>
            <asp:Button ID="btn_addPhone" runat="server" Text="Add" OnClick="AddPhoneNumber"></asp:Button>
        </div>
    </form>
</body>
</html>
