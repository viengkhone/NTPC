using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ITAsset;

public partial class History : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        /* Hisoty.aspx is currently made public
         * --------------------------------------------
        if (Session["LoginID"] == null)
        {
            Response.Redirect("Default.aspx?error=1");
        }
        */
        doDataBind();
    }

    protected void isAdmin()
    {
        Label usrStr = this.Master.FindControl("lblUser") as Label;
        int anAdmin = usrStr.Text.IndexOf("[Admin]");
        if (anAdmin == -1)
        {
            GridView1.Enabled = false;
            GridView2.Enabled = false;
        }
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        GridView1.DataBind();
    }
    protected void doDataBind()
    {
        AssetUtility Util = new AssetUtility();
        if (txtId.Text != "")
        {
            SqlDS_AllHistory.SelectParameters["param"].DefaultValue = Util.CleanInput(txtId.Text);
            SqlDS_AllHistory.SelectCommand = "SELECT * FROM [vw_All_ProductHistory] WHERE ([ITAssetProductInfoID] = @param)";
        }
        else if (txtUniquePartNumber.Text != "")
        {
            SqlDS_AllHistory.SelectParameters["param"].DefaultValue = Util.CleanInput(txtUniquePartNumber.Text);
            SqlDS_AllHistory.SelectCommand = "SELECT * FROM [vw_All_ProductHistory] WHERE ([UniquePartNum] = @param)";
        }
        if (!string.IsNullOrEmpty(Request.QueryString["id"]))
        {
            if (!IsPostBack)
            {
                hfSelectedTAB.Value = "1";
            }
            
            Int32 RowID = Convert.ToInt32(Request.QueryString["id"]);
            SqlDS_AllHistory.SelectCommand = "SELECT * FROM [vw_All_ProductHistory] WHERE ([ITAssetProductInfoID] = @param)";
            SqlDS_AllHistory.SelectParameters["param"].DefaultValue = RowID.ToString();
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        txtId.Text = "";
        txtUniquePartNumber.Text = "";
    }
    protected void Button5_Click(object sender, EventArgs e)
    {
        txtUsername.Text = "";
    }
    protected void GridView2_DataBound(object sender, EventArgs e)
    {
        /* call is admin to disable non-admin content */
        isAdmin();
    }
    protected void GridView1_DataBound(object sender, EventArgs e)
    {
        /* call is admin to disable non-admin content */
        isAdmin();
    }
}