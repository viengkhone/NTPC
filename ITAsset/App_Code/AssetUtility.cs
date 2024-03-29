﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Collections;

namespace ITAsset
{
    /*******************************************************************************************
     * Class Enumerator Definition
     ******************************************************************************************/
    public enum ActionAuditType
    {
        ADD = 1,
        EDIT = 2,
        DELETE = 3,
        ASSIGN = 4,
        CANCEL = 5
    }

    public enum ITAuditObjectType
    {
        ITASSET = 1,
        REQUEST = 2,
        ITASSIGNMENT = 3,
        CATEGORY_DATA = 4
    }

    public enum ITAssetManagementMode
    {
        ADD = 1,
        EDIT = 2
    }

    public enum AssetStatusType
    {
        IN_STORE = 1,
        USER_ASSIGNED = 2,
        LOCATION_ASSIGNED = 3,
        CLAIMED = 4,
        REMOVED = 5
    }

    /*******************************************************************************************
     * Start of Asset Utility Class
     *******************************************************************************************/
    public class AssetUtility
    {
        DataClassesDataContext asset = new DataClassesDataContext();
        private String classSubmitBy = "";

        public void setSubmitter(String SubmitBy)
        {
            this.classSubmitBy = SubmitBy;
        }

        /*******************************************************************************************
         * 1.)  [Jump: 27 Sep 2012] : Add Method to get Summitter
         *******************************************************************************************/
        public string getSubmitter()
        {
            string name;

            if (this.classSubmitBy == null || this.classSubmitBy.Trim().Length > 0)
            {
                name = this.classSubmitBy;
            }
            else
            {
                name = "System";
            }

            return name;
        }

        /*******************************************************************************************
         * 1.)  Validation Methods
         *******************************************************************************************/
        public bool isUniquePartNumExist(String UniquePartNum)
        {
            bool exist = false;

            var rec = from r in asset.ITAssetProductInfos where r.UniquePartNum.Equals(UniquePartNum.Trim()) select r;

            if (rec != null && rec.Count() > 0)
            {
                exist = true;
            }

            return exist;
        }

        public bool isProductNumberExist(String productNumber)
        {
            bool exist = false;

            var rec = from r in asset.ITAssetProductInfos where r.ProductNumber.Equals(productNumber.Trim()) select r;

            if (rec != null && rec.Count() > 0)
            {
                exist = true;
            }

            return exist;
        }

        public bool isFADAsset(int isAsset)
        {
            bool isFADAsset = false;

            var rec = from r in asset.ITAssetTypes where r.isAsset == isAsset select r;
            if (rec != null && rec.Count() > 0)
            {
                foreach (var r in rec)
                {
                    if (r.isAsset.HasValue)
                    {
                        if (r.isAsset == 1)
                        {
                            isFADAsset = true;
                        }
                    }
                }
            }

            return isFADAsset;
        }

        /*******************************************************************************
         * [Ting: 1 Nov 2012] Methods to prevent SQL Injection
         *******************************************************************************/
        public string CleanInput(string input)
        {
            input = input.Replace("\"", "");
            input = input.Replace("'", "");
            input = input.Replace("{", "");
            input = input.Replace("}", "");
            input = input.Replace("(", "");
            input = input.Replace(")", "");
            input = input.Replace("@", "");
            input = input.Replace(";", "");

            return input;
        }

        /*******************************************************************************
         * [Ting: 1 Nov 2012] Methods to get current windows user name
         *******************************************************************************/
        public string showUserName()
        {
            string UserName = HttpContext.Current.User.Identity.Name.ToString().ToLower();
            UserName = UserName.Replace("namtheun2\\", "");

            if (UserName == "khamsone" || UserName == "viengkhone")
            {
                return UserName + " [Admin]";
            }
            else if (UserName == "thatchakorn" || UserName == "anouphone" || UserName == "khampaseuth" || UserName == "kongmany" || UserName == "phonevilay" || UserName == "singsouttho" || UserName == "sinnakone")
            {
                return UserName + " [Contributor]";
            }
            else if (UserName == "yenchit" || UserName == "vanida" || UserName == "viengkham" || UserName == "dalavone" || UserName == "latthikone" || UserName == "khanthong" || UserName == "viengkhone_dba")
            {
                return UserName + " [DCC Team]";
            }
            else
            {
                return UserName + " [Read Only]";
            }
        }
        public string GetUserNameOnly()
        {
            string UserName = HttpContext.Current.User.Identity.Name.ToString().ToLower();
            UserName = UserName.Replace("namtheun2\\", "");

            return UserName;
        }
        public string GetUserFullLogin()
        {
            string UserName = HttpContext.Current.User.Identity.Name.ToString().ToLower();

            return UserName;
        }

        /*******************************************************************************
         * [Ting: 29 Nov 2012] Methods to get dataset from input sql string
         *******************************************************************************/
        private DataSet NewDS = new DataSet();

        public DataSet GetDataSetBySQL(String sql, String tableName)
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["ITAssetTrackingConnectionString2"].ToString();
            System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(connString);
            System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = sql;
            System.Data.SqlClient.SqlDataAdapter da = new System.Data.SqlClient.SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds);
            DataTable dt = ds.Tables[0].Copy();
            dt.TableName = tableName;
            try
            {
                NewDS.Tables.Add(dt);
                return NewDS;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ArrayList GetDccData(string sql)
        {
            ArrayList lst = new ArrayList();
            System.Data.SqlClient.SqlConnection Conn = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["DccDBConnectionString"].ToString());
            Conn.Open();
            System.Data.SqlClient.SqlCommand myCmd = new System.Data.SqlClient.SqlCommand(sql, Conn);
            System.Data.SqlClient.SqlDataAdapter da = new System.Data.SqlClient.SqlDataAdapter(myCmd);
            DataSet ds = new DataSet();
            da.Fill(ds);

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                lst.Add(new object[] { dr[0].ToString(), dr[1].ToString(), dr[2].ToString(), dr[3].ToString(), dr[4].ToString(), dr[5].ToString(), dr[6].ToString(), dr[7].ToString(), dr[8].ToString(), dr[9].ToString(), dr[10].ToString(), dr[11].ToString(), dr[12].ToString(), dr[13].ToString(), dr[14].ToString(), dr[15].ToString() });
            }
            Conn.Close();
            
            return lst;
        }
    }
}