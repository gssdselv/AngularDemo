using Fit.Base;
using ProjectTracker.DAO;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.DataVisualization.Charting;
using System.Web.UI.WebControls;

namespace ProjectTracker.Pages
{
    public partial class SummaryDashboard : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DashboardSummaryTableAdapter dsta = new DashboardSummaryTableAdapter();
            dtsProjectTracker.DashboardSummaryDataTable dSummarytable = dsta.GetData();
            LoadChartData(dSummarytable);
        }

        private void LoadChartData(dtsProjectTracker.DashboardSummaryDataTable dSummarytable)
        {
            SummaryChart.ChartAreas["ChartArea1"].AxisX = new Axis { LabelStyle = new LabelStyle() { Font = new Font("Verdana", 7.5f) } };
            SummaryChart.ChartAreas["ChartArea1"].AxisY.LabelAutoFitStyle = LabelAutoFitStyles.None;
            SummaryChartClosed.ChartAreas["ChartArea1"].AxisX = new Axis { LabelStyle = new LabelStyle() { Font = new Font("Verdana", 7.5f) } };
            SummaryChartClosed.ChartAreas["ChartArea1"].AxisY.LabelAutoFitStyle = LabelAutoFitStyles.None;
           
            for (int i = 1; i < dSummarytable.Columns.Count; i++)
            {
                if (dSummarytable.Columns[i].ColumnName != "Closed")
                {
                    Series series = new Series(dSummarytable.Columns[i].ColumnName);
                    foreach (DataRow dr in dSummarytable.Rows)
                    {
                        int y = (int)dr[i];
                        series.Points.AddXY(dr["REGION"].ToString(), y);
                        series.IsValueShownAsLabel = true;
                        series["BarLabelStyle"] = "Center";
                        if (dSummarytable.Columns[i].ColumnName.Equals("Open"))
                        {
                            series.Color = System.Drawing.ColorTranslator.FromHtml("#E3E3B5");
                        }
                        else if (dSummarytable.Columns[i].ColumnName.Equals("Hold"))
                        {
                            series.Color =  System.Drawing.ColorTranslator.FromHtml("#FFE788");
                        }
                        else
                        {
                            series.Color =  System.Drawing.ColorTranslator.FromHtml("#B3E1C2");
                        }
                    }
                    SummaryChart.Series.Add(series);
                }
                else
                {
                    Series series = new Series(dSummarytable.Columns[i].ColumnName);
                    foreach (DataRow dr in dSummarytable.Rows)
                    {
                        int y = (int)dr[i];
                        series.Points.AddXY(dr["REGION"].ToString(), y);
                        series.IsValueShownAsLabel = true;
                        series["PixelPointWidth"] = "30";
                        series.Color = System.Drawing.ColorTranslator.FromHtml("#B3C2F0");
                    }
                    SummaryChartClosed.Series.Add(series);
                }
            }

            gvSummaryDetail.DataSource = dSummarytable;
            gvSummaryDetail.DataBind();
        }

        protected void gvSummaryDetail_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView drv = (DataRowView)e.Row.DataItem;

                for (int i = 0; i < drv.DataView.Table.Columns.Count; i++)
                {
                    switch (drv.DataView.Table.Columns[i].ColumnName)
                    {
                        case "Open":
                            e.Row.Cells[i].BackColor = System.Drawing.ColorTranslator.FromHtml("#E3E3B5");
                            break;
                        case "Hold":
                            e.Row.Cells[i].BackColor = System.Drawing.ColorTranslator.FromHtml("#FFE788");
                            break;
                        case "Dropped":
                            e.Row.Cells[i].BackColor = System.Drawing.ColorTranslator.FromHtml("#B3E1C2");
                            break;
                        case "Closed":
                            e.Row.Cells[i].BackColor = System.Drawing.ColorTranslator.FromHtml("#B3C2F0");
                            break;
                    }

                }

            }
        }
    }
}