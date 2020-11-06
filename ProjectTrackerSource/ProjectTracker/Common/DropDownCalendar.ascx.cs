using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.ComponentModel;
using System.Drawing;

/*
 *
 * Developer: Marcos Fernandes
 * Date: 04/18/2007
 *
 */

namespace ProjectTracker.Common
{
    [ValidationProperty("SelectedDateText")]
    public partial class DropDownCalendar : System.Web.UI.UserControl
    {

        #region Properties

        #region Appearance Properties

        /// <summary>
        /// A cor de fundo do calendario.
        /// </summary>
        [Category("Appearance"), Browsable(true)]
        public Color BackColor
        {
            get { return cld.BackColor; }
            set { cld.BackColor = value; }
        }

        /// <summary>
        /// A cor da borda.
        /// </summary>
        [Category("Appearance"), Browsable(true)]
        public Color BorderColor
        {
            get { return cld.BorderColor; }
            set { cld.BorderColor = value; }
        }

        /// <summary>
        /// A cor da fonte.
        /// </summary>
        [Category("Appearance"), Browsable(true)]
        public Color ForeColor
        {
            get { return cld.ForeColor; }
            set { cld.ForeColor = value; }
        }

        /// <summary>
        /// A largura da borda.
        /// </summary>
        [Category("Appearance"), Browsable(true)]
        public Unit BorderWidth
        {
            get { return cld.BorderWidth; }
            set { cld.BorderWidth = value; }
        }

        /// <summary>
        /// A fonte do texto.
        /// </summary>
        [Category("Appearance"), Browsable(true)]
        public FontInfo Font
        {
            get { return cld.Font; }
            set { cld.Font.CopyFrom(value); }
        }

        #endregion

        #region Styles Properties

        /// <summary>
        /// O estilo do dia selecionado.
        /// </summary>
        [Category("Styles")]
        public TableItemStyle TodayDateStyle
        {
            get { return cld.SelectedDayStyle; }
            set { cld.SelectedDayStyle.CopyFrom(value); }
        }

        /// <summary>
        /// O formato do próximo e do anterior.
        /// </summary>
        [Category("Styles")]
        public NextPrevFormat NextPrevFormat
        {
            get { return cld.NextPrevFormat; }
            set { cld.NextPrevFormat = value; }
        }

        /// <summary>
        /// O estilo do cabeçalho do dia.
        /// </summary>
        [Category("Styles")]
        public TableItemStyle DayHeaderStyle
        {
            get { return cld.DayHeaderStyle; }
            set { cld.DayHeaderStyle.CopyFrom(value); }
        }

        /// <summary>
        /// O estilo do titulo.
        /// </summary>
        [Category("Styles")]
        public TableItemStyle TitleStyle
        {
            get { return cld.TitleStyle; }
            set { cld.TitleStyle.CopyFrom(value); }
        }

        /// <summary>
        /// O estilo dos dias de fim de semana.
        /// </summary>
        [Category("Styles")]
        public TableItemStyle WeekendDayStyle
        {
            get { return cld.WeekendDayStyle; }
            set { cld.WeekendDayStyle.CopyFrom(value); }
        }

        #endregion

        #region Behavior Properties

        /// <summary>
        /// O Formato da data a ser mostrada na caixa de texto.
        /// </summary>
        [DefaultValue("MM/dd/yyyy")]
        [CategoryAttribute("Behavior")]
        public string DateFormat
        {
            get
            {
                object obj = base.ViewState["DateFormat"];
                if (obj != null)
                    return obj.ToString();
                //return "MM/dd/yyyy";
                return System.Threading.Thread.CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern;
            }
            set
            {
                base.ViewState["DateFormat"] = value;
            }
        }

        /// <summary>
        /// Indica se o controle está habilitado.
        /// </summary>
        [DefaultValue(true)]
        [CategoryAttribute("Behavior")]
        public bool Enabled
        {
            get
            {
                return cld.Enabled;
            }
            set
            {
                cld.Enabled = value;
                txtSelectedDate.Enabled = value;
                btnShowCalendar.Enabled = value;
                if (!value)
                    txtSelectedDate.BackColor = Color.FromArgb(153, 153, 153);
                else
                    txtSelectedDate.BackColor = Color.White;
            }
        }

        #endregion

        #region Logic Properties

        /// <summary>
        /// A data selecionada como string.
        /// </summary>
        [Bindable(BindableSupport.Yes, BindingDirection.TwoWay)]
        public string SelectedDateText
        {
            get
            {
                return txtSelectedDate.Text;
            }
            set
            {
                txtSelectedDate.Text = value;
                selectedDate.Value = value;
                if (value != "")
                {
                    DateTime dt = Convert.ToDateTime(value);
                    txtSelectedDate.Text = dt.ToString(DateFormat);
                    selectedDate.Value = dt.ToString(DateFormat);
                }
            }
        }

        /// <summary>
        /// A data selecionada.
        /// </summary>
        public DateTime SelectedDate
        {
            get
            {                
                return DateTime.ParseExact(SelectedDateText, DateFormat, null);
            }
        }

        #endregion

        #endregion

        #region Events

        #region Page Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //selectedDate.Value = DateTime.Now.ToString(DateFormat);
            }
        }

        #endregion

        #region Panel Events

        protected void calendarContainer_Load(object sender, EventArgs e)
        {
            calendarContainer.Style["display"] = panelStatus.Value;
        }

        #endregion

        #region TextBox Events

        protected void txtSelectedDate_Load(object sender, EventArgs e)
        {
            txtSelectedDate.Text = CheckmarxHelper.EscapeReflectedXss(selectedDate.Value);
            //txtSelectedDate.Text = selectedDate.Value;
        }

        #endregion

        #region Calendar Events

        protected void cld_DayRender(object sender, DayRenderEventArgs e)
        {
            // Remove o link da celula para evitar post back..
            e.Cell.Controls.Clear();
            // Adiciona um link html...
            HtmlGenericControl link = new HtmlGenericControl();
            link.TagName = "a";
            link.InnerText = e.Day.DayNumberText;
            link.Attributes.Add("href", String.Format("javascript:setSelectedDate('{0}', '{1}', '{2}', '{3}', '{4}', '{5}');", 
                                                        txtSelectedDate.ClientID,
                                                        selectedDate.ClientID,
                                                        calendarContainer.ClientID,
                                                        panelStatus.ClientID,
                                                        e.Day.Date.ToString(DateFormat),                                                        
                                                        this.ClientID
                                                     ));
            // Seleciona o dia atual..
            if (e.Day.IsSelected)
            {
                link.Attributes["style"] = cld.SelectedDayStyle.ToString();
            }
            link.Disabled = e.Day.IsOtherMonth;
            if (e.Day.IsOtherMonth)
                link.Attributes["href"] = String.Format("javascript:showCalendar('{0}', '{1}');", calendarContainer.ClientID, panelStatus.ClientID);
            // Adiciona o link...
            e.Cell.Controls.Add(link);
        }

        #endregion

        #endregion

        #region Override Methods

        public override void RenderControl(HtmlTextWriter writer)
        {
            writer.WriteLine("<div id=\"{0}\" value=\"{1}\" style=\"float:left;\">", this.ClientID, CheckmarxHelper.EscapeReflectedXss(selectedDate.Value));
            //writer.WriteLine("<div id=\"{0}\" value=\"{1}\" style=\"float:left;\">", this.ClientID, selectedDate.Value);
            base.RenderControl(writer);
            writer.WriteLine(String.Format("</div>"));
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            calendarContainer.Style.Add("position", "absolute");
            // calendarContainer.Attributes.Add("onblur", String.Format("closeCalendar('{0}', '{1}');return false;", calendarContainer.ClientID, panelStatus.ClientID));
            // Atribui as chamadas dos scripts...
            btnShowCalendar.OnClientClick = String.Format("showCalendar('{0}', '{1}');return false;", calendarContainer.ClientID, panelStatus.ClientID);
            btnClearCalendar.OnClientClick = String.Format("clearCalendar('{0}', '{1}', '{2}');return false;", txtSelectedDate.ClientID, selectedDate.ClientID, this.ClientID);
            txtSelectedDate.Attributes.Add("onkeyup", string.Format("setCtlValue('{0}','{1}','{2}','{3}')", txtSelectedDate.ClientID, selectedDate.ClientID, this.ClientID, this.cld.ClientID));
        }

        #endregion

    }
}