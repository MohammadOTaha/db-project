<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="PostGradSystem.Register" %>

<!DOCTYPE html>  
<html xmlns="http://www.w3.org/1999/xhtml">  
<head runat="server">  
<title></title>  
<style type="text/css">  
.auto-style1 {  
width: 100%;  
        }  
.auto-style2 {  
height: 26px;  
        }  
.auto-style3 {  
height: 26px;  
width: 93px;  
        }  
.auto-style4 {  
width: 93px;  
        }  
</style>  
</head>  
<body>  
<form id="form1" runat="server">  
<table class="auto-style1">  
<tr>  
<td class="auto-style3">  
                        First value</td>  
<td class="auto-style2">  
<asp:TextBox ID="firstval" runat="server" required="true"></asp:TextBox>  
</td>  
</tr>  
<tr>  
<td class="auto-style4">  
      Second value</td>  
<td>  
<asp:TextBox ID="secondval" runat="server"></asp:TextBox>  
       It should be greater than first value</td>  
</tr>  
<tr>  
<td class="auto-style4"></td>  
<td>  
<asp:Button ID="Button1" runat="server" Text="save"/>  
</td>  
</tr>  
</table>  
< asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="secondval"   
ControlToValidate="firstval" Display="Dynamic" ErrorMessage="Enter valid value" ForeColor="Red"   
Operator="LessThan" Type="Integer"></asp:CompareValidator>  
</form>  
</body>  
</html>