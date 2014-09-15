<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Dashboard" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="design/jQueryUI/css/south-street/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        div#settings {background-color:White;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<!--line shows location where users are in-->
<div class="website-current-location">
    Home >> Dashboard
</div>

<!--Start Tab Control using jQueryUI-->
<div id="settings">
    <ul>
        <li><a href="#tabs-1">Assets Listing</a></li>
        <li><a href="#tabs-2">Result</a></li>
        <li><a href="#tabs-3">Quick Summary</a></li>
    </ul>
    <div id="tabs-1">
        <strong>&nbsp; Select Type you want to Filter:</strong>
        <asp:DropDownList runat="server" DataSourceID="LinqMainType" DataTextField="TypeName"
            DataValueField="TypeName" ID="cmbTypeName" AutoPostBack="True">
        </asp:DropDownList>
        <br />
        <br />
        <!--1st GridView Showing total product of each type-->
        <asp:GridView ID="GridView1" runat="server"  
            CssClass="gridview-green" AutoGenerateColumns="False" 
            DataSourceID="LinqAssetByType" DataKeyNames="SubTypeName" >
            <AlternatingRowStyle CssClass="gridview-green-alternate" />
            <Columns>
                <asp:CommandField ShowSelectButton="true" ItemStyle-Width="20px" />
                <asp:BoundField DataField="TypeName" HeaderText="Main Type" />
                <asp:BoundField DataField="SubTypeName" HeaderText="Sub Type" />
                <asp:TemplateField HeaderText="Total Items" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkTo_ProductBySubType" runat="server" CommandName="Select" Text="<%# Bind('Total') %>" CommandArgument="<%# Bind('SubTypeName') %>" ToolTip="Show Items" >
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <br />No record for this filter!<br></br>
                <br></br>
            </EmptyDataTemplate>
            <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" NextPageText="Next" PreviousPageText="Prev" />
            <SelectedRowStyle CssClass="gridview-green-selected-row" />
            <PagerStyle CssClass="gridview-green-footer" VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center" />
            <HeaderStyle CssClass="gridview-green-footer" />
        </asp:GridView>

        <asp:LinqDataSource ContextTypeName="DataClassesDataContext" runat="server" 
            TableName="vw_ITAssetAllProducts" ID="LinqAssetByType" 
            GroupBy="new(TypeName, SubTypeName)"
            Select="new(Key.TypeName, Key.SubTypeName, it as vw_ITAssetAllProducts, Count() as Total)" 
            EntityTypeName="" OrderGroupsBy="key.TypeName, key.SubTypeName" 
            Where="TypeName == @TypeName" OrderBy="TypeName">
            <WhereParameters>
                <asp:ControlParameter ControlID="cmbTypeName" Name="TypeName" 
                    DefaultValue="Computer" PropertyName="SelectedValue" Type="String" />
            </WhereParameters>
        </asp:LinqDataSource>

        <asp:LinqDataSource ID="LinqMainType" runat="server" 
            ContextTypeName="DataClassesDataContext" EntityTypeName="" 
            Select="new (id, TypeName)" TableName="ITAssetTypes">
        </asp:LinqDataSource>
        <br />
        <!--2nd GridView Showing Selected SubType-->
        <asp:GridView ID="GridView2" CssClass="Asset-Listing-Grid2" runat="server" AutoGenerateColumns="False" 
            DataSourceID="Sql_vw_SubTypeByStatus" AllowPaging="True" AllowSorting="true" PageSize="30">
            <AlternatingRowStyle BackColor="#E6FF99" />
            <Columns>
                <asp:BoundField DataField="SubTypeName" HeaderText="Sub Type Name" ItemStyle-Width="150px" />
                <asp:BoundField DataField="ITAssetDetails" HeaderText="IT Asset Name" ItemStyle-Width="200px" />
                <asp:HyperLinkField DataTextField="Group Assign" HeaderText="Group Assign" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=1&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="User Assign" HeaderText="User Assign" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=2&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="Loc Assign" HeaderText="Loc Assing" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=3&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="Await Assign" HeaderText="Await Assing" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=5&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="Reserved" HeaderText="Reserved" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=12&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="To Repair" HeaderText="To Repair" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=7&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="On Repair" HeaderText="Repaired" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=15&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="To Claim" HeaderText="To Claim" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=6&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="Claimed" HeaderText="Claimed" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=11&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="To Dispose" HeaderText="To Dispose" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=9&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="Disposed" HeaderText="Disposed" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=10&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="To Donate" HeaderText="To Donate" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=13&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="Donated" HeaderText="Donated" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=14&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="Lost" HeaderText="Lost" ItemStyle-HorizontalAlign="Center" SortExpression="ITAssetDetails" DataNavigateUrlFields="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=8&AssetName={0}" DataTextFormatString="{0:###,###}" />
                <asp:HyperLinkField DataTextField="IN_STORE" HeaderText="IN_STORE" ItemStyle-HorizontalAlign="Center" DataNavigateUrlFields="ITAssetDetails" SortExpression="ITAssetDetails" DataNavigateUrlFormatString="Dashboard.aspx?enumStatus=4&AssetName={0}" DataTextFormatString="{0:###,###}" />
            </Columns>
            <HeaderStyle CssClass="header-vertical-orient" />
            <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" NextPageText="Next" PreviousPageText="Prev" />
            <SelectedRowStyle CssClass="gridview-green-selected-row" />
            <PagerStyle BackColor="#99CC00" VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center" />
        </asp:GridView>
        <asp:SqlDataSource ID="Sql_vw_SubTypeByStatus" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
            
            SelectCommand="SELECT SubTypeName,ITAssetDetails,[Group Assign],[User Assign],[Loc Assign],[Await Assign],[Reserved],[To Repair],[On Repair],[To Claim],[Claimed],[To Dispose],[Disposed],[To Donate],[Donated],[Lost],[IN_STORE] FROM vw_SubTypeByStatus WHERE (SubTypeName = @SubTypeName)">
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" Name="SubTypeName" 
                    PropertyName="SelectedValue" Type="String" DefaultValue="Laptop Set" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div id="tabs-2">
        <asp:Panel ID="Panel1" runat="server" onload="Panel1_Load">
        <table style="display:none;">
            <tr>
                <th>Product Detail</th>
                <td>
                    <asp:DropDownList ID="cmbAssetDetails" runat="server" 
                        DataSourceID="SqlDS_AssetDetails" DataTextField="ITAssetDetails" 
                        DataValueField="ITAssetDetails" AutoPostBack="True">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th>Status</th>
                <td>
                    <asp:DropDownList ID="cmbEnumStatus" runat="server" DataSourceID="SqlDS_enumStatus" 
                        DataTextField="StatusName" DataValueField="statusID" AutoPostBack="True">
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <asp:SqlDataSource ID="SqlDS_AssetDetails" runat="server"
            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
            
                SelectCommand="SELECT DISTINCT [ITAssetDetails] FROM [vw_ITAssetAllProducts] WHERE ([ITAssetDetails] = @ITAssetDetails)">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="Dell Latitude D630" 
                    Name="ITAssetDetails" QueryStringField="AssetName" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDS_enumStatus" runat="server"
            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>"
            
                SelectCommand="SELECT [statusID], [StatusName] FROM [vw_enumStatus] WHERE ([statusID] = @statusID)">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="1" Name="statusID" 
                    QueryStringField="enumStatus" Type="Decimal" />
            </SelectParameters>
        </asp:SqlDataSource>
        </asp:Panel>

        <!-- Start Result Grid /-->
        <asp:GridView ID="Result_Grid" runat="server" DataSourceID="SqlDS_Result_Grid" 
            AutoGenerateColumns="False" DataKeyNames="id" CssClass="gridview-green" 
            AllowPaging="True" PageSize="30">
            <Columns>
                <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:HyperLink ID="HyperLink1" ImageUrl="design/027.gif" runat="server" ToolTip="History"
                            NavigateUrl='<%# Eval("id", "History.aspx?id={0}") %>' Text=""></asp:HyperLink>
                        <asp:HyperLink ID="HyperLink2" ImageUrl="design/062.gif" runat="server" ToolTip="Information"
                            NavigateUrl='<%# Eval("id", "Manage.aspx?id={0}") %>' Text=""></asp:HyperLink>
                    </ItemTemplate>
                    <ControlStyle CssClass="action-icon" />
                </asp:TemplateField>
                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" />
                <asp:BoundField DataField="ITAssetDetails" HeaderText="ITAssetDetails" SortExpression="ITAssetDetails" />
                <asp:BoundField DataField="UniquePartNum" HeaderText="UniquePartNum" SortExpression="UniquePartNum" />
                <asp:BoundField DataField="WarrantyStart" HeaderText="WarrantyStart" SortExpression="WarrantyStart" DataFormatString="{0:d}" />
                <asp:BoundField DataField="WarrantyEnd" HeaderText="WarrantyEnd" SortExpression="WarrantyEnd" DataFormatString="{0:d}" />
                <asp:BoundField DataField="Location" HeaderText="Location" SortExpression="Location" />
                <asp:BoundField DataField="UserName" HeaderText="UserName" SortExpression="UserName" />
                <asp:BoundField DataField="Section" HeaderText="Section" SortExpression="Section" />
            </Columns>
        <AlternatingRowStyle CssClass="gridview-green-alternate" />
        <FooterStyle CssClass="gridview-green-footer" />
        <PagerStyle CssClass="gridview-green-footer" VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center" />
        <EmptyDataTemplate>
            No records found for this filter!
        </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDS_Result_Grid" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>"
            SelectCommand="SELECT [id], [ITAssetDetails], [UniquePartNum], [WarrantyStart], [WarrantyEnd], [Location], [UserName], [Section] FROM [vw_ITAssetAllProducts] WHERE (([enumStatus] = @enumStatus) AND ([ITAssetDetails] = @ITAssetDetails))">
            <SelectParameters>
                <asp:ControlParameter ControlID="cmbEnumStatus" Name="enumStatus" 
                    PropertyName="SelectedValue" Type="Decimal" />
                <asp:ControlParameter ControlID="cmbAssetDetails" Name="ITAssetDetails" 
                    PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div id="tabs-3">
        <p>Notyet Implement</p>
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