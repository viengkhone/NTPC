<%@ Page Language="C#" %>

<!DOCTYPE html />

<script runat="server">
    protected void id_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count > 0)
        {
            id.Text = (Request.QueryString["docid"] == null) ? "null" : Request.QueryString["docid"];
            if (Request.QueryString["action"] == "add")
            {
                MulitView_LinkedDoc.ActiveViewIndex = 1;
            }
        }
    }

    protected void frmUpdateLinkedDoc_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        GridView_RelateDoc.DataBind();
    }

    void Page_Error(Object sender, EventArgs args)
    {
        Exception e = Server.GetLastError();
        Trace.Write("Message", e.Message);
        Trace.Write("Source", e.Source);
        Trace.Write("Stack Trace", e.StackTrace);
        Response.Write(String.Format("Un-handled Error:<br /><br />\n\n Reason: {0}<br /><br />\n Source: {1}<br /><br />\n Trace for Developer: <br />{2}<br />\n", e.Message, e.Source, e.StackTrace));
        Context.ClearError();
    }
</script>

<html>
<head>
    <title>View Relate Doc</title>
    <script src="../design/jQueryUI/js/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="../design/jQueryUI/js/jquery-ui-1.9.1.custom.min.js" type="text/javascript"></script>
    <link href="../design/jQueryUI/css/le-frog/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../design/StyleSheet.css" />
</head>
<body>
<form runat="server" id="form1">
<asp:Label ID="id" runat="server" onload="id_Load" Visible="false"></asp:Label><br />
<asp:GridView runat="server" id="GridView_RelateDoc" AutoGenerateColumns="False" DataKeyNames="DocID" DataSourceID="SqlDs_Doc_View">
    <Columns>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton ID="RemoveButton" runat="server" CssClass="button" CausesValidation="False" CommandName="Delete" Text="Remove" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:HyperLinkField DataTextField="DocID" HeaderText="ID" SortExpression="DocID" DataNavigateUrlFields="LienDoc" DataNavigateUrlFormatString="{0}" Target="_blank">
                <ItemStyle CssClass="gridview-link" VerticalAlign="Middle" HorizontalAlign="Center" />
        </asp:HyperLinkField>
        <asp:BoundField DataField="DCCLogNo" HeaderText="LogNo" SortExpression="DCCLogNo" ItemStyle-HorizontalAlign="Center" />
        <asp:BoundField DataField="NEWDocumentTitle" HeaderText="Subject/Title" SortExpression="NEWDocumentTitle" />
    </Columns>
    <EmptyDataTemplate>
        No Linked Document
    </EmptyDataTemplate>
</asp:GridView>
<asp:sqldatasource ID="SqlDs_Doc_View" runat="server" 
    ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
    SelectCommand="SELECT [DocID], [DCCLogNo], [NEWDocumentTitle], [LienDoc] FROM [tblDCCMain] WHERE ([ParentDocID] = @DocID)"
    DeleteCommand="UPDATE [tblDCCMain] SET [ParentDocID]=NULL WHERE ([DocID] = @DocID)">
    <SelectParameters>
        <asp:ControlParameter ControlID="id" Name="DocID" PropertyName="Text" Type="Int32" />
    </SelectParameters>
</asp:sqldatasource>
<asp:sqldatasource ID="SqlDs_Doc_Update" runat="server" 
    ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
    SelectCommand="SELECT [DocID], [DCCLogNo], [NEWDocumentTitle], [ParentDocID] FROM [tblDCCMain] WHERE ([DocID] = @DocID)"
    InsertCommand="UPDATE [tblDCCMain] SET [ParentDocID]=@DocID WHERE ([DocID] = @MyLinkedID)">
    <SelectParameters>
        <asp:ControlParameter ControlID="id" Name="DocID" PropertyName="Text" Type="Int32" />
    </SelectParameters>
    <InsertParameters>
        <asp:ControlParameter ControlID="id" Name="DocID" PropertyName="Text" Type="Int32" />
        <asp:Parameter Name="MyLinkedID" Type="Int32" />
    </InsertParameters>
</asp:sqldatasource>

<!-- only available when : action=add -->
<asp:MultiView runat="server" ID="MulitView_LinkedDoc" ActiveViewIndex="0">
<asp:View runat="server" ID="View0">
</asp:View>
<asp:View runat="server" ID="View1">
    <asp:FormView runat="server" ID="frmUpdateLinkedDoc" 
        DataSourceID="SqlDs_Doc_Update" DataKeyNames="DocID" DefaultMode="ReadOnly" 
        oniteminserted="frmUpdateLinkedDoc_ItemInserted">
        <InsertItemTemplate>
            Enter a doucment ID to Link: <asp:TextBox ID="MyLinkedID" runat="server" Text='<%# Bind("MyLinkedID") %>'></asp:TextBox>
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CssClass="button"  CommandName="Insert" Text="Save" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CssClass="button" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>
        <ItemTemplate>
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CssClass="button" CausesValidation="False" CommandName="New" Text="Add More" />
            <a class="button" href="../DccDB.aspx" id="GoToDccMain">Go Back</a>
        </ItemTemplate>
    </asp:FormView>
    <asp:sqldatasource ID="SqlDs_DocID_DDL" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DccDBConnectionString %>" 
        SelectCommand="SELECT [DocID] FROM [tblDCCMain]">
    </asp:sqldatasource>
    <script type="text/javascript">
        $(document).ready(function () {
            $('input.button, a.button').button();
        })
    </script>
</asp:View>
</asp:MultiView>

</form>
</body>
</html>
