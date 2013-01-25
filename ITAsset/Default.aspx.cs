using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String errorID = Request.QueryString["error"];
        String action = Request.QueryString["action"];
        if (errorID != null && errorID.Trim().Length > 0)
        {
            if (errorID.Equals("1"))
            {
                LoginFailedLabel.Text = " Additional Login is required for this feature !";
                LoginFailedLabel.Visible = true;
            }
        }
        else
        {
            if (action != null && action.Trim().Length > 0)
            {
                if (action.Equals("logout"))
                {
                    StaffNameLabel.Text = ":: You have successfully logged out";
                }
            }
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (UsernameTextbox.Text.Trim().Length <= 0)
        {

            if (PasswordTextbox.Text.Trim().Length <= 0)
            {
                PasswordErrorLabel.Visible = true;
                UsernameErrorLabel.Visible = true;
            }
            else
            {
                UsernameErrorLabel.Visible = true;
            }
        }
        else
        {

            if (PasswordTextbox.Text.Trim().Length <= 0)
            {
                PasswordErrorLabel.Visible = true;
                UsernameErrorLabel.Visible = false;
            }
            else
            {
                //Validate Here
                PasswordErrorLabel.Visible = false;
                UsernameErrorLabel.Visible = false;

                String username = UsernameTextbox.Text.Trim();
                String password = PasswordTextbox.Text.Trim();

                DataClassesDataContext asset = new DataClassesDataContext();
                
                int StaffID = 0;

                var rec = from r in asset.Admins where r.username.Equals(username) select r;
                if (rec != null && rec.Count() > 0)
                {
                    bool incorrecPassword = false;
                    foreach (var r in rec)
                    {
                        if (!r.password.Equals(password))
                        {
                            incorrecPassword = true;
                        }
                        else
                        {
                            StaffID = r.StaffID;
                        }
                    }

                    if (incorrecPassword)
                    {
                        LoginFailedLabel.Text = "Failed to Login: Password is incorrect";
                        LoginFailedLabel.Visible = true;
                    }
                    else
                    {
                        //StaffNameLabel.Text = util.getStaffFullNameByID(StaffID);
                        PasswordErrorLabel.Visible = false;
                        UsernameErrorLabel.Visible = false;
                        LoginFailedLabel.Visible = false;

                        //Set Session//
                        Session["LoginID"] = "" + StaffID;
                        Response.Redirect("Dashboard.aspx");
                    }
                }
                else
                {
                    LoginFailedLabel.Text = "Failed to Login: Given username can't be found";
                    LoginFailedLabel.Visible = true;
                }

            }
        }


    }
}