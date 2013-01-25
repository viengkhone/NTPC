using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNet.Highcharts.Enums;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts;
using DotNet.Highcharts.Options;
using System.Drawing;
using System.Data;
using System.Collections;

public partial class Reports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        /*  Report.aspx is currently made public
         * --------------------------------------------
        if (Session["LoginID"] == null)
        {
            Response.Redirect("Default.aspx?error=1");
        }
        */

        ITAsset.AssetUtility Util = new ITAsset.AssetUtility();
        DataSet DS1 = new DataSet();
        DS1 = Util.GetDataSetBySQL("SELECT Code, ISNULL([Desktop Set],0) AS Desktop, ISNULL([Laptop Set],0) AS Laptop FROM [vw_Rpt_ByDivision]", "Division");
        ltrChart1.Text = GetChartItemByDivision(DS1).ToHtmlString();

        DS1 = Util.GetDataSetBySQL("SELECT TypeName AS name, COUNT(id) AS count FROM dbo.vw_ITAssetAllProducts GROUP BY TypeName;", "Status");
        ltrChart2.Text = GetChartItemByMainType(DS1).ToHtmlString();
    }

    /*******************************************************************************************
    * Confiture and build chart : ItemByDivision
    ******************************************************************************************/
    private DotNet.Highcharts.Highcharts GetChartItemByDivision(DataSet dsSeries) 
    {
        
        String[] myCategory = new String[dsSeries.Tables[0].Rows.Count];
        String myLaptopVal = "";
        String myDesktopVal = "";
        Int32 i = 0;

        foreach (DataRow dr0 in dsSeries.Tables[0].Rows)
        {
            myCategory[i] = dr0["Code"].ToString().Replace("&"," and ");
            i = i + 1;
        }
        foreach (DataRow dr1 in dsSeries.Tables[0].Rows)
        {
            myLaptopVal = myLaptopVal + dr1["Laptop"] + ",";
        }
        myLaptopVal = myLaptopVal.Substring(0, myLaptopVal.Length - 1);
        foreach (DataRow dr2 in dsSeries.Tables[0].Rows)
        {
            myDesktopVal = myDesktopVal + dr2["Desktop"] + ",";
        }
        myDesktopVal = myDesktopVal.Substring(0, myDesktopVal.Length - 1);

        //Start Graph 1 Chart
        DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts("chart")
            .InitChart(new Chart
            {
                DefaultSeriesType = ChartTypes.Column,
                MarginRight = 130,
                MarginBottom = 25,
                ClassName = "chart"
            })
            .SetXAxis(new XAxis
            {
                Categories = myCategory
            })
            .SetSeries(new[] {
                new Series{
                    Name = "Laptop Set",
                    Data = new Data(new object[] { myLaptopVal })
                },
                new Series{
                    Name = "Desktop Set",
                    Data = new Data(new object[] { myDesktopVal })
                }
            })
            .SetTitle(new Title
            {
                Text = "IT Asset by Division",
                X = -20
            })
            .SetLegend(new Legend
            {
                Layout = Layouts.Vertical,
                Align = HorizontalAligns.Right,
                VerticalAlign = VerticalAligns.Top,
                X = -10,
                Y = 100,
                BorderWidth = 0
            })
            .SetYAxis(new YAxis
            {
                Title = new XAxisTitle { Text = "No. of Laptop & Desktop" },
                PlotLines = new[]
                {
                    new XAxisPlotLines
                    {
                        Value = 0,
                        Width = 1,
                        Color = ColorTranslator.FromHtml("#808080")
                    }
                }
            })
            .SetTooltip(new Tooltip
            {
                Formatter = @"function() {
                                    return '<b>'+ this.series.name +'</b><br/>'+
                                this.x +': '+ this.y +' item(s)';
                            }"
            });

        return chart;
    }

    /*******************************************************************************************
    * Confiture and build chart : Status
    ******************************************************************************************/
    private DotNet.Highcharts.Highcharts GetChartItemByMainType(DataSet dsSeries)
    {
        var DataObject = new List<object>();
        Int32 i = 0;

        foreach (DataRow dr in dsSeries.Tables[1].Rows)
        {
            DataObject.Add(new object[] { dr["name"].ToString(), dr["count"].ToString() });
            i = i + 1 ;
        }
        Array data = DataObject.ToArray();
        
        //Start Graph 2 Chart
        DotNet.Highcharts.Highcharts chart2 = new DotNet.Highcharts.Highcharts("chart2")
            .InitChart(new Chart
            {
                DefaultSeriesType = ChartTypes.Pie,
                MarginRight = 130,
                MarginBottom = 25,
                ClassName = "chart2"
            })
            .SetSeries(new Series
            {
                Type = ChartTypes.Pie,
                Name = "Browser share",
                Data = new Data(new object[] {
                    new object[] {"Test 1", 60},
                    new object[] {"Test 2", 20},
                    new object[] {"Test 3", 5},
                    new object[] {"Test 4", 15}
                })
            })
            .SetTitle(new Title { Text = "Item by Main Type" })
            .SetTooltip(new Tooltip { Formatter = "function() { return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %'; }" });

        return chart2;
    }

    //Suppress Zero in GridView
    protected void GridView_ItemByStatus_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        foreach (TableCell c in e.Row.Cells)
        {
            if (c.Text == "0")
            {
                c.Text = "-";
            }
        }
    }
}