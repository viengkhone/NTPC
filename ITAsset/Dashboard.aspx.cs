using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        /* Dashboard.aspx is currently made public
         * --------------------------------------------
        if (Session["LoginID"] == null)
        {
            Response.Redirect("Default.aspx?error=1");
        }
         */
    }
    protected void Panel1_Load(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Request.QueryString["enumStatus"]))
        {
            if (!IsPostBack)
            {
                hfSelectedTAB.Value = "1";
            }
        }
    }
}
