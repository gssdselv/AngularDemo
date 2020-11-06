using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Xml.Serialization;
using System.IO;
using System.Configuration;

namespace Fit.Common
{

    /// <summary>
    /// Class that controls the colors in each value range of the percentage completion bar chart 
    /// </summary>
    public class PercentageCompletionBarChartColor
    {

        #region Attributes

        private int fromValue;
        private int toValue;
        private int argbColor;

        #endregion

        #region Properties

        /// <summary>
        /// The initial value of the range
        /// </summary>
        public int FromValue
        {
            get { return fromValue; }
            set { fromValue = value; }
        }

        /// <summary>
        /// The final value of the range
        /// </summary>
        public int ToValue
        {
            get { return toValue; }
            set { toValue = value; }
        }

        /// <summary>
        /// The color of the range
        /// </summary>
        public int ArgbColor
        {
            get { return argbColor; }
            set { argbColor = value; }
        }

        #endregion

        #region Static Attributes

        /// <summary>
        /// List of ranges loaded from the file
        /// </summary>
        private static List<PercentageCompletionBarChartColor> colorList;

        #endregion

        #region Static Methods

        /// <summary>
        /// Get the color based on the value
        /// </summary>
        /// <param name="percent">The value to get the range color</param>
        /// <returns>The color of the range</returns>
        public static Color GetColor(int percent)
        {
            if(colorList==null)
            {
                LoadColors();
            }
            if (colorList != null)
            {
                foreach (PercentageCompletionBarChartColor color in colorList)
                {
                    if (percent >= color.FromValue && percent <= color.ToValue)
                    {
                        return Color.FromArgb(color.ArgbColor);
                    }
                }
            }
            return Color.Orange;
        }

        /// <summary>
        /// Load the list of colors from the file
        /// </summary>
        private static void LoadColors()
        {
            //Get the file path
            string filePath = Convert.ToString(ConfigurationManager.AppSettings["BarChartColorsFile"]);
            if (filePath != null)
            {
                //Deserializes the file into a list of PercentageCompletionBarChartColor objects
                XmlSerializer s = new XmlSerializer(typeof(List<PercentageCompletionBarChartColor>));
                TextReader reader = null;
                try
                {
                    reader = new StreamReader(@filePath);
                }
                catch (Exception ex)
                { 
                    //gerar log
                }
                if (reader != null)
                {
                    colorList = (List<PercentageCompletionBarChartColor>)s.Deserialize(reader);
                    reader.Close();
                }
            }
        }

        #endregion

    }

    public partial class ProgressBar : System.Web.UI.UserControl
    {
        #region Attributes

        private System.Drawing.Color _colFillColor;
        private System.Drawing.Color _colBackcolor;
        private System.Drawing.Color _colBorderColor = Color.Black;

        private int _intBorder = 1;
        private int _intCellspacing = 0;
        private int _intCellpadding = 1;
        private int _intHeight = 15;
        private int _intWidth = 100;

        private int _intBlockNumber = 100;
        private int _intValue;
        private TableRow _tblBlock;

        private int _intStatusAlert = 60;
        private int _intStatusCritical = 80;

        #endregion

        #region Properties

        public System.Drawing.Color FillColor
        {
            get { return _colFillColor; }
            set { _colFillColor = value; }
        }

        public System.Drawing.Color BGColor
        {
            get { return _colBackcolor; }
            set { _colBackcolor = value; }
        }

        public System.Drawing.Color BorderColor
        {
            get { return _colBorderColor; }
            set { _colBorderColor = value; }
        }

        public int BorderSize
        {
            get { return _intBorder; }
            set { _intBorder = value; }
        }

        public int Cellspacing
        {
            get { return _intCellspacing; }
            set { _intCellspacing = value; }
        }

        public int Cellpadding
        {
            get { return _intCellpadding; }
            set { _intCellpadding = value; }
        }

        public int Height
        {
            get { return _intHeight; }
            set { _intHeight = value; }
        }

        public int Width
        {
            get { return _intWidth; }
            set { _intWidth = value; }
        }

        public int Blocks
        {
            get { return _intBlockNumber; }
            set { _intBlockNumber = value; }
        }

        public decimal? Value
        {
            get { return Convert.ToDecimal(_intValue); }
            set 
            {
                if (value == null)
                {
                    _intValue = 0;
                }
                else
                {
                    _intValue = Convert.ToInt32(value);
                }
            }
        }

        public TableRow TblBlock
        {
            get { return _tblBlock; }
            set { _tblBlock = value; }
        }        

        public int StatusAlert
        {
            get { return _intStatusAlert; }
            set { _intStatusAlert = value; }
        }

        public int StatusCritical
        {
            get { return _intStatusCritical; }
            set { _intStatusCritical = value; }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            int intBlocks;
            double percent;

            //Add a new row to the table
            _tblBlock = new TableRow();

            percent = Math.Ceiling((this._intValue * this.Blocks / 100d));

            Color color = PercentageCompletionBarChartColor.GetColor(Convert.ToInt32(this._intValue));

            //Create cells and add to the row
            for (intBlocks = 1; intBlocks < this.Blocks; intBlocks++)
            {
                TableCell tblCell = new TableCell();
                tblCell.Text = "";
                if (intBlocks <= percent)
                {
                    tblCell.BackColor = color;
                }
                _tblBlock.Cells.Add(tblCell);
            }

            tblProgressBar.Rows.Add(_tblBlock);

            //Set the progress bar properties
            tblProgressBar.CellPadding = this.Cellpadding;
            tblProgressBar.CellSpacing = this.Cellspacing;
            tblProgressBar.Width = this.Width;
            tblProgressBar.Height = this.Height;
            tblProgressBar.BackColor = this.BGColor;
            tblProgressBar.BorderColor = this.BorderColor;

        }

    }
}