<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Cartridge.aspx.cs" Inherits="Cartridge" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="design/jQueryUI/css/humanity/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        div#settings {background-color:White;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!--line shows location where users are in-->
    <div class="website-current-location">
        Home >> Cartridge
    </div>

    <!--start content-->
    <div id="settings">
    <ul>
        <li><a href="#tabs-1">Quick Summary</a></li>
        <li><a href="#tabs-2">Purchase</a></li>
        <li><a href="#tabs-3">Use</a></li>
        <li><a href="#tabs-4">Add/Remove</a></li>
    </ul>
    <!-- Start tab 1 -->
    <div id="tabs-1">
        <p>Notyet Implement tab 1<asp:LinkButton ID="LinkButton1" runat="server">LinkButton</asp:LinkButton>
        </p>
    </div>
    <div id="tabs-2">
        <p>Notyet Implement tab 2</p>
    </div>
    <div id="tabs-3">
        <p>Notyet Implement tab 3</p>
    </div>
    <div id="tabs-4">
        <p>Notyet Implement tab 4</p>
    </div>
    </div>
    <!--End Tab Control using jQueryUI-->

    <script type="text/javascript">
        $(document).ready(function () {
            $('#settings').tabs({
                select: function (event, ui) {
                    $("#<%= hfSelectedTAB.ClientID %>").val(ui.index);
                }
            });
            $("#settings").tabs("option", "selected", [$("#<%= hfSelectedTAB.ClientID %>").val()]);
            $("#resizable").resizable();
        });
</script>
<asp:HiddenField ID="hfSelectedTAB" runat="server"  Value="0"/>

</asp:Content>

