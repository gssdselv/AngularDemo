using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections;

namespace Converter
{
    class Program
    {
        static void Main(string[] args)
        {

            string filePath = Console.ReadLine();
            string[] lines = File.ReadAllLines(filePath, Encoding.UTF32);
            StringBuilder sb = new StringBuilder();
            StringBuilder sbNewLines = new StringBuilder();
            Regex regex = new Regex("[)][ ]*[{]([a-zA-Z]|[0-9]|[=]|[,]|[ ]|[)]|[(]|[']|[\"]|[.]|[-]|[+]|[{]|[}]|[•]|[–]|[»]|[ＭＳ Ｐゴシック]|[맑은 고딕]|[宋体]|[新細明體])*[}]");
            foreach (string line in lines)
            {
                string newLineValue = line;
                sbNewLines = new StringBuilder();
                if (!newLineValue.Contains("private") && !newLineValue.Contains("protected") && !newLineValue.Contains("public"))
                {
                    MatchCollection mc = regex.Matches(newLineValue);
                    foreach (Match match in mc)
                    {
                        string values = newLineValue.Substring(match.Index + 2, match.Length - 3);
                        newLineValue = newLineValue.Remove(match.Index + 1, match.Length - 1);
                        string[] sides = newLineValue.Split('=');
                        string[] leftSide = sides[0].Trim().Split(' ');
                        string[] objects = leftSide[leftSide.Length - 1].Trim().Split('.');
                        string objectName = objects[objects.Length - 1].Trim();
                        string[] properties = values.Split(',');
                        foreach (string property in properties)
                        {
                            string newLine = String.Format("{0}.{1};", objectName, property.Trim());
                            sbNewLines.AppendLine(newLine);
                        }
                    }
                }
                sb.Append(newLineValue);
                sb.AppendLine(sbNewLines.ToString());
            }
            File.WriteAllText(Console.ReadLine(), sb.ToString());
        }
    }
}
