<%@ Page Title="DCC Document Filter" Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="System.Collections.ObjectModel" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!X.IsAjaxRequest)
        {
            this.Store1.DataSource = this.Data;
            this.Store1.DataBind();
            linkBtn.Text = Request.QueryString["year"] == "0" ? "No Year" : Request.QueryString["year"];
        }
    }
    protected void MyData_Refresh(object sender, StoreReadDataEventArgs e)
    {
        this.BindData();
    }

    private void BindData()
    {
        Store store = this.GridPanel1.GetStore();

        store.DataSource = this.Data;
        store.DataBind();
    }
    
    private object Data
    {
        get
        {
            ITAsset.AssetUtility Util = new ITAsset.AssetUtility();
            System.Collections.ArrayList r = null;
            try
            {
                int YearValue = Convert.ToInt32(Request.QueryString["year"]);
                if (Request.QueryString["year"]==null)
                {
                    r = new ArrayList();
                    r.Add(new object[] { "1", "4", "2", "Please select year from \"DCC Database >> Filter Panel\" ", "Error Request", "01/01/2013", "7", "8", "9", "10", "11", "12", "13", "14", "Column 15", "3" });
                }
                else if (YearValue > 0)
                {
                    r = Util.GetDccData(String.Format("SELECT DocID, DCCLogNo, DCCLocation, NEWDocumentTitle, GlobalReference, CONVERT(VARCHAR(10), DateDocument, 103) AS DateDocument, CompanyCode, OriginatorCode, AttnOf, OldContractNo, fillingcode, DistributeTo, DeliverToPsn, SharePointDocID, LienDoc, InOut FROM [vw_DCC_DocDB_ALL] WHERE YEAR(DateDocument)={0} ORDER BY DocID DESC", YearValue));
                }
                else if (YearValue == 0)
                {
                    r = Util.GetDccData("SELECT DocID, DCCLogNo, DCCLocation, NEWDocumentTitle, GlobalReference, CONVERT(VARCHAR(10), DateDocument, 103) AS DateDocument, CompanyCode, OriginatorCode, AttnOf, OldContractNo, fillingcode, DistributeTo, DeliverToPsn, SharePointDocID, LienDoc, InOut FROM [vw_DCC_DocDB_ALL] WHERE DateDocument IS NULL ORDER BY DocID DESC");
                }
            }
            catch (Exception ex)
            {
                r = new ArrayList();
                r.Add(new object[] { "1", "4", "2", ex.Message.ToString(),"Error Request", "01/01/2013", "7", "8", "9", "10", "11", "12", "13", "14", "Column 15", "3" });
            }

            return r.ToArray();
        }
    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="design/jQueryUI/css/le-frog/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
           
        var template = '<span style="color:{0};">{1}</span>';

        var OpenLink = function (command, url) {
            Ext.Msg.alert('Link to Document', url.toString());
        };

        
        var prepare = function (grid, toolbar, rowIndex, record) {
            var firstButton = toolbar.items.get(0);
            if (record.data.LienDoc.length < 2) {
                firstButton.setDisabled(true);
                firstButton.setTooltip("No link");
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<!--line shows location where users are in-->
    <div class="website-current-location">
        Home >> DCC Database >> DCC Filtering >> Year :: <asp:LinkButton runat="server" ID="linkBtn" Text="NULL" PostBackUrl="DccDB.aspx" />
    </div>

    <div style="background-color:White; margin: 4px;border:1px solid #005500;">
        <ext:ResourceManager ID="ResourceManager1" runat="server" DirectEventUrl="DccFilter.aspx" /> 

        <ext:Store runat="server" ID="Store1" PageSize="20" OnReadData="MyData_Refresh">
        <Model>
            <ext:Model ID="Model1" runat="server" IDProperty="Id">
                <Fields>
                    <ext:ModelField Name="Id" Type="Int" />
                    <ext:ModelField Name="LogNo" Type="String" />
                    <ext:ModelField Name="DccLoc" Type="String" />
                    <ext:ModelField Name="Title" Type="String" />
                    <ext:ModelField Name="DocGrobalRef" Type="String" />
                    <ext:ModelField Name="DocDate" Type="Date" DateFormat="dd/MM/yyyy" />
                    <ext:ModelField Name="Addressee" Type="String" />
                    <ext:ModelField Name="Originator" Type="String" />
                    <ext:ModelField Name="AttnOf" Type="String" />
                    <ext:ModelField Name="Contract" Type="String" />
                    <ext:ModelField Name="FillingCode" Type="String" />
                    <ext:ModelField Name="DistributeTo" Type="String" />
                    <ext:ModelField Name="DeliverTo" Type="String" />
                    <ext:ModelField Name="SharePointDocId" Type="String" />
                    <ext:ModelField Name="LienDoc" Type="String" />
                    <ext:ModelField Name="InOut" Type="String" />
                </Fields>
            </ext:Model>
        </Model>
        <Sorters>
            <ext:DataSorter Property="Id" Direction="DESC" />
        </Sorters>        
        </ext:Store>
    
        <ext:GridPanel ID="GridPanel1" runat="server" Border="false" StoreID="Store1" Layout="FitLayout">
            <ColumnModel ID="ColumnModel1" runat="server">
                <Columns>
                    <ext:Column ID="Column1" runat="server" Text="ID" DataIndex="Id" Width="60" />
                    <ext:Column ID="Column2" runat="server" Text="DCC" DataIndex="DccLoc" Width="36" />
                    <ext:Column ID="Column15" runat="server" Text="InOut" DataIndex="InOut" Width="36" />
                    <ext:Column ID="Column3" runat="server" Text="LogNo" DataIndex="LogNo" Width="46" />
                    <ext:DateColumn ID="DateColumn1" runat="server" Text="Doc. Date" DataIndex="DocDate" Align="Center" Format="dd/MM/yyyy" Width="70" />
                    <ext:Column ID="Column4" runat="server" Text="Subject / Title" DataIndex="Title" MinWidth="340" />
                    <ext:Column ID="Column5" runat="server" Text="Doc. Ref." DataIndex="DocGrobalRef" Align="Center" Width="120" />
                    <ext:Column ID="Column6" runat="server" Text="Addr." DataIndex="Addressee" Width="40" />
                    <ext:Column ID="Column7" runat="server" Text="Orig." DataIndex="Originator" Width="40" />
                    <ext:Column ID="Column8" runat="server" Text="Attention Of" DataIndex="AttnOf" MinWidth="100" />
                    <ext:Column ID="Column9" runat="server" Text="Contract" DataIndex="Contract" Width="54" />
                    <ext:Column ID="Column10" runat="server" Text="FillingC" DataIndex="FillingCode" Width="50" />
                    <ext:Column ID="Column11" runat="server" Text="Distribute To" DataIndex="DistributeTo" MinWidth="100" />
                    <ext:Column ID="Column12" runat="server" Text="Deliver To" DataIndex="DeliverTo"  MinWidth="120" />
                    <ext:Column ID="Column13" runat="server" Text="SharePoint ID" DataIndex="SharePointDocId" />
                    <ext:Column ID="Column14" runat="server" Text="Links" DataIndex="LienDoc" Hidden="true" />
                    <ext:CommandColumn ID="CommandColumn1" Text="Link" runat="server" Align="Center" Width="28">
                        <Commands>
                            <ext:GridCommand Icon="WorldLink" CommandName="Get" Text="" ToolTip-Text="Get Link" />
                        </Commands>
                        <PrepareToolbar Fn="prepare" />
                        <Listeners>
                            <Command Handler="OpenLink(command, record.data.LienDoc);" />
                        </Listeners>
                    </ext:CommandColumn> 
                </Columns>
            </ColumnModel>
            <SelectionModel>
               <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Multi" />
            </SelectionModel>
            <Features>
                <ext:GridFilters runat="server" ID="GridFilters1" Local="true">
                    <Filters>
                        <ext:NumericFilter DataIndex="Id" />
                        <ext:ListFilter DataIndex="DccLoc" Options="VTE,RNT," />
                        <ext:ListFilter DataIndex="InOut" Options="In,Out," />
                        <ext:NumericFilter DataIndex="LogNo" />
                        <ext:DateFilter DataIndex="DocDate">
                            <DatePickerOptions runat="server" TodayText="Now" />
                        </ext:DateFilter>
                        <ext:StringFilter DataIndex="Title" />
                        <ext:StringFilter DataIndex="DocGrobalRef" />
                        <ext:StringFilter DataIndex="Addressee" />
                        <ext:StringFilter DataIndex="Originator" />
                        <ext:StringFilter DataIndex="AttnOf" />
                        <ext:StringFilter DataIndex="Contract" />
                        <ext:StringFilter DataIndex="FillingCode" />
                        <ext:StringFilter DataIndex="DistributeTo" />
                        <ext:StringFilter DataIndex="DeliverTo" />
                        <ext:StringFilter DataIndex="SharePointDocId" />
                        <ext:StringFilter DataIndex="LienDoc" />
                    </Filters>
                </ext:GridFilters>
            </Features>
            <BottomBar>
                <ext:PagingToolbar ID="PagingToolbar1" runat="server" HideRefresh="True">
                    <Items>
                        <ext:ComboBox ID="ComboBox1" runat="server" Width="60">
                            <Items>
                                <ext:ListItem Text="5" />
                                <ext:ListItem Text="10" />
                                <ext:ListItem Text="20" />
                                <ext:ListItem Text="30" />
                                <ext:ListItem Text="50" />
                            </Items>
                            <SelectedItems>
                                <ext:ListItem Value="20" />
                            </SelectedItems>
                            <Listeners>
                                <Select Handler="#{GridPanel1}.store.pageSize = parseInt(this.getValue(), 10); #{GridPanel1}.store.reload();" />
                            </Listeners>
                        </ext:ComboBox>
                        <ext:Button ID="Button3" runat="server" Text="Clear Filters" Handler="this.up('grid').filters.clearFilters();" />
                    </Items>
                    <Plugins>
                        <ext:ProgressBarPager ID="ProgressBarPager1" runat="server" />
                    </Plugins>
                </ext:PagingToolbar>
            </BottomBar>                   
        </ext:GridPanel>

    </div>
</asp:Content>

