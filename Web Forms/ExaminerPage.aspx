<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExaminerPage.aspx.cs" Inherits="PostGradSystem.ExaminerPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        &nbsp;&nbsp;&nbsp;&nbsp; Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="namex" runat="server"></asp:TextBox>
            <br />
&nbsp;&nbsp;&nbsp; Field Of work&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="field" runat="server"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Button1" runat="server" OnClick="editExaminer" Text="Edit my profie" />
            <br />
            <br />
            <asp:Label ID="Label2" runat="server" Text="date"></asp:Label>
            <asp:TextBox ID="Date" runat="server" TextMode="Date"></asp:TextBox>
            <br />
            <asp:Label ID="Label3" runat="server" Text="thesis serial no."></asp:Label>
            <asp:TextBox ID="thesisSerialNO" runat="server" TextMode="Number"></asp:TextBox>
            <br />
            <br />
            <asp:Label ID="Label1" runat="server" Text="comment"></asp:Label>
            <asp:TextBox ID="comment" runat="server"></asp:TextBox>
            <br />
            <asp:Button ID="Button4" runat="server" OnClick="Button4_Click" OnClientClick="comment" Text="add Comment" />
            <br />
            <br />
            <asp:Label ID="Label4" runat="server" Text="thesis serial no."></asp:Label>
            <asp:TextBox ID="serialNo" runat="server" TextMode="Number"></asp:TextBox>
            <br />
            <asp:Label ID="Label5" runat="server" Text="date"></asp:Label>
            <asp:TextBox ID="dateGrade" runat="server" TextMode="Date" ></asp:TextBox>
            <br />
            <asp:Label ID="Label6" runat="server" Text="grade"></asp:Label>
            <asp:TextBox ID="grade" runat="server"></asp:TextBox>
            <br />
            <asp:Button ID="Button3" runat="server"  OnClick="addGrade" Text="Add Grade" />
            <br />
            <br />
        </div>
        <p>
            <asp:Label ID="Label7" runat="server" Text="Thesis title"></asp:Label>
            <asp:TextBox ID="keyWord" runat="server"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="Button5" runat="server" OnClick="search" Text="search" />
        </p>
    </form>
</body>
</html>
