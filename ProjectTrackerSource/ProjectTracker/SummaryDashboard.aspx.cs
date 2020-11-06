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

namespace ProjectTracker
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
            for (int i = 1; i < dSummarytable.Columns.Count; i++)
            {
                Series series = new Series(dSummarytable.Columns[i].ColumnName);
                foreach (DataRow dr in dSummarytable.Rows)
                {
                    int y = (int)dr[i];
                    series.Points.AddXY(dr["REGION"].ToString(), y);
                    series.IsValueShownAsLabel = true;
                }
                SummaryChart.Series.Add(series);
            }

            gvSummaryDetail.DataSource = dSummarytable;
            gvSummaryDetail.DataBind();
        }
    }
}