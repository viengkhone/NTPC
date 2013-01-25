<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Manage.aspx.cs" Inherits="Manage" %>
<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="design/jQueryUI/css/redmond/jquery-ui.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<!--line shows location where users are in-->
<div class="website-current-location">
    Home >> Manage Asset
</div>

<!--Start Tab Control using jQueryUI-->
<div id="settings">
    <ul>
        <li><a href="#tabs-1">Manage IT Asset</a></li>
        <li><a href="#tabs-2">Full List</a></li>
        <li><a href="#tabs-3">Add/Remove</a></li>
    </ul>

    <!-- Start tab 1 -->
    <div id="tabs-1">
    <!--Start Multiview as View Control-->
        <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
            <asp:View ID="View0" runat="server">
                <!-- Start Filtering Panel -->
                <input type="button" id="HideShowPanel-1" class="button" value="ON/OFF" />
                <asp:Panel ID="Panel1" runat="server" CssClass="manage-filter-panel">
                    <table>
                        <tr>
                            <th>Main Type</th>
                            <td>
                                <asp:DropDownList ID="cmbMainType" runat="server" 
                                    DataSourceID="SqlDS_MainType" DataTextField="TypeName" 
                                    DataValueField="TypeName" 
                                    AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                            <td rowspan="4" style="padding:0 10px 0 10px;vertical-align:bottom">
                                &nbsp;</td>
                            <th><strong>Keywords Filter</strong></th>
                        </tr>
                        <tr>
                            <th>Sub Type</th>
                            <td>
                                <asp:DropDownList ID="cmbSubType" runat="server" 
                                    DataSourceID="SqlDS_SubType" DataTextField="SubTypeName" 
                                    DataValueField="SubTypeName" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                            <td rowspan="2" valign="top">
                                <asp:TextBox runat="server" ID="Keywords" CssClass="keyword" TextMode="MultiLine"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>Product Detail</th>
                            <td>
                                <asp:DropDownList ID="cmbAssetName" runat="server" 
                                    DataSourceID="SqlDS_AssetName" DataTextField="ITAssetDetails" 
                                    DataValueField="ITAssetDetails" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>Filter</th>
                            <td align="right">
                                &nbsp;
                                <asp:Button ID="Button2" runat="server" CssClass="button" onclick="Button2_Click" Text="Filter" />
                            </td>
                            <td align="right">
                                <asp:Button ID="Button1" runat="server" CssClass="button" Text="Search" onclick="Button1_Click" />
                            </td>
                        </tr>
                    </table>

                    <asp:SqlDataSource ID="SqlDS_MainType" runat="server"
                        ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                        SelectCommand="SELECT DISTINCT ID, [TypeName] FROM ITASSET.ITAssetType ORDER BY [ID]">
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDS_SubType" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>"
                        SelectCommand="SELECT DISTINCT [SubTypeName] FROM [vw_ITAssetAllProducts] WHERE ([TypeName] = @TypeName)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="cmbMainType" DefaultValue="Computer" 
                                Name="TypeName" PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SqlDS_AssetName" runat="server"
                        ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                        SelectCommand="SELECT DISTINCT [ITAssetDetails] FROM [vw_ITAssetAllProducts] WHERE ([SubTypeName] = @SubTypeName)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="cmbSubType" Name="SubTypeName" 
                                PropertyName="SelectedValue" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </asp:Panel>
                <!--End Filter Panel /-->

                <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                    SelectCommand="SELECT [id], [ITAssetDetails], [UniquePartNum], [currentUserID], [Location], [UserType], [UserName], [StatusName] FROM [vw_ITAssetAllProducts] WHERE (([TypeName] = @TypeName) AND ([SubTypeName] = @SubTypeName) AND ([ITAssetDetails] = @ITAssetDetails))">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="cmbMainType" DefaultValue="Computer" Name="TypeName" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="cmbSubType" Name="SubTypeName" PropertyName="SelectedValue" Type="String" />
                        <asp:ControlParameter ControlID="cmbAssetName" Name="ITAssetDetails" PropertyName="SelectedValue" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                
                <!-- First GridView /-->
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True"
                    AllowSorting="True" AutoGenerateColumns="False" CssClass="gridview-purple"
                    DataSourceID="SqlDataSource1" DataKeyNames="id"
                    PageSize="20" onselectedindexchanged="GridView1_SelectedIndexChanged" 
                    ondatabound="GridView1_DataBound">
                    <AlternatingRowStyle CssClass="gridview-purple-alternate" />
                    <Columns>
                        <asp:CommandField ShowSelectButton="True" />
                        <asp:BoundField DataField="id" HeaderText="ID" ItemStyle-HorizontalAlign="Center" ReadOnly="True" SortExpression="id">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ITAssetDetails" HeaderText="IT Asset Details" SortExpression="ITAssetDetails">
                        </asp:BoundField>
                        <asp:BoundField DataField="UniquePartNum" HeaderText="Unique Part No." SortExpression="UniquePartNum" />
                        <asp:BoundField DataField="Location" HeaderText="Current Location" SortExpression="Location" />
                        <asp:BoundField DataField="UserName" HeaderText="User Name" SortExpression="UserName" />
                        <asp:BoundField DataField="StatusName" HeaderText="Status" SortExpression="StatusName" />
                    </Columns>
                    <EmptyDataTemplate><br /> No record for this filter!<br /><br /></EmptyDataTemplate>
                    <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" NextPageText="Next" PreviousPageText="Prev" />
                    <PagerStyle CssClass="gridview-purple-footer" VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center"/>
                </asp:GridView>
            </asp:View>
            <asp:View ID="View1" runat="server">
                
                <asp:LinkButton CssClass="button" OnClick="GoToManageAssetPage" runat="server">&lt;&lt;- Go back to Previous Page</asp:LinkButton>
                
                <table><tr><td valign="top">
                <!-- Start DetailView1 for Manage Asset Details -->
                <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataSourceID="SqlDS_DetailsView1" 
                    ForeColor="#333333" GridLines="None" CssClass="manage-detailview" 
                        DataKeyNames="id" ondatabound="DetailsView1_DataBound" 
                        oniteminserted="DetailsView1_ItemInserted" 
                        onitemupdated="DetailsView1_ItemUpdated" >
                    <AlternatingRowStyle BackColor="White" />
                    <Fields>
                        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" SortExpression="id" InsertVisible="false" />
                        <asp:TemplateField HeaderText="IT Asset SubType" SortExpression="ITAssetSubTypeID">
                            <EditItemTemplate>
                                <asp:DropDownList ID="DropDownList1" runat="server" 
                                    DataSourceID="LinqDS_SubType" DataTextField="SubTypeName" DataValueField="id" 
                                    SelectedValue='<%# Bind("ITAssetSubTypeID") %>'>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:DropDownList ID="DropDownList1" runat="server" 
                                    DataSourceID="LinqDS_SubType" DataTextField="SubTypeName" DataValueField="id" 
                                    SelectedValue='<%# Bind("ITAssetSubTypeID") %>'>
                                </asp:DropDownList>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <asp:DropDownList ID="DropDownList1" runat="server" 
                                    DataSourceID="LinqDS_SubType" DataTextField="SubTypeName" DataValueField="id" 
                                    Enabled="False" SelectedValue='<%# Bind("ITAssetSubTypeID") %>'>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ITAssetDetails" HeaderText="IT Asset Details" SortExpression="ITAssetDetails" />
                        <asp:BoundField DataField="UniquePartNum" HeaderText="Unique Part Number" SortExpression="UniquePartNum" />
                        <asp:BoundField DataField="ProductNumber" HeaderText="Product Number" SortExpression="ProductNumber" />
                        <asp:BoundField DataField="PR_NO" HeaderText="PR Number" SortExpression="PR_NO" />
                        <asp:BoundField DataField="PR_Date" HeaderText="PR Date" SortExpression="PR_Date" DataFormatString="{0:d}" >
                            <ControlStyle CssClass="date-type" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PO_NO" HeaderText="PO Number" SortExpression="PO_NO" />
                        <asp:BoundField DataField="PO_Date" HeaderText="PO Date" SortExpression="PO_Date" DataFormatString="{0:d}" >
                            <ControlStyle CssClass="date-type" />
                        </asp:BoundField>
                        <asp:BoundField DataField="CostCode" HeaderText="Cost Code" SortExpression="CostCode" />
                        <asp:BoundField DataField="SupplierID" HeaderText="Supplier" SortExpression="SupplierID" />
                        <asp:BoundField DataField="ReceivingNumber" HeaderText="Receiving Number" SortExpression="ReceivingNumber" />
                        <asp:BoundField DataField="ShipmentDate" HeaderText="Shipment Date" SortExpression="ShipmentDate" DataFormatString="{0:d}" >
                            <ControlStyle CssClass="date-type" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" />
                        <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency" />
                        <asp:BoundField DataField="WarrantyStart" HeaderText="Warranty Start" SortExpression="WarrantyStart" DataFormatString="{0:d}" >
                            <ControlStyle CssClass="date-type" />
                        </asp:BoundField>
                        <asp:BoundField DataField="WarrantyEnd" HeaderText="Warranty End" SortExpression="WarrantyEnd" DataFormatString="{0:d}" >
                            <ControlStyle CssClass="date-type" />
                        </asp:BoundField>
                        <asp:BoundField DataField="DateOfUse" HeaderText="Date of Use" SortExpression="DateOfUse" DataFormatString="{0:d}" >
                            <ControlStyle CssClass="date-type" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Submit Date" SortExpression="SubmitDate">
                            <ItemTemplate>
                                <asp:TextBox ID="TextBox4" runat="server" Enabled="False" 
                                    Text='<%# Bind("SubmitDate", "{0:d}") %>'></asp:TextBox>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="TextBox4" runat="server" Enabled="False" 
                                    Text='<%# Bind("SubmitDate", "{0:d}") %>'></asp:TextBox>
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Bind("SubmitDate", "{0:d}") %>'></asp:Label>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Submit By" SortExpression="SubmitBy">
                            <ItemTemplate>
                                <asp:TextBox ID="TextBox3" runat="server" Enabled="False" 
                                    Text='<%# Bind("SubmitBy") %>'></asp:TextBox>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="TextBox3" runat="server" Enabled="False" 
                                    Text='<%# Bind("SubmitBy") %>'></asp:TextBox>
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Bind("SubmitBy") %>'></asp:Label>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit Date" SortExpression="EditDate">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox1" runat="server" Enabled="False" 
                                    Text='<%# Bind("EditDate", "{0:d}") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="TextBox1" runat="server" Enabled="False" 
                                    Text='<%# Bind("EditDate", "{0:d}") %>'></asp:TextBox>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("EditDate", "{0:d}") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit By" SortExpression="EditBy">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox2" runat="server" Enabled="False" 
                                    Text='<%# Bind("EditBy") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="TextBox2" runat="server" Enabled="False" 
                                    Text='<%# Bind("EditBy") %>'></asp:TextBox>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("EditBy") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="isAsset" SortExpression="isAsset">
                            <EditItemTemplate>
                                <asp:DropDownList ID="DropDownList2" runat="server" 
                                    SelectedValue='<%# Bind("isAsset") %>'>
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:DropDownList ID="DropDownList2" runat="server" 
                                    SelectedValue='<%# Bind("isAsset") %>'>
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:DropDownList>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <asp:DropDownList ID="DropDownList2" runat="server" Enabled="False" 
                                    SelectedValue='<%# Bind("isAsset") %>'>
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Section" SortExpression="SectionID">
                            <EditItemTemplate>
                                <asp:DropDownList ID="DropDownList5" runat="server" 
                                    DataSourceID="SqlDS_Section" DataTextField="Section" DataValueField="id" 
                                    SelectedValue='<%# Bind("SectionID") %>'>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:DropDownList ID="DropDownList5" runat="server" 
                                    DataSourceID="SqlDS_Section" DataTextField="Section" DataValueField="id" 
                                    SelectedValue='<%# Bind("SectionID") %>'>
                                </asp:DropDownList>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <asp:DropDownList ID="DropDownList5" runat="server" 
                                    DataSourceID="SqlDS_Section" SelectedValue='<%# Bind("SectionID") %>' 
                                    DataTextField="Section" DataValueField="id" Enabled="False">
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField ControlStyle-Font-Underline="false" ShowEditButton="True" 
                            ShowInsertButton="True" InsertText="Save :: " EditText="Edit :: " 
                            UpdateText="Save :: " >
                        <ControlStyle Font-Underline="False" ForeColor="white" />
                        </asp:CommandField>
                    </Fields>
                    <EditRowStyle BackColor="#5C9CCC" />
                    <FieldHeaderStyle BackColor="#DEE8F5" Font-Bold="True" CssClass="manage-detailview-field-header" />
                    <HeaderTemplate>
                        Manage Asset Details
                    </HeaderTemplate>
                    <HeaderStyle BackColor="#336699" Font-Bold="True" ForeColor="White" Height="30px" />
                    <CommandRowStyle BackColor="#336699" Font-Underline="false" Height="30px" />
                    <RowStyle BackColor="#EFF3FB" BorderWidth="1px" BorderStyle="solid" BorderColor="#a6c9e2" />
                </asp:DetailsView>
                <!--End DetailView1 -->
                </td>

                <td valign="top">
                <!-- DetailView2 for Manage Assignment /-->
                 <asp:DetailsView ID="DetailsView2" runat="server" AutoGenerateRows="False" 
                    CellPadding="4" CssClass="manage-detailview" DataKeyNames="id" 
                    DataSourceID="SqlDS_DetailsView2" ForeColor="#333333" GridLines="None"
                    ondatabound="DetailsView2_DataBound">
                    <AlternatingRowStyle BackColor="White" />
                    <Fields>
                        <asp:BoundField DataField="id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="id" />
                        <asp:TemplateField HeaderText="Current User" SortExpression="currentUserID">
                            <EditItemTemplate>
                                <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="SqlDS_User" 
                                    DataTextField="Name" DataValueField="id" 
                                    SelectedValue='<%# Bind("currentUserID") %>'>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="SqlDS_User" 
                                    DataTextField="Name" DataValueField="id" 
                                    SelectedValue='<%# Bind("currentUserID") %>'>
                                </asp:DropDownList>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="SqlDS_User" 
                                    DataTextField="Name" DataValueField="id" Enabled="False" 
                                    SelectedValue='<%# Bind("currentUserID") %>'>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Current Location" SortExpression="currentLocationID">
                            <EditItemTemplate>
                                <asp:DropDownList ID="DropDownList4" runat="server" 
                                    DataSourceID="SqlDS_Location" DataTextField="Location" DataValueField="LID" 
                                    SelectedValue='<%# Bind("currentLocationID") %>'>
                                </asp:DropDownList>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:DropDownList ID="DropDownList4" runat="server" 
                                    DataSourceID="SqlDS_Location" DataTextField="Location" DataValueField="LID" 
                                    SelectedValue='<%# Bind("currentLocationID") %>'>
                                </asp:DropDownList>
                            </InsertItemTemplate>
                            <ItemTemplate>
                                <asp:DropDownList ID="DropDownList4" runat="server" 
                                    DataSourceID="SqlDS_Location" DataTextField="Location" DataValueField="LID" 
                                    Enabled="False" SelectedValue='<%# Bind("currentLocationID") %>'>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="enumStatus">
                            <ItemTemplate>
                                <asp:DropDownList ID="DropDownList6" runat="server"
                                    DataSourceID="SqlDS_Status_table" DataTextField="StatusName" DataValueField="id"
                                    Enabled="false" SelectedValue='<%# Bind("enumStatus") %>'>
                                </asp:DropDownList>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="DropDownList6" runat="server"
                                    DataSourceID="SqlDS_Status_table" DataTextField="StatusName" DataValueField="id"
                                    Enabled="true" SelectedValue='<%# Bind("enumStatus") %>'>
                                </asp:DropDownList>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit Date" SortExpression="EditDate">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox1" runat="server" Enabled="False" 
                                    Text='<%# Bind("EditDate") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("EditDate", "{0:d}") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit By" SortExpression="EditBy">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox2" runat="server" Enabled="False" 
                                    Text='<%# Bind("EditBy") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("EditBy") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Assignment Comment" SortExpression="AssignmentComment">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox3" runat="server" width="200px"
                                    Text='<%# Bind("AssignmentComment") %>' TextMode="MultiLine" Wrap="true"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Bind("AssignmentComment") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Wrap="true" />
                        </asp:TemplateField>
                        <asp:CommandField ControlStyle-Font-Underline="false" EditText="&nbsp; Edit &nbsp;" ShowEditButton="True" UpdateText="Save :: ">
                            <ControlStyle Font-Underline="False" ForeColor="white" />
                        </asp:CommandField>
                    </Fields>
                    <EditRowStyle BackColor="#5C9CCC" />
                    <FieldHeaderStyle BackColor="#DEE8F5" Font-Bold="True" CssClass="manage-detailview-field-header"/>
                    <HeaderTemplate>
                        Manage Assignment
                    </HeaderTemplate>
                    <HeaderStyle BackColor="#336699" Font-Bold="True" ForeColor="White" Height="30px" />
                    <CommandRowStyle BackColor="#336699" Font-Underline="false" Height="30px" />
                    <RowStyle BackColor="#EFF3FB" BorderColor="#a6c9e2" BorderStyle="solid" BorderWidth="1px" />
                </asp:DetailsView>
                <!-- End Details View /-->
                <asp:SqlDataSource ID="SqlDS_DetailsView1" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                        SelectCommand="SELECT * FROM [ITASSET].[ITAssetProductInfo] WHERE ([id] = @id)" 
                        DeleteCommand="DELETE FROM [ITASSET].[ITAssetProductInfo] WHERE [id] = @id" 
                        InsertCommand="INSERT INTO [ITASSET].[ITAssetProductInfo] ([ITAssetSubTypeID], [ITAssetDetails], [UniquePartNum], [ProductNumber], [PR_NO], [PR_Date], [PO_NO], [PO_Date], [CostCode], [SupplierID], [ReceivingNumber], [ShipmentDate], [Price], [Currency], [WarrantyStart], [WarrantyEnd], [DateOfUse], [SubmitDate], [SubmitBy], [EditDate], [EditBy], [isAsset], [SectionID]) VALUES (@ITAssetSubTypeID, @ITAssetDetails, @UniquePartNum, @ProductNumber, @PR_NO, @PR_Date, @PO_NO, @PO_Date, @CostCode, @SupplierID, @ReceivingNumber, @ShipmentDate, @Price, @Currency, @WarrantyStart, @WarrantyEnd, @DateOfUse, @SubmitDate, @SubmitBy, @EditDate, @EditBy, @isAsset, @SectionID)" 
                        UpdateCommand="UPDATE [ITASSET].[ITAssetProductInfo] SET [ITAssetSubTypeID] = @ITAssetSubTypeID, [ITAssetDetails] = @ITAssetDetails, [UniquePartNum] = @UniquePartNum, [ProductNumber] = @ProductNumber, [PR_NO] = @PR_NO, [PR_Date] = @PR_Date, [PO_NO] = @PO_NO, [PO_Date] = @PO_Date, [CostCode] = @CostCode, [SupplierID] = @SupplierID, [ReceivingNumber] = @ReceivingNumber, [ShipmentDate] = @ShipmentDate, [Price] = @Price, [Currency] = @Currency, [WarrantyStart] = @WarrantyStart, [WarrantyEnd] = @WarrantyEnd, [DateOfUse] = @DateOfUse, [EditDate] = getdate(), [EditBy] = @EditBy, [isAsset] = @isAsset, [SectionID] = @SectionID WHERE [id] = @id">
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="ITAssetSubTypeID" Type="Int32" />
                        <asp:Parameter Name="ITAssetDetails" Type="String" />
                        <asp:Parameter Name="UniquePartNum" Type="String" />
                        <asp:Parameter Name="ProductNumber" Type="String" />
                        <asp:Parameter Name="PR_NO" Type="String" />
                        <asp:Parameter Name="PR_Date" Type="DateTime" />
                        <asp:Parameter Name="PO_NO" Type="String" />
                        <asp:Parameter Name="PO_Date" Type="DateTime" />
                        <asp:Parameter Name="CostCode" Type="String" />
                        <asp:Parameter Name="SupplierID" Type="String" />
                        <asp:Parameter Name="ReceivingNumber" Type="String" />
                        <asp:Parameter Name="ShipmentDate" Type="DateTime" />
                        <asp:Parameter Name="Price" Type="Decimal" />
                        <asp:Parameter Name="Currency" Type="String" />
                        <asp:Parameter Name="WarrantyStart" Type="DateTime" />
                        <asp:Parameter Name="WarrantyEnd" Type="DateTime" />
                        <asp:Parameter Name="DateOfUse" Type="DateTime" />
                        <asp:Parameter Name="SubmitDate" Type="DateTime" />
                        <asp:Parameter Name="SubmitBy" Type="String" />
                        <asp:Parameter Name="EditDate" Type="DateTime" />
                        <asp:Parameter Name="EditBy" Type="String" />
                        <asp:Parameter Name="isAsset" Type="Decimal" />
                        <asp:Parameter Name="SectionID" Type="Int32" />
                    </InsertParameters>
                    <SelectParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="ITAssetSubTypeID" Type="Int32" />
                        <asp:Parameter Name="ITAssetDetails" Type="String" />
                        <asp:Parameter Name="UniquePartNum" Type="String" />
                        <asp:Parameter Name="ProductNumber" Type="String" />
                        <asp:Parameter Name="PR_NO" Type="String" />
                        <asp:Parameter Name="PR_Date" Type="DateTime" />
                        <asp:Parameter Name="PO_NO" Type="String" />
                        <asp:Parameter Name="PO_Date" Type="DateTime" />
                        <asp:Parameter Name="CostCode" Type="String" />
                        <asp:Parameter Name="SupplierID" Type="String" />
                        <asp:Parameter Name="ReceivingNumber" Type="String" />
                        <asp:Parameter Name="ShipmentDate" Type="DateTime" />
                        <asp:Parameter Name="Price" Type="Decimal" />
                        <asp:Parameter Name="Currency" Type="String" />
                        <asp:Parameter Name="WarrantyStart" Type="DateTime" />
                        <asp:Parameter Name="WarrantyEnd" Type="DateTime" />
                        <asp:Parameter Name="DateOfUse" Type="DateTime" />
                        <asp:Parameter Name="SubmitDate" Type="DateTime" />
                        <asp:Parameter Name="SubmitBy" Type="String" />
                        <asp:Parameter Name="EditDate" Type="DateTime" />
                        <asp:Parameter Name="EditBy" Type="String" />
                        <asp:Parameter Name="isAsset" Type="Decimal" />
                        <asp:Parameter Name="SectionID" Type="Int32" />
                        <asp:Parameter Name="id" Type="Int32" DefaultValue="83" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                
                <asp:SqlDataSource ID="SqlDS_DetailsView2" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                        DeleteCommand="DELETE FROM [ITASSET].[ITAssetProductInfo] WHERE [id] = @id" 
                        SelectCommand="SELECT * FROM [ITASSET].[ITAssetProductInfo] WHERE ([id] = @id)" 
                        UpdateCommand="UPDATE [ITASSET].[ITAssetProductInfo] SET [enumStatus] = @enumStatus, [currentUserID] = @currentUserID, [currentLocationID] = @currentLocationID, [AssignmentComment] = @AssignmentComment WHERE [id] = @id">
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                    <SelectParameters>
                        <asp:ControlParameter ControlID="DetailsView1" Name="id" 
                            PropertyName="SelectedValue" Type="Int32" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="enumStatus" Type="Decimal" />
                        <asp:Parameter Name="currentUserID" Type="Int32" />
                        <asp:Parameter Name="currentLocationID" Type="Int32" />
                        <asp:Parameter Name="AssignmentComment" Type="String" />
                        <asp:Parameter Name="id" Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>

                <asp:LinqDataSource ID="LinqDS_SubType" runat="server" OrderBy="SubTypeName"
                    ContextTypeName="DataClassesDataContext" EntityTypeName="" 
                    Select="new (id, SubTypeName)" TableName="ITAssetSubTypes" >
                </asp:LinqDataSource>
                <asp:SqlDataSource ID="SqlDS_Status_table" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                    SelectCommand="SELECT NULL AS [id], 'N/A' AS [StatusName] UNION SELECT * FROM [ITASSET].[enumStatus]"></asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDS_User" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                    SelectCommand="SELECT [id], [Name] FROM [vw_All_Users] ORDER BY [Name]"></asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDS_Location" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                    SelectCommand="SELECT NULL AS LID, ' N/A' AS Location UNION SELECT [LID], [Location] FROM [ITASSET].[Location] ORDER BY [Location]">
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDS_Section" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                    SelectCommand="SELECT NULL AS id, ' N/A' AS Code, 'N/A' AS Section UNION SELECT [id], [Code], [Section] FROM [ITASSET].[Section] ORDER BY Code">
                </asp:SqlDataSource>
            </td></tr></table>

            </asp:View>
        </asp:MultiView>
    </div>
    
    <!-- Start tab 2 /-->
    <div id="tabs-2">
        <asp:GridView ID="GridView_FullList" runat="server" DataSourceID="SqlDS_FullList"
            CssClass="gridview-purple" AllowSorting="True" AutoGenerateColumns="False" 
            DataKeyNames="id" AllowPaging="True" PageSize="30">
            <Columns>
                <asp:TemplateField ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete" 
                            OnClientClick="return confirm('Are you sure you want to delete this item, This will also delete its related history?');" >
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" SortExpression="id" />
                <asp:BoundField DataField="ITAssetDetails" HeaderText="IT Asset Details" SortExpression="ITAssetDetails" />
                <asp:BoundField DataField="UniquePartNum" HeaderText="Unique Part No." SortExpression="UniquePartNum" />
                <asp:BoundField DataField="Location" HeaderText="Current Location" SortExpression="Location" />
                <asp:BoundField DataField="StatusName" HeaderText="Status" SortExpression="StatusName" />
                <asp:BoundField DataField="UserName" HeaderText="Current User Name" SortExpression="UserName" />
                <asp:BoundField DataField="currentUserID" HeaderText="User ID" SortExpression="currentUserID" />
            </Columns>
            <AlternatingRowStyle CssClass="gridview-purple-alternate" />
            <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" NextPageText="Next" PreviousPageText="Prev" />
            <PagerStyle CssClass="gridview-purple-footer" VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center"/>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDS_FullList" runat="server"
            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
            SelectCommand="SELECT [id], [ITAssetDetails], [UniquePartNum], [currentUserID], [Location], [StatusName], [UserName] FROM [vw_ITAssetAllProducts]"
            DeleteCommand="DELETE FROM ITASSET.ITAssetAssignHistory WHERE ([ITAssetProductInfoID] = @id); DELETE FROM ITASSET.ITAssetProductInfo WHERE ([id]= @id);" >
            <DeleteParameters>
                <asp:ControlParameter ControlID="GridView_FullList" Name="id" PropertyName="SelectedValue" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>
    </div>

    <!-- Start tab 3 /-->
    <div id="tabs-3">
        <p>
            <asp:LinkButton ID="LinkBtnAddNewAsset" CssClass="button" runat="server" onclick="LinkBtnAddNewAsset_Click">Add New IT Asset</asp:LinkButton>
            <asp:LinkButton ID="linkBtn_category" CssClass="button" runat="server" onclick="linkBtn_category_Click">Manage Catory Item</asp:LinkButton>
            <asp:LinkButton ID="linkBtn_user" CssClass="button" runat="server" onclick="linkBtn_user_Click">Manage External User</asp:LinkButton>
            <asp:LinkButton ID="linkBtn_location" CssClass="button" runat="server" 
                onclick="linkBtn_location_Click" >Manage Location</asp:LinkButton>
            <asp:LinkButton ID="linkBtn_dept" CssClass="button" runat="server" onclick="linkBtn_dept_Click" >Manage Section</asp:LinkButton>
        </p>
        <br /><asp:Label runat="server" ID="Add_Remove_Loc" Text="Please choose action button above" Font-Bold="true"></asp:Label>
        <hr />
            <asp:MultiView ID="MultiView2" runat="server" ActiveViewIndex="0">
                <asp:View ID="View00" runat="server">
                    <em style="color:Red;">These actions require Administrator Privilege</em>
                </asp:View>
                <asp:View ID="View01" runat="server">
                    <asp:GridView ID="GridView_Cateory_Item" runat="server" AllowSorting="True" 
                        DataSourceID="SqlDS_Cateory_Item" CssClass="gridview-purple" 
                        AutoGenerateColumns="False" DataKeyNames="id">
                        <Columns>
                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" 
                                UpdateText="Save ::" EditText="Edit ::" ControlStyle-CssClass="no-underline" 
                                HeaderText="Command" >
                            <ControlStyle CssClass="no-underline" />
                            </asp:CommandField>
                            <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" SortExpression="id" />
                            <asp:TemplateField HeaderText="Main Type" SortExpression="ITAssetTypeID">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DropDownList7" runat="server" Enabled="true" DataSourceID="LinqDS_Asset_MainType"
                                        SelectedValue='<%# Bind("ITAssetTypeID") %>' DataValueField="id" DataTextField="TypeName">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("TypeName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="SubTypeName" HeaderText="Sub Type" SortExpression="SubTypeName" />
                            <asp:BoundField DataField="SubTypeDetails" HeaderText="Sub Type Details" SortExpression="SubTypeDetails" />
                        </Columns>
                        <AlternatingRowStyle CssClass="gridview-purple-alternate" />
                        <EditRowStyle BackColor="#5C9CCC" ForeColor="White" Font-Bold="true" />
                        <PagerStyle CssClass="gridview-purple-footer" VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center"/>
                    </asp:GridView>
                    <asp:LinqDataSource ID="LinqDS_Asset_MainType" runat="server" 
                        ContextTypeName="DataClassesDataContext" EntityTypeName="" 
                        Select="new (id, TypeName)" TableName="ITAssetTypes">
                    </asp:LinqDataSource>
                    <asp:SqlDataSource ID="SqlDS_Cateory_Item" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                        DeleteCommand="DELETE FROM [ITASSET].[ITAssetSubType] WHERE [id] = @id" 
                        InsertCommand="INSERT INTO [ITASSET].[ITAssetSubType] ([ITAssetTypeID], [SubTypeName], [SubTypeDetails]) VALUES (@ITAssetTypeID, @SubTypeName, @SubTypeDetails)" 
                        SelectCommand="SELECT ITAssetSubType.id, SubTypeName, SubTypeDetails, ITAssetTypeID, TypeName FROM ITASSET.ITAssetSubType INNER JOIN ITASSET.ITAssetType ON ITASSET.ITAssetSubType.ITAssetTypeID = ITASSET.ITAssetType.id" 
                        UpdateCommand="UPDATE [ITASSET].[ITAssetSubType] SET [ITAssetTypeID] = @ITAssetTypeID, [SubTypeName] = @SubTypeName, [SubTypeDetails] = @SubTypeDetails WHERE [id] = @id">
                        <DeleteParameters>
                            <asp:Parameter Name="id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="id" Type="Int32" />
                            <asp:Parameter Name="ITAssetTypeID" Type="Int32" />
                            <asp:Parameter Name="SubTypeName" Type="String" />
                            <asp:Parameter Name="SubTypeDetails" Type="String" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="id" Type="Int32" />
                            <asp:Parameter Name="ITAssetTypeID" Type="Int32" />
                            <asp:Parameter Name="SubTypeName" Type="String" />
                            <asp:Parameter Name="SubTypeDetails" Type="String" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </asp:View>
                <asp:View ID="View02" runat="server">
                    <table><tr><td>
                        <asp:GridView ID="GridView_User_Item" runat="server" AllowSorting="True" 
                            CssClass="gridview-purple" DataKeyNames="id" DataSourceID="SqlDS_User_table" 
                            AutoGenerateColumns="False" AllowPaging="True" PageSize="25" 
                            onselectedindexchanged="GridView_User_Item_SelectedIndexChanged">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" SortExpression="id" InsertVisible="False" />
                                <asp:TemplateField HeaderText=" User Type " 
                                    SortExpression="enumExternalUserType">
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="DropDownList8" runat="server" 
                                            SelectedValue='<%# Bind("enumExternalUserType") %>'>
                                            <asp:ListItem Value="1" Text="Consultant"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Contractor"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="In-tern"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Guest"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="User Group"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Others"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        <asp:DropDownList ID="DropDownList8" runat="server" 
                                            SelectedValue='<%# Bind("enumExternalUserType") %>'>
                                            <asp:ListItem Value="1" Text="Consultant"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Contractor"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="In-tern"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Guest"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="User Group"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Others"></asp:ListItem>
                                        </asp:DropDownList>
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <asp:DropDownList ID="DropDownList8" runat="server" Enabled="false"
                                            SelectedValue='<%# Bind("enumExternalUserType") %>'>
                                            <asp:ListItem Value="1" Text="Consultant"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Contractor"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="In-tern"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Guest"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="User Group"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Others"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                                <asp:BoundField DataField="Details" HeaderText="Details" 
                                    SortExpression="Details" />
                            </Columns>
                            <AlternatingRowStyle CssClass="gridview-purple-alternate" />
                            <SelectedRowStyle BackColor="#5C9CCC" Font-Bold="true" ForeColor="White" />
                            <PagerStyle CssClass="gridview-purple-footer" Font-Bold="true" HorizontalAlign="Center" VerticalAlign="Middle" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDS_User_table" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                            DeleteCommand="DELETE FROM [ITASSET].[ExternalUser] WHERE [id] = @id" 
                            InsertCommand="INSERT INTO [ITASSET].[ExternalUser] ([enumExternalUserType], [Name], [Details]) VALUES (@enumExternalUserType, @Name, @Details)" 
                            SelectCommand="SELECT * FROM [ITASSET].[ExternalUser]" 
                            UpdateCommand="UPDATE [ITASSET].[ExternalUser] SET [enumExternalUserType] = @enumExternalUserType, [Name] = @Name, [Details] = @Details WHERE [id] = @id">
                            <DeleteParameters>
                                <asp:Parameter Name="id" Type="Int32" />
                            </DeleteParameters>
                            <InsertParameters>
                                <asp:Parameter Name="enumExternalUserType" Type="Int32" />
                                <asp:Parameter Name="Name" Type="String" />
                                <asp:Parameter Name="Details" Type="String" />
                            </InsertParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="enumExternalUserType" Type="Int32" />
                                <asp:Parameter Name="Name" Type="String" />
                                <asp:Parameter Name="Details" Type="String" />
                                <asp:Parameter Name="id" Type="Int32" />
                            </UpdateParameters>
                        </asp:SqlDataSource>
                    </td><td valign="top">
                        <asp:DetailsView ID="DetailsView_User_Item" runat="server" 
                                AutoGenerateRows="False" DataKeyNames="id" 
                                DataSourceID="SqlDS_User_table" Width="400px">
                            <Fields>
                                <asp:BoundField DataField="id" HeaderText=" ID " InsertVisible="False" ReadOnly="True" SortExpression="id" />
                                <asp:TemplateField HeaderText=" External UserType " 
                                    SortExpression="enumExternalUserType">
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="DropDownList8" runat="server" 
                                            SelectedValue='<%# Bind("enumExternalUserType") %>'>
                                            <asp:ListItem Value="1" Text="Consultant"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Contractor"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="In-tern"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Guest"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="User Group"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Others"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        <asp:DropDownList ID="DropDownList8" runat="server" 
                                            SelectedValue='<%# Bind("enumExternalUserType") %>'>
                                            <asp:ListItem Value="1" Text="Consultant"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Contractor"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="In-tern"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Guest"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="User Group"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Others"></asp:ListItem>
                                        </asp:DropDownList>
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <asp:DropDownList ID="DropDownList8" runat="server" Enabled="false"
                                            SelectedValue='<%# Bind("enumExternalUserType") %>'>
                                            <asp:ListItem Value="1" Text="Consultant"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Contractor"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="In-tern"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Guest"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="User Group"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Others"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText=" Name " SortExpression="Name" />
                                <asp:BoundField DataField="Details" HeaderText=" Details " SortExpression="Details" />
                                <asp:CommandField ShowEditButton="True" ShowInsertButton="True" EditText="Edit ::" UpdateText="Save ::" InsertText="Save ::" />
                            </Fields>
                            <EditRowStyle BackColor="#5C9CCC" ForeColor="White" Font-Bold="true" />
                            <FieldHeaderStyle BackColor="#DEE8F5" Font-Bold="True" CssClass="manage-detailview-field-header" />
                            <HeaderTemplate>
                                Detail of your selected user
                            </HeaderTemplate>
                            <HeaderStyle BackColor="#336699" Font-Bold="True" ForeColor="White" Height="30px" />
                            <CommandRowStyle BackColor="#336699" Height="30px" Font-Bold="true" ForeColor="White" CssClass="no-underline" />
                            <RowStyle BackColor="#EFF3FB" BorderWidth="1px" BorderStyle="solid" BorderColor="#a6c9e2" />
                        </asp:DetailsView>
                    </td></tr></table>
                </asp:View>
                <asp:View ID="View03" runat="server">
                    <asp:GridView ID="GridView_Location" runat="server" AutoGenerateColumns="False" 
                        DataSourceID="SqlDS_Location_Table" DataKeyNames="lid" AllowPaging="True" 
                        AllowSorting="True" CssClass="gridview-purple" PageSize="30">
                        <Columns>
                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" EditText=" Edit ::" UpdateText=" Save ::" InsertText=" Save ::" ControlStyle-Font-Underline="false" />
                            <asp:BoundField DataField="lid" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="LID" />
                            <asp:BoundField DataField="Location" HeaderText="Location" SortExpression="Location" />
                            <asp:BoundField DataField="Details" HeaderText="Location Details" SortExpression="Details" />
                        </Columns>
                        <EditRowStyle BackColor="#5C9CCC" ForeColor="White" Font-Bold="true" />
                        <AlternatingRowStyle CssClass="gridview-purple-alternate" />
                        <SelectedRowStyle BackColor="#5C9CCC" Font-Bold="true" ForeColor="White" />
                        <PagerStyle CssClass="gridview-purple-footer" Font-Bold="true" HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDS_Location_Table" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                        SelectCommand="SELECT LID, Location, Details FROM [ITASSET].[Location]" 
                        DeleteCommand="DELETE FROM [ITASSET].[Location] WHERE [LID] = @LID" 
                        InsertCommand="INSERT INTO [ITASSET].[Location] ([Location], [Details]) VALUES (@Location, @Details)" 
                        UpdateCommand="UPDATE [ITASSET].[Location] SET [Location] = @Location, [Details] = @Details WHERE [LID] = @LID">
                        <DeleteParameters>
                            <asp:Parameter Name="LID" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Location" Type="String" />
                            <asp:Parameter Name="Details" Type="String" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Location" Type="String" />
                            <asp:Parameter Name="Details" Type="String" />
                            <asp:Parameter Name="LID" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                    
                </asp:View>
                <asp:View ID="View04" runat="server">
                    
                    <asp:GridView ID="GridView_Section" runat="server" AllowPaging="True" 
                        AllowSorting="True" AutoGenerateColumns="False" CssClass="gridview-purple" 
                        DataSourceID="SqlDS_Section_Table" PageSize="30" DataKeyNames="id">
                        <Columns>
                            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" 
                                EditText=" Edit ::" UpdateText=" Save ::" InsertText=" Save ::" 
                                ControlStyle-Font-Underline="false" >
                            <ControlStyle Font-Underline="False" />
                            </asp:CommandField>
                            <asp:BoundField DataField="id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="id" />
                            <asp:TemplateField HeaderText="DivisionID" SortExpression="DivisionID">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DropDownList9" runat="server" 
                                        SelectedValue='<%# Bind("DivisionID") %>' DataSourceID="LinqDS_Division" 
                                        DataTextField="Code" DataValueField="id">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("DivisionName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Section" HeaderText="Section Name" SortExpression="Section" />
                            <asp:BoundField DataField="Code" HeaderText="Code" SortExpression="Code" />
                        </Columns>
                        <EditRowStyle BackColor="#5C9CCC" ForeColor="White" Font-Bold="true" />
                        <AlternatingRowStyle CssClass="gridview-purple-alternate" />
                        <SelectedRowStyle BackColor="#5C9CCC" Font-Bold="true" ForeColor="White" />
                        <PagerStyle CssClass="gridview-purple-footer" Font-Bold="true" 
                            HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDS_Section_Table" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ITAssetTrackingConnectionString2 %>" 
                        DeleteCommand="DELETE FROM [ITASSET].[Section] WHERE [id] = @id" 
                        InsertCommand="INSERT INTO [ITASSET].[Section] ([DivisionID], [Section], [Code]) VALUES (@DivisionID, @Section, @Code)" 
                        SelectCommand="SELECT Section.id, Section.DivisionID, Division.Code AS DivisionName, Section.Section, Section.Code FROM ITASSET.Section INNER JOIN ITASSET.Division ON DivisionID = Division.id;" 
                        UpdateCommand="UPDATE [ITASSET].[Section] SET [DivisionID] = @DivisionID, [Section] = @Section, [Code] = @Code WHERE [id] = @id">
                        <DeleteParameters>
                            <asp:Parameter Name="id" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="DivisionID" Type="Int32" />
                            <asp:Parameter Name="Section" Type="String" />
                            <asp:Parameter Name="Code" Type="String" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="DivisionID" Type="Int32" />
                            <asp:Parameter Name="Section" Type="String" />
                            <asp:Parameter Name="Code" Type="String" />
                            <asp:Parameter Name="id" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                    <asp:LinqDataSource ID="LinqDS_Division" runat="server" 
                        ContextTypeName="DataClassesDataContext" EntityTypeName="" 
                        Select="new (id, Division1, Code)" TableName="Divisions">
                    </asp:LinqDataSource>
                </asp:View>
            </asp:MultiView>
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
        $(".date-type").datepicker({
            showWeek: true,
            firstDay: 1
        });
    });

    //Toggle Filter Panel On-Off
    $("#HideShowPanel-1").click(function () {
        $('.manage-filter-panel').toggle("slow");
    });
</script>
<asp:HiddenField ID="hfSelectedTAB" runat="server"  Value="0"/>
</asp:Content>
