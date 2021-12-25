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

        <asp:panel id="pnl_fillReport" runat="server" visible="false">
            <div>
                <asp:Label ID="lbl_reportDesc" runat="server" Text="Progress Report Description: "></asp:Label>
                <asp:TextBox ID="report_desc" runat="server"></asp:TextBox>
            </div>
        
            <div>
                <asp:Label ID="lbl_reportState" runat="server" Text="Progress Report State: "></asp:Label>
                <!-- <asp:TextBox ID="report_state" runat="server"></asp:TextBox> -->
                <input type="number" id="report_state" step="1">
            </div>
        </asp:panel>

        <asp:Button ID="btn_fillReport" runat="server" Text="Fill Report" OnClick="fillReport"/>
        <asp:Button ID="btn_addReport" runat="server" Text="Add Report" OnClick="addReport"/>
    </form>
</body>
</html>
