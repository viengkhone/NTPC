<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="DccDB.aspx.cs" Inherits="DCCDB" culture="en-GB" uiCulture="en-GB" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="design/jQueryUI/css/le-frog/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        div#settings .ui-tabs-nav li.ui-tabs-active a 
        {
            color: #005B00; font-weight: bold;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!--line shows location where users are in-->
    <div class="website-current-location">
        Home >> DCC Database
    </div>

    <!--start content-->
    <div id="settings">
    <ul>
        <li><a href="#tabs-1">Search/Filter</a></li>
        <li><a href="#tabs-2">Document View</a></li>
        <li><a href="#tabs-3">Ajax Tab</a></li>
    </ul>

    <!-- Start tab 1 -->
    <div id="tabs-1">
    <asp:LinkButton ID="LinkBtn_add" CssClass="button" runat="server" onclick="LinkBtn_add_Click">Add New Document</asp:LinkButton>
    <asp:LinkButton ID="LinkBtn_mod" CssClass="button" runat="server" onclick="LinkBtn_mod_Click">Existing Document</asp:LinkButton>
    <br /><br />
    <asp:MultiView ID="Multiview1" ActiveViewIndex="0" runat="server">
        <asp:View ID="view3" runat="server">
            <div class="dcc-search-panel">
             <table id="SearchBoxTable" border="1" cellpadding="0" cellspacing="0">
                <tr>
                    <th class="ui-widget-header search-head">1. Search by Document ID:</th>
                    <td><asp:TextBox runat="server" ID="txbDocID" Width="100px" /></td>
                    <td><asp:Button ID="btnSearch1" runat="server" CssClass="button" Text="Search" onclick="btnSearch1_Click" /></td>
                    <th class="ui-widget-header search-head">Filter</th>
                </tr>
                <tr>
                    <th class="ui-widget-header search-head">2. Search by Contract:</th>
                    <td><asp:TextBox runat="server" ID="txbContract" Width="150px" /></td>
                    <td><asp:Button ID="btnSearch2" runat="server" CssClass="button" Text="Search" onclick="btnSearch2_Click" /></td>
                    <td rowspan="6"  style="width: 300px; vertical-align: middle; text-align: center">
                        <asp:DropDownList ID="DocYear" runat="server" DataSourceID="SqlDs_DocYear" CssClass="custom-combobox-input  ui-state-default ui-corner-all" 
                            DataTextField="DocYear" DataValueField="DocYear" AppendDataBoundItems="true">
                            <asp:ListItem Value="0" Text="Choose Year" />
                            <asp:ListItem Value="0" Text="No Year" />
                        </asp:DropDownList><asp:Button ID="Button1" runat="server" CssClass="button" 
                            Text="Go" onclick="Button1_Click" />
                        <asp:SqlDataSource ID="SqlDs_DocYear" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
                            SelectCommand="SELECT DISTINCT YEAR(DateDocument) AS DocYear FROM tblDCCMain WHERE DateDocument IS NOT NULL ORDER BY 1;">
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <th class="ui-widget-header search-head">3. Search by Global Doc. Reference:</th>
                    <td><asp:TextBox runat="server" ID="txbGlobalRef" Width="200px" /></td>
                    <td><asp:Button ID="btnSearch3" runat="server" CssClass="button" Text="Search" 
                            onclick="btnSearch3_Click" /></td>
                </tr>
                <tr>
                    <th class="ui-widget-header search-head">4. Search by DCC Log Number:</th>
                    <td><asp:TextBox runat="server" ID="txbDCCLogNo" Width="250px" /></td>
                    <td><asp:Button ID="btnSearch4" runat="server" CssClass="button" Text="Search" 
                            onclick="btnSearch4_Click" /></td>
                </tr>
                <tr>
                    <th class="ui-widget-header search-head">5. Search by Title (keyword):</th>
                    <td><asp:TextBox runat="server" ID="txbDocKeyword" Width="250px" /></td>
                    <td><asp:Button ID="btnSearch5" runat="server" CssClass="button" Text="Search" 
                            onclick="btnSearch5_Click" /></td>
                </tr>
                <tr>
                    <th class="ui-widget-header search-head">6. Search by Box Archive No.:</th>
                    <td><asp:TextBox runat="server" ID="txbArchiveBoxReference" Width="200px" /></td>
                    <td><asp:Button ID="btnArchivBox" runat="server" CssClass="button" Text="Search" onclick="btnArchivBox_Click" /></td>
                </tr>
                <tr>
                    <th class="ui-widget-header search-head">7. Search by Originator:</th>
                    <td><asp:TextBox runat="server" ID="txbOriginator" Width="200px" /></td>
                    <td><asp:Button ID="btnOriginator" runat="server" CssClass="button" Text="Search" onclick="btnOriginator_Click" /></td>
                </tr>
            </table>
            </div>

            <asp:GridView ID="gridview_main" runat="server" AllowPaging="True" CssClass="gridview-main"
                AllowSorting="True" DataSourceID="SqlDS_Gridview_Main"
                AutoGenerateColumns="False" DataKeyNames="DocID" PageSize="20"
                onselectedindexchanged="gridview_main_SelectedIndexChanged" >
                <Columns>
                    <asp:TemplateField HeaderText="Link">
                        <ItemTemplate>
                            <asp:LinkButton ID="BtnRelateDoc" Text='<%# Bind("DocID") %>' runat="server" CssClass="ui-icon ui-icon-shuffle" OnClientClick="return OpenDialogBox(this);"></asp:LinkButton>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="DocID" HeaderText="IDocIDD" InsertVisible="False" ReadOnly="True" Visible="false" SortExpression="DocID" />
                    <asp:BoundField DataField="DCCLogNo" HeaderText="LogNo" 
                        SortExpression="DCCLogNo" ItemStyle-CssClass="middle-align" >
                    <ItemStyle CssClass="middle-align" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Subject/Title" SortExpression="NewDocTitle" ItemStyle-CssClass="field-subject">
                        <ItemTemplate>
                            <span style="cursor:pointer" class="titles" title="<%# Eval("NewDocumentTitle") %>"><%# Eval("NewDocTitle") %></span>
                        </ItemTemplate>
                        <ItemStyle CssClass="field-subject" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="GlobalReference" HeaderText="Doc. Reference" 
                        SortExpression="GlobalReference" ItemStyle-CssClass="left-align" >
                    <ItemStyle CssClass="left-align" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DateDocument" HeaderText="Doc. Date" SortExpression="DateDocument" DataFormatString="{0:dd.MM.yyyy}" />
                    <asp:BoundField DataField="OriginatorCode" HeaderText="Origi nator" 
                        SortExpression="OriginatorCode" ItemStyle-CssClass="middle-align" >
                    <ItemStyle CssClass="middle-align" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CompanyCode" HeaderText="Addre ssee" 
                        SortExpression="CompanyCode" ItemStyle-CssClass="middle-align" >
                    <ItemStyle CssClass="middle-align" />
                    </asp:BoundField>
                    <asp:BoundField DataField="InOut" HeaderText="In/ Out" SortExpression="InOut" >
                    <ItemStyle HorizontalAlign="Center"/>
                    </asp:BoundField>
                    <asp:BoundField DataField="OldContractNo" HeaderText="Contract" 
                        SortExpression="OldContractNo" ItemStyle-CssClass="middle-align" >
                    <ItemStyle CssClass="middle-align" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FillingCode" HeaderText="Filling Code" 
                        SortExpression="FillingCode" ItemStyle-Wrap="false" >
                    <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SharePointDocID" HeaderText="SharePoint" 
                        SortExpression="SharePointDocID" ItemStyle-CssClass="middle-align" >
                    <ItemStyle CssClass="middle-align" />
                    </asp:BoundField>
                    <asp:HyperLinkField DataTextField="DocID" HeaderText="ID" SortExpression="DocID" DataNavigateUrlFields="LienDoc" DataNavigateUrlFormatString="{0}" Target="_blank">
                        <ItemStyle CssClass="gridview-link" />
                    </asp:HyperLinkField>
                    <asp:CommandField ShowSelectButton="True" SelectText="Edit" ItemStyle-CssClass="gridview-link" >
                        <ItemStyle CssClass="gridview-link" />
                    </asp:CommandField>
                </Columns>
                <AlternatingRowStyle CssClass="field-alternate" />
                <EmptyDataTemplate>
                    Empty Form
                </EmptyDataTemplate>
                <HeaderStyle CssClass="ui-widget-header" />
                <PagerStyle CssClass="ui-widget-header" HorizontalAlign="Center"/>
                <PagerSettings FirstPageText="First" PreviousPageText="Privious" NextPageText="Next" LastPageText="Last" Mode="NumericFirstLast" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDS_Gridview_Main" runat="server" 
                ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
                SelectCommand="SELECT TOP 1000 * FROM [dbo].[vw_DCC_DocDB_ALL] ORDER BY [DocID] DESC;" >
            </asp:SqlDataSource>
        </asp:View>
        </asp:MultiView>
    </div>

    <!-- Start tab 2 -->
    <div id="tabs-2">
        <asp:LinkButton ID="LinkButton1" CssClass="button" runat="server" onclick="LinkBtn_add_Click">Add New Document</asp:LinkButton>
        <asp:LinkButton ID="LinkButton2" CssClass="button" runat="server" onclick="LinkBtn_mod_Click">Existing Document</asp:LinkButton>
        <br /><br />
        <asp:MultiView ID="Multiview2" runat="server" ActiveViewIndex="0">
        <asp:View ID="view0"  runat="server">
        <!-- Start Form View -->
        <div id="formview-background">
            <asp:FormView ID="FormView1" runat="server" Width="100%" CssClass="formview-doc-main" DataKeyNames="DocID"
                DataSourceID="SqlDS_Form_DCCMain" ondatabound="FormView1_DataBound" oniteminserted="FormView1_ItemInserted" onitemdeleted="FormView1_ItemDeleted">
                <EditItemTemplate>
                <!--Start Edit Table-->
                    <table id="dcc-edit-doc">
                        <tr>
                            <th><span class="frm-label">Document ID</span></th>
                            <td><asp:TextBox ID="DocIDTextBox" Enabled="false" runat="server" Text='<%# Bind("DocID") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">In/Out</span></th>
                            <td><asp:DropDownList ID="DropDown_InOutTextBox" runat="server" SelectedValue="<%# Bind('InOut') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                    <asp:ListItem Value="In">IN</asp:ListItem>
                                    <asp:ListItem Value="Out">OUT</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">DCC Log Number</span></th>
                            <td><asp:TextBox ID="DCCLogNoTextBox" runat="server" Text='<%# Bind("DCCLogNo") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">DCC Location</span></th>
                            <td><asp:DropDownList ID="DropDownList_DCCLocation" runat="server" SelectedValue="<%# Bind('DCCLocation') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                    <asp:ListItem Value="VTE">NTPC</asp:ListItem>
                                    <asp:ListItem Value="RNT">NTPR</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Carrier Name</span></th>
                            <td><asp:DropDownList ID="DropDown_Carrier_Name" runat="server" DataSourceID="SqlDS_DCCLookup_CarrierName" AppendDataBoundItems="true" 
                                    DataTextField="fieldtext" DataValueField="fieldvalue" SelectedValue="<%# Bind('CarrieName') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>&nbsp;Ref.&nbsp;<asp:TextBox ID="CarrieRefTextBox" runat="server" Text='<%# Bind("CarrieRef") %>' />
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">DCC Received Date: dd/mm/yyyy</span></th>
                            <td><asp:TextBox ID="DateReceivedTextBox" runat="server" CssClass="date-type" Text='<%# Bind("DateReceived", "{0:dd/MM/yyyy}") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Document Date: dd/mm/yyyy</span></th>
                            <td><asp:TextBox ID="DateDocumentTextBox" runat="server" CssClass="date-type" Text='<%# Bind("DateDocument", "{0:dd/MM/yyyy}") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Originator</span></th>
                            <td><asp:DropDownList ID="DropDown_Originator" runat="server" DataSourceID="SqlDS_Addressee_N_Originator_DropDown" 
                                    DataTextField="CompanyCode" DataValueField="SellerID" AutoPostBack="True" AppendDataBoundItems="true" 
                                    SelectedValue="<%# Bind('Originator') %>" onselectedindexchanged="DropDown_Originator_SelectedIndexChanged">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList><asp:TextBox CssClass="medium-input" ID="TxbOriginator" runat="server" Text="" Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Attention Of</span></th>
                            <td><asp:TextBox ID="AttnOfTextBox" runat="server" Text='<%# Bind("AttnOf") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Addressee</span></th>
                            <td><asp:DropDownList ID="DropDown_Addressee" runat="server" DataSourceID="SqlDS_Addressee_N_Originator_DropDown" 
                                    DataTextField="CompanyCode" DataValueField="SellerID" 
                                    SelectedValue="<%# Bind('Addressee') %>" AppendDataBoundItems="true" 
                                    AutoPostBack="True" 
                                    onselectedindexchanged="DropDown_Addressee_SelectedIndexChanged">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList><asp:TextBox CssClass="medium-input" ID="TxbAddressee" runat="server" Text="" Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Cross. Ref.</span></th>
                            <td><asp:TextBox ID="RefTransmittalTextBox" runat="server" Text='<%# Bind("RefTransmittal") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Doc. Reference</span></th>
                            <td><asp:TextBox CssClass="medium-input" ID="GlobalReferenceTextBox" ToolTip="Global Reference" runat="server" Text='<%# Bind("GlobalReference") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Title/Subject</span></th>
                            <td><asp:TextBox CssClass="long-input" ID="NEWDocumentTitleTextBox" runat="server" Text='<%# Bind("NEWDocumentTitle") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Comments</span></th>
                            <td><asp:TextBox CssClass="long-input" ID="CommentsTextBox" runat="server" Text='<%# Bind("Comments") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Document Type</span></th>
                            <td><asp:DropDownList ID="DropDownList_Type" runat="server" DataSourceID="SqlDS_DCCLookup_DocType" AppendDataBoundItems="true"
                                    DataTextField="fieldtext" DataValueField="fieldvalue" SelectedValue="<%# Bind('Type') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">NTPC Contact</span></th>
                            <td><asp:DropDownList ID="DropDown_Contact" runat="server" DataSourceID="SqlDS_NTPCStaff_DropDown" AppendDataBoundItems="true" 
                                    DataTextField="NP" DataValueField="StaffID" SelectedValue="<%# Bind('Contact') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Contract Reference</span></th>
                            <td><asp:DropDownList ID="DropDown_RefContract" runat="server" DataSourceID="SqlDS_Contract_DropDown" 
                                    DataTextField="OldContractNo" DataValueField="ContractID" AppendDataBoundItems="true"
                                    SelectedValue="<%# Bind('RefContract') %>">
                                     <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Filling Code</span></th>
                            <td><asp:TextBox ID="FillingCodeTextBox" runat="server" Text='<%# Bind("FillingCode") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Distribute To</span></th>
                            <td><asp:TextBox ID="DistributeToTextBox" CssClass="medium-input" runat="server" Text='<%# Bind("DistributeTo") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Delivered To</span></th>
                            <td><asp:DropDownList ID="DropDown_DeliveredTo" runat="server" DataSourceID="SqlDS_NTPCStaff_DropDown" AppendDataBoundItems="true" 
                                    DataTextField="NP" DataValueField="StaffID" SelectedValue="<%# Bind('DeliveredTo') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Link to Doucment</span></th>
                            <td><asp:TextBox CssClass="long-input" ID="LienDocTextBox" runat="server" Text='<%# Bind("LienDoc") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Released Date: dd/mm/yyyy</span></th>
                            <td><asp:TextBox ID="DateReleasedTextBox" runat="server" CssClass="date-type" Text='<%# Bind("DateReleased", "{0:dd/MM/yyyy}") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">SharePoint Doc. ID</span></th>
                            <td><asp:TextBox ID="SharePointDocIDTextBox" runat="server" Text='<%# Bind("SharePointDocID") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Box Reference</span></th>
                            <td><asp:DropDownList ID="DropDown_ArchvBoxRef" runat="server" DataSourceID="SqlDS_ArchiveBoxRef" 
                                    DataTextField="ArchiveBoxReference" DataValueField="DossierID" AppendDataBoundItems="true" SelectedValue="<%# Bind('ArchiveBoxRef') %>" 
                                    onselectedindexchanged="DropDown_ArchvBoxRef_SelectedIndexChanged" AutoPostBack="True">
                                     <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox CssClass="medium-input" ID="txbBoxArchive" runat="server" Text="" Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"><hr /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Updated By</span></th>
                            <td><asp:TextBox CssClass="medium-input" ID="UpdatedByTxb" runat="server" Enabled="false" Text='<%# Bind("UpdatedBy") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Updated At</span></th>
                            <td><asp:TextBox ID="UpdatedAtTxb" runat="server" Enabled="false" Text='<%# Bind("UpdatedAt") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Created By</span></th>
                            <td><asp:TextBox CssClass="medium-input" ID="CreatedByTxb" runat="server" Enabled="false" Text='<%# Bind("CreatedBy") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Created At</span></th>
                            <td><asp:TextBox ID="CreatedAtTxb" runat="server" Enabled="false" Text='<%# Bind("CreatedAt") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Time of Recording</span></th>
                            <td><asp:TextBox ID="TimeOfRecordingADocumentTxb" runat="server" Enabled="false" Text='<%# Bind("TimeOfRecordingADocument") %>' /></td>
                        </tr>
                    </table>
                    <!--End Edit Table-->
                    <br />
                    <br />
                    <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CssClass="button" CommandName="Update" Text="Save" />
                    <asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="button" CommandName="Cancel" Text="Cancel" />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <!--Start Insert Table-->
                    <table id="dcc-edit-doc">
                        <tr>
                            <th><span class="frm-label">In/Out</span></th>
                            <td><asp:DropDownList ID="DropDown_InOutTextBox" runat="server" SelectedValue="<%# Bind('InOut') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                    <asp:ListItem Value="In">IN</asp:ListItem>
                                    <asp:ListItem Value="Out">OUT</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">DCC Log Number</span></th>
                            <td><asp:TextBox ID="DCCLogNoTextBox" runat="server" Text='<%# Bind("DCCLogNo") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">DCC Location</span></th>
                            <td><asp:DropDownList ID="DropDownList_DCCLocation" runat="server" SelectedValue="<%# Bind('DCCLocation') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                    <asp:ListItem Value="VTE">NTPC</asp:ListItem>
                                    <asp:ListItem Value="RNT">NTPR</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Carrier Name</span></th>
                            <td><asp:DropDownList ID="DropDown_Carrier_Name" runat="server" DataSourceID="SqlDS_DCCLookup_CarrierName" AppendDataBoundItems="true" 
                                    DataTextField="fieldtext" DataValueField="fieldvalue" SelectedValue="<%# Bind('CarrieName') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>&nbsp;Ref.&nbsp;<asp:TextBox ID="CarrieRefTextBox" runat="server" Text='<%# Bind("CarrieRef") %>' />
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">DCC Received Date: dd/mm/yyyy</span></th>
                            <td><asp:TextBox ID="DateReceivedTextBox" runat="server" CssClass="date-type" Text='<%# Bind("DateReceived","{0:dd/MM/yyyy}") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Document Date: dd/mm/yyyy</span></th>
                            <td><asp:TextBox ID="DateDocumentTextBox" runat="server" CssClass="date-type" Text='<%# Bind("DateDocument","{0:dd/MM/yyyy}") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Originator</span></th>
                            <td><asp:DropDownList ID="DropDown_Originator" runat="server" DataSourceID="SqlDS_Addressee_N_Originator_DropDown" 
                                    DataTextField="CompanyCode" DataValueField="SellerID" AutoPostBack="True" AppendDataBoundItems="true" 
                                    SelectedValue="<%# Bind('Originator') %>" onselectedindexchanged="DropDown_Originator_SelectedIndexChanged">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList><asp:TextBox CssClass="medium-input" ID="TxbOriginator" runat="server" Text="" Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Attention Of</span></th>
                            <td><asp:TextBox ID="AttnOfTextBox" runat="server" Text='<%# Bind("AttnOf") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Addressee</span></th>
                            <td><asp:DropDownList ID="DropDown_Addressee" runat="server" DataSourceID="SqlDS_Addressee_N_Originator_DropDown" 
                                    DataTextField="CompanyCode" DataValueField="SellerID" 
                                    SelectedValue="<%# Bind('Addressee') %>" AppendDataBoundItems="true" 
                                    AutoPostBack="True" 
                                    onselectedindexchanged="DropDown_Addressee_SelectedIndexChanged">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList><asp:TextBox CssClass="medium-input" ID="TxbAddressee" runat="server" Text="" Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Cross. Ref.</span></th>
                            <td><asp:TextBox ID="RefTransmittalTextBox" runat="server" Text='<%# Bind("RefTransmittal") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Doc. Reference</span></th>
                            <td><asp:TextBox CssClass="medium-input" ID="GlobalReferenceTextBox" ToolTip="Global Reference" runat="server" Text='<%# Bind("GlobalReference") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Title/Subject</span></th>
                            <td><asp:TextBox CssClass="long-input" ID="NEWDocumentTitleTextBox" runat="server" Text='<%# Bind("NEWDocumentTitle") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Comments</span></th>
                            <td><asp:TextBox CssClass="long-input" ID="CommentsTextBox" runat="server" Text='<%# Bind("Comments") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Document Type</span></th>
                            <td><asp:DropDownList ID="DropDownList_Type" runat="server" DataSourceID="SqlDS_DCCLookup_DocType" AppendDataBoundItems="true"
                                    DataTextField="fieldtext" DataValueField="fieldvalue" SelectedValue="<%# Bind('Type') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">NTPC Contact</span></th>
                            <td><asp:DropDownList ID="DropDown_Contact" runat="server" DataSourceID="SqlDS_NTPCStaff_DropDown" AppendDataBoundItems="true" 
                                    DataTextField="NP" DataValueField="StaffID" SelectedValue="<%# Bind('Contact') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Contract Reference</span></th>
                            <td><asp:DropDownList ID="DropDown_RefContract" runat="server" DataSourceID="SqlDS_Contract_DropDown" 
                                    DataTextField="OldContractNo" DataValueField="ContractID" AppendDataBoundItems="true"
                                    SelectedValue="<%# Bind('RefContract') %>">
                                     <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Filling Code</span></th>
                            <td><asp:TextBox ID="FillingCodeTextBox" runat="server" Text='<%# Bind("FillingCode") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Distribute To</span></th>
                            <td><asp:TextBox ID="DistributeToTextBox" CssClass="medium-input" runat="server" Text='<%# Bind("DistributeTo") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Delivered To</span></th>
                            <td><asp:DropDownList ID="DropDown_DeliveredTo" runat="server" DataSourceID="SqlDS_NTPCStaff_DropDown" AppendDataBoundItems="true" 
                                    DataTextField="NP" DataValueField="StaffID" SelectedValue="<%# Bind('DeliveredTo') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Link to Doucment</span></th>
                            <td><asp:TextBox CssClass="long-input" ID="LienDocTextBox" runat="server" Text='<%# Bind("LienDoc") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Released Date: dd/mm/yyyy</span></th>
                            <td><asp:TextBox ID="DateReleasedTextBox" runat="server" CssClass="date-type" Text='<%# Bind("DateReleased","{0:dd/MM/yyyy}") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">SharePoint Doc. ID</span></th>
                            <td><asp:TextBox ID="SharePointDocIDTextBox" runat="server" Text='<%# Bind("SharePointDocID") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Box Reference</span></th>
                            <td><asp:DropDownList ID="DropDown_ArchvBoxRef" runat="server" DataSourceID="SqlDS_ArchiveBoxRef" 
                                    DataTextField="ArchiveBoxReference" DataValueField="DossierID" AppendDataBoundItems="true" SelectedValue="<%# Bind('ArchiveBoxRef') %>" 
                                    onselectedindexchanged="DropDown_ArchvBoxRef_SelectedIndexChanged" AutoPostBack="True">
                                     <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox CssClass="medium-input" ID="txbBoxArchive" runat="server" Text="" Enabled="false" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"><hr /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Updated By</span></th>
                            <td><asp:TextBox CssClass="medium-input" ID="UpdatedByTxb" runat="server" Enabled="false" Text='<%# Bind("UpdatedBy") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Updated At</span></th>
                            <td><asp:TextBox ID="UpdatedAtTxb" runat="server" Enabled="false" Text='<%# Bind("UpdatedAt") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Created By</span></th>
                            <td><asp:TextBox CssClass="medium-input" ID="CreatedByTxb" runat="server" Enabled="false" Text='<%# Bind("CreatedBy") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Created At</span></th>
                            <td><asp:TextBox ID="CreatedAtTxb" runat="server" Enabled="false" Text='<%# Bind("CreatedAt") %>' /></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Time of Recording</span></th>
                            <td><asp:TextBox ID="TimeOfRecordingADocumentTxb" runat="server" Enabled="false" Text='<%# Bind("TimeOfRecordingADocument") %>' /></td>
                        </tr>
                    </table>
                    <!--End Insert Table-->
                    <br />
                    <br />
                    <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CssClass="button" CommandName="Insert" Text="Save" />
                    <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CssClass="button" CommandName="Cancel" Text="Cancel" />
                </InsertItemTemplate>

                <ItemTemplate>
                    <!--Item Table-->
                    <table id="dcc-edit-doc">
                        <tr>
                            <th><span class="frm-label">ID</span></th>
                            <td><span class="frm-dataf"><%# Eval("DocID") %></span></td>
                            <th><span class="frm-label">Contact Person</span></th>
                            <td><span class="frm-dataf frm-data-cmb">
                                <asp:DropDownList ID="DropDown_ContactPerson" runat="server" DataSourceID="SqlDS_NTPCStaff_DropDown" 
                                    DataTextField="NP" DataValueField="StaffID" Enabled="False" AppendDataBoundItems="true" SelectedValue="<%# Bind('Contact') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">In/Out</span></th>
                            <td><span class="frm-dataf"><%# Eval("InOut") %></span></td>
                            <th><span class="frm-label">Document Type</span></th>
                            <td><span class="frm-dataf"><%# Eval("Type") %></span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">DCC Location</span></th>
                            <td><span class="frm-dataf"><%# Eval("DCCLocation") %></span></td>
                            <th><span class="frm-label">Addressee</span></th>
                            <td><span class="frm-dataf frm-data-cmb">
                                <asp:DropDownList ID="DropDown_Addressee" runat="server" DataSourceID="SqlDS_Addressee_N_Originator_DropDown" 
                                    DataTextField="CompanyCode" DataValueField="SellerID" Enabled="False" SelectedValue="<%# Bind('Addressee') %>" AppendDataBoundItems="true">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">DCC Log Number</span></th>
                            <td><span class="frm-dataf"><%# Eval("DCCLogNo")%></span></td>
                            <th><span class="frm-label">Originator</span></th>
                            <td><span class="frm-dataf frm-data-cmb">
                                <asp:DropDownList ID="DropDown_Originator" runat="server" DataSourceID="SqlDS_Addressee_N_Originator_DropDown" 
                                    DataTextField="CompanyCode" DataValueField="SellerID" Enabled="False" AppendDataBoundItems="true"
                                    SelectedValue="<%# Bind('Originator') %>">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Carrier Name</span></th>
                            <td><span class="frm-dataf frm-data-cmb">
                                <asp:DropDownList ID="DropDown_Carrier_Name" runat="server" DataSourceID="SqlDS_DCCLookup_CarrierName" AppendDataBoundItems="true" 
                                    DataTextField="fieldtext" DataValueField="fieldvalue" SelectedValue="<%# Bind('CarrieName') %>" Enabled="false">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </span></td>
                            <th><span class="frm-label">Attention Of</span></th>
                            <td><span class="frm-dataf"><%# Eval("AttnOf")%></span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Carrier Ref</span></th>
                            <td><span class="frm-dataf"><%# Eval("CarrieRef")%></span></td>
                            <th><span class="frm-label">Deliver To</span></th>
                            <td><span class="frm-dataf frm-data-cmb">
                                <asp:DropDownList ID="DropDown_DeliveredTo" runat="server" DataSourceID="SqlDS_NTPCStaff_DropDown" AppendDataBoundItems="true" 
                                    DataTextField="NP" DataValueField="StaffID" SelectedValue="<%# Bind('DeliveredTo') %>" Enabled="false">
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">ArchiveBoxRef</span></th>
                            <td><span class="frm-dataf">
                                <asp:DropDownList ID="DropDown_ArchvBoxRef" runat="server" DataSourceID="SqlDS_ArchiveBoxRef" DataTextField="ArchiveBoxReference"
                                    DataValueField="DossierID" AppendDataBoundItems="true" SelectedValue="<%# Bind('ArchiveBoxRef') %>" Enabled="false">
                                     <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </span></td>
                            <th><span class="frm-label">Distribute To</span></th>
                            <td><span class="frm-dataf"><%# Eval("DistributeTo")%></span></td>
                        </tr>
                        <tr><td colspan="4"><hr /></td></tr>
                        <tr>
                            <th><span class="frm-label">Subject / Title</span></th>
                            <td colspan="3"><span class="frm-dataf"><%# Eval("NEWDocumentTitle")%></span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Document Link</span></th>
                            <td colspan="3"><span class="frm-dataf"><%# Eval("LienDoc")%></span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Document Comments</span></th>
                            <td colspan="3"><span class="frm-dataf"><%# Eval("Comments")%></span></td>
                        </tr>
                        <tr><td colspan="4"><hr /></td></tr>
                        <tr>
                            <th><span class="frm-label">Document Date</span></th>
                            <td><asp:Label id="DateDocumentLabel" CssClass="frm-dataf" runat="server" ToolTip="dd/mm/yyyy" Text='<%# Eval("DateDocument","{0:dd/MM/yyyy}") %>'></asp:Label></td>
                            <th><span class="frm-label">DCC Received Date</span></th>
                            <td><asp:Label CssClass="frm-dataf" id="DateReceivedLabel" runat="server" ToolTip="dd/mm/yyyy" Text='<%# Eval("DateReceived","{0:dd/MM/yyyy}") %>'></asp:Label></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Released Date</span></th>
                            <td><asp:Label id="dateReleaseLabel" CssClass="frm-dataf" runat="server" ToolTip="dd/mm/yyyy" Text='<%# Eval("DateReleased","{0:dd/MM/yyyy}") %>'></asp:Label></td>
                            <th><span class="frm-label">Time Of Recording</span></th>
                            <td><asp:Label id="TimeOfRecordingADocumentLabel" CssClass="frm-dataf" runat="server" Text='<%# Eval("TimeOfRecordingADocument","{0:dd/MM/yyyy}") %>'></asp:Label></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">SharePoint Doc. ID</span></th>
                            <td><span class="frm-dataf"><%# Eval("SharePointDocID")%></span></td>
                            <th><span class="frm-label">Doc. Reference</span></th>
                            <td><span class="frm-dataf" title="Global Reference"><%# Eval("GlobalReference")%></span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Contract Reference</span></th>
                            <td><span class="frm-dataf">
                                <asp:DropDownList ID="DropDown_RefContract" runat="server" DataSourceID="SqlDS_Contract_DropDown" 
                                    DataTextField="OldContractNo" DataValueField="ContractID" Enabled="False" AppendDataBoundItems="true"
                                    SelectedValue="<%# Bind('RefContract') %>">
                                     <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </span></td>
                            <th><span class="frm-label">Filling Code</span></th>
                            <td><span class="frm-dataf"><%# Eval("FillingCode")%></span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Create At</span></th>
                            <td><asp:Label id="CreatedAtLabel" CssClass="frm-dataf" runat="server" Text='<%# Eval("CreatedAt") %>'></asp:Label></td>
                            <th><span class="frm-label">Create By</span></th>
                            <td><span class="frm-dataf"><%# Eval("CreatedBy")%></span></td>
                        </tr>
                        <tr>
                            <th><span class="frm-label">Update At</span></th>
                            <td><asp:Label id="UpdatedAtLabel" CssClass="frm-dataf" runat="server" Text='<%# Eval("UpdatedAt") %>'></asp:Label></td>
                            <th><span class="frm-label">Update By</span></th>
                            <td><span class="frm-dataf"><%# Eval("UpdatedBy")%></span></td>
                        </tr>
                        <tr><td colspan="4">&nbsp;</td></tr>
                    </table>
                    <!--End Item Table-->

                    <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" CssClass="button" />
                    <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False"  CommandName="Delete" Text="Delete" CssClass="button" 
                        OnClientClick="return confirm('Are you sure you want to delete this item?');" />
                    <asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" CommandName="New" Text="New" CssClass="button" />
                </ItemTemplate>
            </asp:FormView>

            </div>
            <!-- End form view -->
            
            <asp:SqlDataSource ID="SqlDS_DCCLookup_CarrierName" runat="server" 
                ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
                SelectCommand="SELECT [fieldtext], [fieldvalue] FROM [tblDCCLookup] WHERE ([parent] = 1)">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDS_ArchiveBoxRef" runat="server"
                ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>"
                SelectCommand="SELECT tblDossier.DossierID, tblArchive.ArchiveBoxReference, tblDossier.DossierReference, tblArchive.ArchiveBoxWhere, tblArchive.ArchiveBoxBuilding, tblArchive.ArchiveBoxRoom, tblArchive.ArchiveBoxCupboard, tblArchive.ArchiveBoxShelf FROM tblArchive INNER JOIN tblDossier ON tblArchive.ArchiveBoxID = tblDossier.ArchiveBoxID ORDER BY tblArchive.ArchiveBoxReference">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDS_DCCLookup_DocType" runat="server" 
                ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
                SelectCommand="SELECT [fieldtext], [fieldvalue] FROM [tblDCCLookup] WHERE ([parent] = 12)">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDS_NTPCStaff_DropDown" runat="server" 
                ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
                SelectCommand="SELECT StaffID, NP FROM tblNTPCStaff WHERE StaffID<>691;">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDS_Contract_DropDown" runat="server" 
                ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
                SelectCommand="SELECT tblContracts.ContractID, tblContracts.OldContractNo, tblContracts.Description, tblSeller.CompanyName, tblSeller.CompanyCode FROM tblSeller INNER JOIN tblContracts ON tblSeller.SellerID=tblContracts.PartyID ORDER BY tblContracts.OldContractNo;">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDS_Addressee_N_Originator_DropDown" runat="server" 
                ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
                SelectCommand="SELECT SellerID, CompanyCode, CompanyName FROM tblSeller ORDER BY CompanyCode;">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDS_Form_DCCMain" runat="server"
                ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
                DeleteCommand="DELETE FROM [tblDCCMain] WHERE [DocID] = @DocID" 
                InsertCommand="INSERT INTO [tblDCCMain] ([RefContract], [Originator], [Addressee], [Type], [LienDoc], [DCCLogNo], [DateReceived], [DateDocument], [Comments], [DCCLocation], [GlobalReference], [Contact], [DateReleased], [TimeOfRecordingADocument], [UpdatedBy], [UpdatedAt], [CreatedBy], [CreatedAt], [SharePointDocID], [RefTransmittal], [NEWDocumentTitle], [InOut], [CarrieName], [CarrieRef], [AttnOf], [ArchiveBoxRef], [DeliveredTo], [DistributeTo], [FillingCode]) VALUES (@RefContract, @Originator, @Addressee, @Type, @LienDoc, @DCCLogNo, @DateReceived, @DateDocument, @Comments, @DCCLocation, @GlobalReference, @Contact, @DateReleased, @TimeOfRecordingADocument, @UpdatedBy, @UpdatedAt, @CreatedBy, @CreatedAt, @SharePointDocID, @RefTransmittal, @NEWDocumentTitle, @InOut, @CarrieName, @CarrieRef, @AttnOf, @ArchiveBoxRef, @DeliveredTo, @DistributeTo, @FillingCode)" 
                SelectCommand="SELECT * FROM [tblDCCMain] WHERE [DocID] = @DocID"
                UpdateCommand="UPDATE [tblDCCMain] SET [RefContract] = @RefContract, [Originator] = @Originator, [Addressee] = @Addressee, [Type] = @Type, [LienDoc] = @LienDoc, [DCCLogNo] = @DCCLogNo, [DateReceived] = @DateReceived, [DateDocument] = @DateDocument, [Comments] = @Comments, [DCCLocation] = @DCCLocation, [GlobalReference] = @GlobalReference, [Contact] = @Contact, [DateReleased] = @DateReleased, [UpdatedBy] = @UpdatedBy, [UpdatedAt] = @UpdatedAt, [CreatedBy] = @CreatedBy, [CreatedAt] = @CreatedAt, [SharePointDocID] = @SharePointDocID, [RefTransmittal]=@RefTransmittal, [NEWDocumentTitle] = @NEWDocumentTitle, [InOut] = @InOut, [CarrieName] = @CarrieName, [CarrieRef] = @CarrieRef, [AttnOf] = @AttnOf, [ArchiveBoxRef] = @ArchiveBoxRef, [DeliveredTo] = @DeliveredTo, [DistributeTo] = @DistributeTo, [FillingCode] = @FillingCode WHERE [DocID] = @DocID">
                <DeleteParameters>
                    <asp:Parameter Name="DocID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="RefContract" Type="Int32" />
                    <asp:Parameter Name="Originator" Type="Int32" />
                    <asp:Parameter Name="Addressee" Type="Int32" />
                    <asp:Parameter Name="Type" Type="String" />
                    <asp:Parameter Name="LienDoc" Type="String" />
                    <asp:Parameter Name="DCCLogNo" Type="String" />
                    <asp:Parameter Name="DateReceived" Type="DateTime" />
                    <asp:Parameter Name="DateDocument" Type="DateTime" />
                    <asp:Parameter Name="Comments" Type="String" />
                    <asp:Parameter Name="DCCLocation" Type="String" />
                    <asp:Parameter Name="GlobalReference" Type="String" />
                    <asp:Parameter Name="Contact" Type="Int32" />
                    <asp:Parameter Name="DateReleased" Type="DateTime" />
                    <asp:Parameter Name="TimeOfRecordingADocument" Type="DateTime" />
                    <asp:Parameter Name="UpdatedBy" Type="String" />
                    <asp:Parameter Name="UpdatedAt" Type="DateTime" />
                    <asp:Parameter Name="CreatedBy" Type="String" />
                    <asp:Parameter Name="CreatedAt" Type="DateTime" />
                    <asp:Parameter Name="SharePointDocID" Type="String" />
                    <asp:Parameter Name="RefTransmittal" Type="String" />
                    <asp:Parameter Name="NEWDocumentTitle" Type="String" />
                    <asp:Parameter Name="InOut" Type="String" />
                    <asp:Parameter Name="CarrieName" Type="String" />
                    <asp:Parameter Name="CarrieRef" Type="String" />
                    <asp:Parameter Name="AttnOf" Type="String" />
                    <asp:Parameter Name="ArchiveBoxRef" Type="Int32" />
                    <asp:Parameter Name="DeliveredTo" Type="Int32" />
                    <asp:Parameter Name="DistributeTo" Type="String" />
                    <asp:Parameter Name="FillingCode" Type="String" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="gridview_main" Name="DocID" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="RefContract" Type="Int32" />
                    <asp:Parameter Name="Originator" Type="Int32" />
                    <asp:Parameter Name="Addressee" Type="Int32" />
                    <asp:Parameter Name="Type" Type="String" />
                    <asp:Parameter Name="LienDoc" Type="String" />
                    <asp:Parameter Name="DCCLogNo" Type="String" />
                    <asp:Parameter Name="DateReceived" Type="DateTime" />
                    <asp:Parameter Name="DateDocument" Type="DateTime" />
                    <asp:Parameter Name="Comments" Type="String" />
                    <asp:Parameter Name="DCCLocation" Type="String" />
                    <asp:Parameter Name="GlobalReference" Type="String" />
                    <asp:Parameter Name="Contact" Type="Int32" />
                    <asp:Parameter Name="DateReleased" Type="DateTime" />
                    <asp:Parameter Name="TimeOfRecordingADocument" Type="DateTime" />
                    <asp:Parameter Name="UpdatedBy" Type="String" />
                    <asp:Parameter Name="UpdatedAt" Type="DateTime" />
                    <asp:Parameter Name="CreatedBy" Type="String" />
                    <asp:Parameter Name="CreatedAt" Type="DateTime" />
                    <asp:Parameter Name="SharePointDocID" Type="String" />
                    <asp:Parameter Name="RefTransmittal" Type="String" />
                    <asp:Parameter Name="NEWDocumentTitle" Type="String" />
                    <asp:Parameter Name="InOut" Type="String" />
                    <asp:Parameter Name="CarrieName" Type="String" />
                    <asp:Parameter Name="CarrieRef" Type="String" />
                    <asp:Parameter Name="AttnOf" Type="String" />
                    <asp:Parameter Name="DeliverTo" Type="String" />
                    <asp:Parameter Name="ArchiveBoxRef" Type="Int32" />
                    <asp:Parameter Name="DeliveredTo" Type="Int32" />
                    <asp:Parameter Name="DistributeTo" Type="String" />
                    <asp:Parameter Name="FillingCode" Type="String" />
                    <asp:Parameter Name="DocID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </asp:View>

        <asp:View ID="view1"  runat="server">
        </asp:View>
        <asp:View ID="view2"  runat="server">
        </asp:View>
    </asp:MultiView>

    </div>

    <!-- for popup form -->
    <div id="tabs-3">
        
        <div id="DccFormDialog" title="Linked Documents">
            <!-- content from Default.aspx -->
        </div>

    </div>
    <!-- end popup form -->

    </div> <!-- End tab settings -->  

    <script type="text/javascript">
        $(document).ready(function () {
            $('input.button, a.button').button();
            $('#settings').tabs({
                select: function (event, ui) {
                    $("#<%= hfSelectedTAB.ClientID %>").val(ui.index);
                    SetTabWidth($("#<%= hfSelectedTAB.ClientID %>").val());
                }
            });
            $("#settings").tabs("option", "selected", [$("#<%= hfSelectedTAB.ClientID %>").val()]);
            SetTabWidth($("#<%= hfSelectedTAB.ClientID %>").val());

            $("#resizable").resizable();
            $(".date-type").datepicker({ dateFormat: 'dd/mm/yy' });
            $(".titles").tooltip();
        });
        
        // set width function
        function SetTabWidth(tabCurr) {
            var screen = $(window).width();
            if (tabCurr == "0") {
                $("#settings").css("min-width", "1300px");
                $("#header-table").css("min-width", (screen < 1510) ? "1510px" : "100%");
                $("#TopNav").css("min-width", (screen < 1510) ? "1510px" : "100%");
            } else if (tabCurr == "1") {
                $("#settings").css("min-width", $(window).width() - 205);
                $("#header-table").css("min-width", "600px");
                $("#TopNav").css("min-width", $(window).width());
            }
        }
        //related doc
        function OpenDialogBox(obj) {
            var url = "dcc/Default.aspx?docid=" + $(obj).text();
            $("#DccFormDialog").load();
            $("#DccFormDialog") .load(url).dialog({
                height: 400,
                width: 600,
                modal: true,
                buttons: {
                    'Add new linked doucment': function () {
                        //do something
                        $(this).dialog('close');
                        window.location = url + "&action=add";
                    },
                    'Cancel': function () {
                        $(this).dialog('close');
                    }
                }
            });
            return false;
        }
        
    </script>

<asp:HiddenField ID="hfSelectedTAB" runat="server"  Value="0" />
<asp:HiddenField ID="hfTagbleButton" runat="server"  Value="0" />
</asp:Content>

