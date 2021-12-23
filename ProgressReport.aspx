<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProgressReport.aspx.cs" Inherits="PostGradSystem.ProgressReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="lbl_reportDate" runat="server" Text="Progress Report Date: "></asp:Label>
            <asp:TextBox ID="report_date" runat="server" textmode="Date"></asp:TextBox>
        </div>
        
        <div>
            <asp:Label ID="lbl_thesis" runat="server" Text="Thesis: "></asp:Label>
            <asp:DropDownList ID="thesis_dropList" runat="server" AutoPostBack="False"/>
        </div>

        <asp:Button ID="btn_addReport" runat="server" Text="Add Report" OnClick="addReport"/>

            
    </form>
</body>
</html>
