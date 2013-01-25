<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="design/jQueryUI/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<!--Login Begins Here-->
<table id="login-table" title="IT Asset Tracking System - Login">
    <tr>
        <td class="login-title-td">
            <span class="title-text">ICT Team Login </span><asp:Label ID="StaffNameLabel" runat="server"></asp:Label>
        </td>
    </tr>
    <tr>
        <td class="login-body-td">
            <asp:Panel ID="RequiredLoginPanel" runat="server">
                <table>
                    <tr>
                        <th>
                            Username
                        </th>
                        <td>
                            <asp:TextBox ID="UsernameTextbox" runat="server" Height="20px" Width="180px" CssClass="ui-widget-content"></asp:TextBox>
                            <asp:Label ID="UsernameErrorLabel" runat="server" CssClass="ui-state-error" Text="Please enter username" Visible="False"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Password
                        </th>
                        <td>
                            <asp:TextBox ID="PasswordTextbox" runat="server" Height="20px" TextMode="Password" Width="180px" CssClass="ui-widget-content"></asp:TextBox>
                            <asp:Label ID="PasswordErrorLabel" runat="server" CssClass="ui-state-error" Text="Please enter password" Visible="False"></asp:Label>
                        </td>
                    </tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="Button1" runat="server" Text="Login" CssClass="button" onclick="Button1_Click" />
                            <asp:Label ID="LoginFailedLabel" Font-Size="16px" runat="server" CssClass="ui-state-error" Visible="False"></asp:Label>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <td title="IT Asset Tracking System - Login"></td>
    </tr>
</table>
<script type="text/javascript">
    $(document).ready(function () {
        $('input.button').button();
        $('#login-table').draggable();
    });
</script>
</asp:Content>

