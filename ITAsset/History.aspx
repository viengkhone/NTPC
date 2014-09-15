<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="History.aspx.cs" Inherits="History" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="design/jQueryUI/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        div#settings {background-color:White;}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<!--line shows location where users are in-->
<div class="website-current-location">
    Home >> History
</div>

<!--start content-->
<div id="settings">
    <ul>
        <li><a href="#Div1">User History</a></li>
        <li><a href="#Div2">Asset History</a></li>
    </ul>
    <!-- Start tab 1 -->
    <div id="Div1">
    <!-- Start Filtering Panel -->
        <input type="button" id="HideShowPanel-2" class="button" value="ON/OFF" />
        <asp:Panel ID="Panel2" runat="server" CssClass="history-filter-panel">
            <table>
                <tr>
                    <th>Username:</th>
                    <td>
                        <asp:DropDownList Width="250px" ID="txtUsername" runat="server" 
                            DataSourceID="SqlDS_Users" DataTextField="Name" DataValueField="id">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td>
                        <asp:Button ID="Button4" runat="server" CssClass="button" Text="Filter" />
                    </td>
                </tr>
            </table>
            <asp:SqlDataSource ID="SqlDS_Users" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                SelectCommand="SELECT [id], [Name] FROM [vw_All_Users] WHERE [id] IS NOT NULL ORDER BY [Name]"
                DeleteCommand="DELETE FROM ITASSET.ITAssetAssignHistory WHERE ([id]=@id)">
            </asp:SqlDataSource>
        </asp:Panel>
        <!--End Filter Panel /-->

        <!-- Start grid view : Current - for UserView /-->
        <strong>Current Ownership</strong> 
        <asp:GridView ID="GridView_Current" runat="server" DataSourceID="SqlDS_CurrentUserView"
            CssClass="gridview-orange" AutoGenerateColumns="False" DataKeyNames="id">
            <Columns>
                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="false" />
                <asp:BoundField DataField="ITAssetDetails" HeaderText="Asset Name" SortExpression="ITAssetDetails" />
                <asp:BoundField DataField="UniquePartNum" HeaderText="Unique Part No." SortExpression="UniquePartNum" />
                <asp:BoundField DataField="WarrantyStart" HeaderText="Warranty Start" SortExpression="WarrantyStart" DataFormatString="{0:d}" />
                <asp:BoundField DataField="WarrantyEnd" HeaderText="Warranty End" SortExpression="WarrantyEnd" DataFormatString="{0:d}" />
                <asp:BoundField DataField="DateOfUse" HeaderText="Date Use" SortExpression="DateOfUse" DataFormatString="{0:d}" />
                <asp:BoundField DataField="StatusName" HeaderText="Status" ReadOnly="True" SortExpression="StatusName" />
                <asp:BoundField DataField="UserName" HeaderText="Current User" SortExpression="UserName" />
                <asp:BoundField DataField="Location" HeaderText="Current Location" SortExpression="Location" />
                <asp:BoundField DataField="AssignmentComment" HeaderText="Assignment Comment" SortExpression="AssignmentComment" />
                <asp:BoundField DataField="EditBy" HeaderText="Edit By" SortExpression="EditBy" />
                <asp:BoundField DataField="EditDate" HeaderText="Edit Date" SortExpression="EditDate" DataFormatString="{0:d}" />
            </Columns>
            <AlternatingRowStyle CssClass="gridview-orange-alternate" />
            <EmptyDataTemplate>
                No Current Ownership Information Found for This User!
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDS_CurrentUserView" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
            SelectCommand="SELECT id, ITAssetDetails, UniquePartNum, WarrantyStart, WarrantyEnd, DateOfUse, StatusName, UserName, Location, AssignmentComment, EditBy, EditDate FROM dbo.vw_ITAssetAllProducts WHERE currentUserID=@currentUserID;">
            <SelectParameters>
                <asp:ControlParameter ControlID="txtUsername" Name="CurrentUserID" 
                    PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <!-- Start grid view : History - for UserView /-->
        <strong><br />History</strong> 
        <asp:GridView ID="GridView2" runat="server" DataSourceID="SqlDS_History_UserView" 
            AutoGenerateColumns="False" DataKeyNames="id" CssClass="gridview-orange" 
            ondatabound="GridView2_DataBound">
            <Columns>
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete" 
                            OnClientClick="return confirm('Are you sure you want to delete this item?');">
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="false" />
                <asp:BoundField DataField="ITAssetDetails" HeaderText="Asset Name" SortExpression="ITAssetDetails" ItemStyle-Wrap="false" >
                    <ItemStyle Wrap="False"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="UniquePartNum" HeaderText="Unique PartNum" SortExpression="UniquePartNum" />
                <asp:BoundField DataField="WarrantyStart" HeaderText="Warranty Start" 
                    SortExpression="WarrantyStart" DataFormatString="{0:d}" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="WarrantyEnd" HeaderText="Warranty End" 
                    SortExpression="WarrantyEnd" DataFormatString="{0:d}" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="DateOfUse" HeaderText="Date Use" 
                    SortExpression="DateOfUse" DataFormatString="{0:d}" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="StatusName" HeaderText="Status" ReadOnly="True" SortExpression="StatusName" />
                <asp:BoundField DataField="Name" HeaderText="User" SortExpression="Name" />
                <asp:BoundField DataField="Location" HeaderText="Location" SortExpression="Location" />
                <asp:BoundField DataField="AssignmentComment" HeaderText="Assignment Comment" SortExpression="AssignmentComment" />
                <asp:BoundField DataField="editBy" HeaderText="Edit By" SortExpression="editBy" />
                <asp:BoundField DataField="editDate" HeaderText="Edit Date" 
                    SortExpression="editDate" DataFormatString="{0:d}" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
            </Columns>
            <AlternatingRowStyle CssClass="gridview-orange-alternate" />
            <EmptyDataTemplate>
                No History Information Found !
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDS_History_UserView" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
            SelectCommand="SELECT * FROM [vw_All_ProductHistory] WHERE ([CurrentUserID] = @CurrentUserID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="txtUsername" Name="CurrentUserID" 
                    PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>
    </div>

    <!-- Start tab 2 -->
    <div id="Div2">
        <!-- Start Filtering Panel -->
        <input type="button" id="HideShowPanel-1" class="button" value="ON/OFF" />
        <asp:Panel ID="Panel1" runat="server" CssClass="history-filter-panel">
            <table>
                <tr>
                    <th>Asset ID:</th>
                    <td>
                        <asp:TextBox Width="200px" ID="txtId" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>Unique Part Number:</th>
                    <td>
                        <asp:TextBox Width="200px" ID="txtUniquePartNumber" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td>
                        <asp:Button ID="Button2" runat="server" CssClass="button" onclick="Button2_Click" Text="Filter" />
                        <asp:Button ID="Button1" runat="server" CssClass="button" onclick="Button1_Click" Text="Clear" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <!--End Filter Panel /-->

        <!-- Start grid view : History - for AssetView /-->
        <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDS_AllHistory" 
            AutoGenerateColumns="False" DataKeyNames="id" CssClass="gridview-orange" 
            ondatabound="GridView1_DataBound">
            <Columns>
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete" 
                            OnClientClick="return confirm('Are you sure you want to delete this item?');"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" Visible="false" />
                <asp:BoundField DataField="ITAssetDetails" HeaderText="Asset Name" SortExpression="ITAssetDetails" ItemStyle-Wrap="false" >
                    <ItemStyle Wrap="False"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="UniquePartNum" HeaderText="Unique PartNum" SortExpression="UniquePartNum" />
                <asp:BoundField DataField="WarrantyStart" HeaderText="Warranty Start" 
                    SortExpression="WarrantyStart" DataFormatString="{0:d}" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="WarrantyEnd" HeaderText="Warranty End" 
                    SortExpression="WarrantyEnd" DataFormatString="{0:d}" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="DateOfUse" HeaderText="Date Use" 
                    SortExpression="DateOfUse" DataFormatString="{0:d}" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="StatusName" HeaderText="Status" ReadOnly="True" SortExpression="StatusName" />
                <asp:BoundField DataField="Name" HeaderText="Current User" SortExpression="Name" />
                <asp:BoundField DataField="Location" HeaderText="Current Location" SortExpression="Location" />
                <asp:BoundField DataField="AssignmentComment" HeaderText="Assignment Comment" SortExpression="AssignmentComment" />
                <asp:BoundField DataField="editBy" HeaderText="Edit By" SortExpression="editBy" />
                <asp:BoundField DataField="editDate" HeaderText="Edit Date" 
                    SortExpression="editDate" DataFormatString="{0:d}" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
            </Columns>
            <AlternatingRowStyle CssClass="gridview-orange-alternate" />
            <EmptyDataTemplate>
                No History Ifnromation Found !
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDS_AllHistory" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
            SelectCommand="SELECT * FROM [vw_All_ProductHistory]"
            DeleteCommand="DELETE FROM ITASSET.ITAssetAssignHistory WHERE ([id]=@id)">
            <SelectParameters>
                <asp:Parameter Name="param" Type="String" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <!--End grid view /-->
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $('input.button, a.button, .hide-show-button').button();
        $('#settings').tabs({
            select: function (event, ui) {
                $("#<%= hfSelectedTAB.ClientID %>").val(ui.index);
            }
        });
        $("#settings").tabs("option", "selected", [$("#<%= hfSelectedTAB.ClientID %>").val()]);
    });
    //Toggle Filter Panel 1 On-Off
    $("#HideShowPanel-1").click(function () {
        $('#ContentPlaceHolder1_Panel1').toggle("slow");
    });
    //Toggle Filter Panel 2 On-Off
    $("#HideShowPanel-2").click(function () {
        $('#ContentPlaceHolder1_Panel2').toggle("slow");
    });
</script>
<asp:HiddenField ID="hfSelectedTAB" runat="server"  Value="0"/>
</asp:Content>

