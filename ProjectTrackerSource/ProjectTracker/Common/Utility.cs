using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Globalization;

namespace FIT.SCO.Common
{
    public class Utility
    {

        public static void OrderListBox(ListControl listBox, string itemToDisable)
        {
            ArrayList array1 = new ArrayList();
            int i = 0; ;
            for (i = 0; i < listBox.Items.Count; i++)
                array1.Add(listBox.Items[i].Text + ";" + listBox.Items[i].Value);

            array1.Sort();
            listBox.Items.Clear();
            for (i = 0; i < array1.Count; i++)
            {
                string[] value = array1[i].ToString().Split(';');

                ListItem itemToAdd = new ListItem(value[0], value[1]);
                listBox.Items.Add(itemToAdd);
                if (itemToAdd.Value == itemToDisable)
                    itemToAdd.Enabled = false;
            }
        }

        public static void OrderListBox(ListControl listBox)
        {
            ArrayList array1 = new ArrayList();
            int i = 0; ;
            for (i = 0; i < listBox.Items.Count; i++)
                array1.Add(listBox.Items[i].Text + ";" + listBox.Items[i].Value);

            array1.Sort();
            listBox.Items.Clear();
            for (i = 0; i < array1.Count; i++)
            {
                string[] value = array1[i].ToString().Split(';');

                ListItem itemToAdd = new ListItem(value[0], value[1]);
                listBox.Items.Add(itemToAdd);

            }
        }

        /// <summary>
        /// This method fill the DropDownList with the available DataSource that you set.
        /// </summary>
        /// <param name="ListToFill">The DropDownList to be filled.</param>
        /// <param name="DataSource">The DropDownList DataSource</param>
        /// <param name="TextField">The name of the column that fill the DataTextField of DropDownList</param>
        /// <param name="ValueField">The name of the column that fill the DataValueField of DropDownList</param>
        /// <param name="NonSelectedItem">The message to be added to an non selected item.</param>
        public static void FillList(DropDownList ListToFill, DataTable DataSource, string TextField, string ValueField, string NonSelectedItem)
        {
            // Clear items from dropdownlist...
            ListToFill.Items.Clear();
            // Set the data source and the datatext and datavalue fields...
            // Verify if dataSource is not null, or contain rows...
            if (DataSource != null && DataSource.Rows.Count > 0)
            {
                ListToFill.DataSource = DataSource;
                ListToFill.DataTextField = TextField;
                ListToFill.DataValueField = ValueField;
                ListToFill.DataBind();
            }
            ListToFill.Items.Insert(0, new ListItem(HttpContext.GetGlobalResourceObject("Default","SELECT_A_ITEM").ToString(), ""));
            ListToFill.SelectedIndex = 0;
        }

        /// <summary>
        /// This method fill the DropDownList with the available DataSource that you set.
        /// </summary>
        /// <param name="ListToFill">The DropDownList to be filled.</param>
        /// <param name="DataSource">The DropDownList DataSource</param>
        /// <param name="TextField">The name of the column that fill the DataTextField of DropDownList</param>
        /// <param name="ValueField">The name of the column that fill the DataValueField of DropDownList</param>
        /// <param name="NonSelectedItem">The message to be added to an non selected item.</param>
        public static void FillList2(DropDownList ListToFill, DataTable DataSource, string TextField, string ValueField, string NonSelectedItem)
        {
            // Clear items from dropdownlist...
            ListToFill.Items.Clear();
            // Set the data source and the datatext and datavalue fields...
            // Verify if dataSource is not null, or contain rows...
            if (DataSource != null && DataSource.Rows.Count > 0)
            {
                ListToFill.DataSource = DataSource;
                ListToFill.DataTextField = TextField;
                ListToFill.DataValueField = ValueField;
                ListToFill.DataBind();
            }
            ListToFill.Items.Insert(0, new ListItem(NonSelectedItem, ""));
            ListToFill.SelectedIndex = 0;
        }

        /// <summary>
        /// Add new item to dropdown to force the user select a item. 
        /// </summary>
        /// <param name="ddl">DropDown that will recieve the item.</param>
        public static void AddEmptyItem(ListControl ddl)
        {
            ListItem li = new ListItem(HttpContext.GetGlobalResourceObject("Default", "SELECT_A_ITEM").ToString(), "");
            ddl.Items.Insert(0, li);
        }

        /// <summary>
        /// Add new item to dropdown to force the user select a item. 
        /// </summary>
        /// <param name="ddl">DropDown that will recieve the item.</param>
        public static void AddEmptyItem(ListControl ddl, string valueToItem)
        {
            ListItem li = new ListItem(HttpContext.GetGlobalResourceObject("Default", "SELECT_A_ITEM").ToString(), valueToItem);
            ddl.Items.Insert(0, li);
        }

        public static void AddEmptyItem(ListControl ddl, string valueToItem, string text)
        {
            ListItem li = new ListItem(text.ToString(), valueToItem);
            ddl.Items.Insert(0, li);
        }



    }
}
