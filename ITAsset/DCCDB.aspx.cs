using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using ITAsset;

public partial class DCCDB : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    // Start Filtering Panel Events
    private void SetSearchSQL(string fieldName, string filterValue)
    {
        AssetUtility Util = new AssetUtility();
        string sql = String.Format("SELECT * FROM [dbo].[vw_DCC_DocDB_ALL] WHERE [{0}] ", fieldName);
        if (filterValue == "")
        {
            sql = "SELECT * FROM [dbo].[vw_DCC_DocDB_ALL] WHERE 1<>1";
        }
        else
        {
            switch (fieldName)
            {
                case "DocID":
                    sql += "=" + Util.CleanInput(filterValue) + ";";
                    break;
                case "DCCLogNo":
                    sql += "LIKE '" + Util.CleanInput(filterValue) + "%'";
                    break;
                default:
                    sql += "LIKE '%" + Util.CleanInput(filterValue) + "%'";
                    break;
            }
            SqlDS_Gridview_Main.SelectCommand = sql;
            gridview_main.AllowPaging = false;
            SqlDS_Gridview_Main.DataBind();
        }
    }

    // button events
    protected void btnSearch1_Click(object sender, EventArgs e)
    {
        SetSearchSQL("DocID",txbDocID.Text);
    }
    protected void btnSearch2_Click(object sender, EventArgs e)
    {
        SetSearchSQL("OldContractNo", txbContract.Text);
    }
    protected void btnSearch3_Click(object sender, EventArgs e)
    {
        SetSearchSQL("GlobalReference", txbGlobalRef.Text);
    }
    protected void btnSearch4_Click(object sender, EventArgs e)
    {
        SetSearchSQL("DCCLogNo", txbDCCLogNo.Text);
    }
    protected void btnSearch5_Click(object sender, EventArgs e)
    {
        SetSearchSQL("NEWDocumentTitle", txbDocKeyword.Text);
    }
    protected void btnArchivBox_Click(object sender, EventArgs e)
    {
        SetSearchSQL("ArchiveBoxReference", txbArchiveBoxReference.Text);
    }
    protected void btnOriginator_Click(object sender, EventArgs e)
    {
        SetSearchSQL("OriginatorCode", txbOriginator.Text);
    }
    
    // End Filtering Panel Events

    protected void LinkBtn_add_Click(object sender, EventArgs e)
    {
        FormView1.ChangeMode(FormViewMode.Insert);
        hfSelectedTAB.Value = "1";
        Multiview2.ActiveViewIndex = 0;
    }
    protected void gridview_main_SelectedIndexChanged(object sender, EventArgs e)
    {
        FormView1.ChangeMode(FormViewMode.ReadOnly);
        hfSelectedTAB.Value = "1";
        Multiview2.ActiveViewIndex = 0;
    }
    protected void LinkBtn_mod_Click(object sender, EventArgs e)
    {
        hfSelectedTAB.Value = "0";
        Multiview1.ActiveViewIndex = 0;
    }

    private void SetDefaultValue(FormView frmView)
    {
        if (frmView.CurrentMode == FormViewMode.Edit || frmView.CurrentMode == FormViewMode.Insert)
        {
            AssetUtility Util = new AssetUtility();
            string currDate = DateTime.Now.ToString();

            TextBox UpdatedByTxb = frmView.FindControl("UpdatedByTxb") as TextBox;
            TextBox UpdatedAtTxb = frmView.FindControl("UpdatedAtTxb") as TextBox;
            TextBox TimeOfRecordingADocumentTxb = frmView.FindControl("TimeOfRecordingADocumentTxb") as TextBox;
            
            UpdatedByTxb.Text = Util.GetUserFullLogin().ToString();
            UpdatedAtTxb.Text = currDate;
            if (frmView.CurrentMode == FormViewMode.Insert) {
                TextBox CreatedByTxb = frmView.FindControl("CreatedByTxb") as TextBox;
                TextBox CreatedAtTxb = frmView.FindControl("CreatedAtTxb") as TextBox;
                CreatedByTxb.Text = Util.GetUserFullLogin().ToString();
                CreatedAtTxb.Text = currDate;
                TimeOfRecordingADocumentTxb.Text = currDate;
            }
        }
    }

    protected void FormView1_DataBound(object sender, EventArgs e)
    {
        SetDefaultValue(FormView1);
    }

    //function idealy to return single value/column from sql statement
    private string GetSingleValue(string sql)
    {
        string val = "";

        System.Data.SqlClient.SqlConnection Conn = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["DccDBConnectionString"].ToString());
        Conn.Open();
        SqlCommand myCmd = new SqlCommand(sql, Conn);
        SqlDataReader reader = myCmd.ExecuteReader();
        
        while (reader.Read())
        {
            val = reader[0].ToString();
        }
        Conn.Close();
        return val;
    }
    protected void DropDown_ArchvBoxRef_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        TextBox txbArchive = (TextBox)FormView1.FindControl("txbBoxArchive");
        string sql = String.Format("SELECT DossierReference FROM tblDossier WHERE DossierID = {0}", ddl.SelectedValue);
        txbArchive.Text = GetSingleValue(sql);
    }
    protected void DropDown_Originator_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        TextBox TxbOriginator = (TextBox)FormView1.FindControl("TxbOriginator");
        string sql = String.Format("SELECT CompanyName FROM tblSeller WHERE SellerID = {0};", ddl.SelectedValue);
        TxbOriginator.Text = GetSingleValue(sql);
    }
    protected void DropDown_Addressee_SelectedIndexChanged(object sender, EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        TextBox TxbAddressee = (TextBox)FormView1.FindControl("TxbAddressee");
        string sql = String.Format("SELECT CompanyName FROM tblSeller WHERE SellerID = {0};", ddl.SelectedValue);
        TxbAddressee.Text = GetSingleValue(sql);
    }
    protected void FormView1_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        SqlDS_Gridview_Main.DataBind();
        hfSelectedTAB.Value = "0";
        Multiview1.ActiveViewIndex = 0;
    }
    protected void FormView1_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        SqlDS_Gridview_Main.DataBind();
        hfSelectedTAB.Value = "0";
        Multiview1.ActiveViewIndex = 0;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("DccFilter.aspx?year="+ DocYear.SelectedValue);
    }
}