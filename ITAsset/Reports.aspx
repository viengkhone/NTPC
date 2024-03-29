﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="Reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="design/jQueryUI/css/swanky-purse/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        div#settings .ui-tabs-nav li.ui-tabs-active a {
            color: #663333;
        }
        div#settings {background-color:White;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <!--line shows location where users are in-->
    <div class="website-current-location">
        Home >> Reports
    </div>

    <!--Start Tab Control using jQueryUI-->
    <div id="settings">
        <ul>
            <li><a href="#Div1">Item by Division</a></li>
            <li><a href="#Div2">Item by Status</a></li>
            <li><a href="#Div3">Item by MainType</a></li>
            <li><a href="#Div4">By User & Division</a></li>
            <li><a href="#Div5">By Type & Location</a></li>
            <li><a href="#Div6">Item by Location</a></li>
        </ul>

        <!-- Start tab 1 : List item by Division /-->
        <div id="Div1">
            <asp:Literal ID="ltrChart1" runat="server"></asp:Literal>
        </div>
        <!-- Start tab 2 : List item by Status /-->
        <div id="Div2">
            <asp:GridView ID="GridView_ItemByStatus" runat="server" CssClass="gridview-rpt"
                AutoGenerateColumns="False" DataSourceID="SqlDS_ItemByStatus" 
                onrowdatabound="GridView_ItemByStatus_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="SubTypeName" HeaderText="Subtype Name" SortExpression="SubTypeName" />
                    <asp:BoundField DataField="UserAssign" HeaderText="User Assign" SortExpression="UserAssign" />
                    <asp:BoundField DataField="LocationAssign" HeaderText="Loc Assign" SortExpression="LocationAssign" />
                    <asp:BoundField DataField="Claimed" HeaderText="Claim" SortExpression="Claimed" />
                    <asp:BoundField DataField="ToRepair" HeaderText="To Repair" SortExpression="ToRepair" />
                    <asp:BoundField DataField="Lost" HeaderText="Lost" SortExpression="Lost" />
                    <asp:BoundField DataField="ToDispose" HeaderText="To Dispose" SortExpression="ToDispose" />
                    <asp:BoundField DataField="Disposed" HeaderText="Disposed" SortExpression="Disposed" />
                    <asp:BoundField DataField="In_Store" HeaderText="In Store" SortExpression="In_Store" />
                </Columns>
                <AlternatingRowStyle CssClass="gridview-rpt-alternate" />
            </asp:GridView>

            <asp:SqlDataSource ID="SqlDS_ItemByStatus" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                SelectCommand="SELECT * FROM [vw_Rpt_ByStatus]"></asp:SqlDataSource>
        </div>
        <!-- Start tab 3 : List item by MainType /-->
        <div id="Div3">
            <asp:Literal ID="ltrChart2" runat="server"></asp:Literal>
            <asp:TextBox runat="server" Text="" ID="hiden_Chart2Data" Visible="false"></asp:TextBox>
        </div>
        <!-- Start tab 4 : List item by User & Division /-->
        <div id="Div4">
            
        </div>
        <!-- Start tab 5 : List item by Type and Location/ -->
        <div id="Div5">
        
        </div>
        <!-- Start tab 6 : List item by Location/ -->
        <div id="Div6">
            <asp:GridView ID="GridView_ItemByLocation" runat="server" CssClass="gridview-rpt"
                AutoGenerateColumns="False" DataSourceID="SqlDS_ItemByLocation">
                <Columns>
                    <asp:BoundField DataField="SubTypeName" HeaderText="Subtype Name" SortExpression="SubTypeName" />
                    <asp:BoundField DataField="Location" HeaderText="Location" SortExpression="Location" />
                    <asp:BoundField DataField="Cnt" HeaderText="Total" SortExpression="Cnt" ItemStyle-HorizontalAlign="Center" />
                </Columns>
                <AlternatingRowStyle CssClass="gridview-rpt-alternate" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDS_ItemByLocation" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                SelectCommand="SELECT * FROM [vw_Rpt_ByLocation]"></asp:SqlDataSource>
        </div>

    </div>
    <!--End Tab Control using jQueryUI-->

    <script type="text/javascript">
        $(document).ready(function () {
            $('input.button, a.button').button();
            $('#settings').tabs({
                select: function (event, ui) {
                    $("#<%= hfSelectedTAB.ClientID %>").val(ui.index);
                }
            });
            $("#settings").tabs("option", "selected", [$("#<%= hfSelectedTAB.ClientID %>").val()]);
        });
    </script>
<asp:HiddenField ID="hfSelectedTAB" runat="server"  Value="0"/>
</asp:Content>

