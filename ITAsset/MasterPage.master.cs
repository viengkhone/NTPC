using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ITAsset;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AssetUtility Util = new AssetUtility(); // Create new Utility Instance
        lblUser.Text = "Current User: " + Util.showUserName();
        StyleSelectedMenu();
    }

    //Made lblUser available to Public
    public Label PropertyMasterlblUser
    {
        get { return lblUser; }
        set { lblUser = value; }
    }

    //For Selected Menu Style
    protected void StyleSelectedMenu()
    {
        foreach (MenuItem item in Menu1.Items)
        {
           if (Request.Url.AbsoluteUri.ToLower().Contains(item.NavigateUrl.ToLower()))
           {
              item.Selected = true;
           }
        }
    }
}
