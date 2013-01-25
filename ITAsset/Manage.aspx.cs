using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ITAsset;

public partial class Manage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        /* Manage.aspx is currently made public
         * --------------------------------------------
        if (Session["LoginID"] == null)
        {
            Response.Redirect("Default.aspx?error=1");
        }
        */
        if (!string.IsNullOrEmpty(Request.QueryString["id"]))
        {
            if (!IsPostBack)
            {
                hfSelectedTAB.Value = "0";
            }
            SqlDataSource1.SelectCommand = string.Format("SELECT [id], [ITAssetDetails], [UniquePartNum], [currentUserID], [Location], [UserType], [UserName], [StatusName] FROM [vw_ITAssetAllProducts] WHERE ([id] = {0})", Convert.ToInt32(Request.QueryString["id"]));
        }
    }
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        SqlDS_DetailsView1.SelectParameters["id"].DefaultValue = GridView1.SelectedValue.ToString();
        MultiView1.ActiveViewIndex = 1;
        DetailsView1.PageIndex = 1;
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        GridView1.DataBind();
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        //prevent SQL Injection
        AssetUtility Util = new AssetUtility();
        string InputKeyword = Keywords.Text;

        SqlDataSource1.SelectCommand = string.Format("SELECT [id], [ITAssetDetails], [UniquePartNum], [currentUserID], [Location], [UserType], [UserName], [StatusName] FROM [vw_ITAssetAllProducts] WHERE (([TypeName] LIKE '%{0}%') OR ([SubTypeName] LIKE '%{0}%') OR ([ITAssetDetails] LIKE '%{0}%') OR ([UniquePartNum] LIKE '%{0}%') OR ([UserName] LIKE '%{0}%') OR ([Location] LIKE '%{0}%'))", Util.CleanInput(InputKeyword));
        GridView1.AllowPaging = false ;
    }
    protected void GoToManageAssetPage(object sender, EventArgs e)
    {
        MultiView1.ActiveViewIndex = 0;
    }
    protected void DetailsView1_DataBound(object sender, EventArgs e)
    {
        SetDefaultValue(DetailsView1, "view1");
    }
    protected void DetailsView2_DataBound(object sender, EventArgs e)
    {
        SetDefaultValue(DetailsView2, "view2");
        DetailsView2.Visible = true; /* fix bug, after set default value, turn it back ON */
    }

    /*********************************************************************** 
     * Set Default value to Date and UserName to Details View 
     **********************************************************************/
    protected void SetDefaultValue(DetailsView dw, string MyView)
    {
        if (dw.CurrentMode == DetailsViewMode.Insert || dw.CurrentMode == DetailsViewMode.Edit)
        {
            TextBox EditDate = dw.FindControl("TextBox1") as TextBox;
            EditDate.Text = DateTime.Now.ToShortDateString();

            string[] strs = Master.PropertyMasterlblUser.Text.Split(' ');
            TextBox EditBy = dw.FindControl("TextBox2") as TextBox;
            EditBy.Text = strs[2];

            /* for insert of DetailsView1, default value for SubmitDate and Submit by are needed */
            if ((dw.CurrentMode == DetailsViewMode.Insert) && (MyView == "view1"))
            {
                TextBox SubmitDate = dw.FindControl("TextBox4") as TextBox;
                SubmitDate.Text = DateTime.Now.ToShortDateString();
                TextBox SubmitBy = dw.FindControl("TextBox3") as TextBox;
                SubmitBy.Text = strs[2];
                DropDownList SectionDropDown = dw.FindControl("DropDownList5") as DropDownList;
                SectionDropDown.SelectedValue = "83";
            }

            /* the DetailsView2 can only be Updated, insert is not relivant, so, Turn it Off */
            DetailsView2.Visible = false;
        }
        else
        {
            DetailsView2.Visible = true;
        }
    }

    protected void LinkBtnAddNewAsset_Click(object sender, EventArgs e)
    {
        MultiView1.ActiveViewIndex = 1;
        DetailsView1.ChangeMode(DetailsViewMode.Insert);
        hfSelectedTAB.Value = "0";
    }
    protected void DetailsView1_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        SqlDS_DetailsView1.SelectCommand = "SELECT TOP 1 * FROM [ITASSET].[ITAssetProductInfo] ORDER BY id DESC";
        DetailsView1.DataBind();
        ChangeState(); // Change state of DetailsView2
    }
    protected void DetailsView1_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        ChangeState();
    }
    /* *******************************************************************************
     * DetailsView 2 has been Turned-Off, we need to turn it ON and refresh its value 
     *********************************************************************************/
    private void ChangeState()
    {
        DetailsView2.Visible = true;
        DetailsView2.DataBind();
    }
    protected void linkBtn_category_Click(object sender, EventArgs e)
    {
        MultiView2.ActiveViewIndex = 1;
        Add_Remove_Loc.Text = "List of Category Items";
    }
    protected void linkBtn_user_Click(object sender, EventArgs e)
    {
        MultiView2.ActiveViewIndex = 2;
        Add_Remove_Loc.Text = "List of Non-NTPC Users or User Group";
    }
    protected void linkBtn_location_Click(object sender, EventArgs e)
    {
        MultiView2.ActiveViewIndex = 3;
        Add_Remove_Loc.Text = "List of Available Location";
    }
    protected void linkBtn_dept_Click(object sender, EventArgs e)
    {
        MultiView2.ActiveViewIndex = 4;
        Add_Remove_Loc.Text = "List of Section";
    }
    protected void GridView_User_Item_SelectedIndexChanged(object sender, EventArgs e)
    {
        DetailsView_User_Item.PageIndex = GridView_User_Item.SelectedIndex;
    }
    protected void GridView1_DataBound(object sender, EventArgs e)
    {
        isAdmin();
    }

    /* disable edit control when user is not admin */
    protected void isAdmin()
    {
        int anAdmin = Master.PropertyMasterlblUser.Text.IndexOf("[Admin]");
        //Response.Write("<script>alert('" + Master.PropertyMasterlblUser.Text.ToString() + "');</script>");
        if (anAdmin == -1)
        {
            DetailsView1.Enabled = false;
            DetailsView2.Enabled = false;
            //and others that relates to Guest
            GridView_FullList.Enabled = false;
            linkBtn_category.Enabled = false;
            linkBtn_dept.Enabled = false;
            linkBtn_location.Enabled = false;
            linkBtn_user.Enabled = false;
            LinkBtnAddNewAsset.Enabled = false;
            DetailsView1.Enabled = false;
            DetailsView2.Enabled = false;
        }
    }
}