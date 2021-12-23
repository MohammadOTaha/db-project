<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddPublication.aspx.cs" Inherits="PostGradSystem.AddPublication" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="lbl_pubTitle" runat="server" Text="Publication Title: "></asp:Label>
            <asp:TextBox ID="pub_title" runat="server" Text=""></asp:TextBox>
        </div>

        <div>
            <asp:Label ID="lbl_pubDate" runat="server" Text="Publication Date: "></asp:Label>
            <!-- date input -->
            <asp:TextBox ID="pub_date" runat="server" textmode="Date"></asp:TextBox>
        </div>

        <div>
            <asp:Label ID="lbl_pubHost" runat="server" Text="Publication Host: "></asp:Label>
            <asp:TextBox ID="pub_host" runat="server" Text=""></asp:TextBox>
        </div>

        <div>
            <asp:Label ID="lbl_pubPlace" runat="server" Text="Publication Place: "></asp:Label>
            <asp:TextBox ID="pub_place" runat="server" Text=""></asp:TextBox>
        </div>

        <div>  
            <asp:Label ID="lbl_pubType" runat="server" Text="Publication Accepted: "></asp:Label>
            <asp:RadioButton ID="rdoYes" runat="server" Text="Yes" GroupName="rdo_accepted" />  
            <asp:RadioButton ID="rdoNo" runat="server" Text="No" GroupName="rdo_accepted" />  
        </div> 
        
        <asp:panel id="linkPubPanel" runat="server" visible="false">
            <asp:Label ID="lbl_thesis" runat="server" Text="Thesis: "></asp:Label>
            <asp:DropDownList ID="thesis_dropList" runat="server" AutoPostBack="False">
            </asp:DropDownList>
        </asp:panel>
        
        <asp:Button ID="btn_showLinkPub" runat="server" Text="Link Publication to Thesis" OnClick="showLink"></asp:Button>
        <br/>
        <br/>
        <asp:Button ID="btn_addPub" runat="server" Text="Add Publication" OnClick="addPublication"/>

            
    </form>
</body>
</html>
