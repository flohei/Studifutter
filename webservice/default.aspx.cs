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
using System.Globalization;

/// <summary>
/// Simon Heidingsfelder - Simon.heidingsfelder@gmx.de
/// </summary>

public partial class speiseplan : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsIPhoneUser() == false)
        {
            Response.Redirect("speiseplan.aspx");
            //Response.Redirect("http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-n-mensateria.shtml");
        }
        else
        {
            clsSpeiseplan clsSpeisen = new clsSpeiseplan();

            DataTable dt = clsSpeisen.getSpeiseplanAktuell();

            foreach (DataRow dr in dt.Rows)
            {
                string text = "";
                text = dr[2].ToString();
                try 
                    {

                        litListe.Text = litListe.Text + "<li><a href=\"#_Tag" + dr[0].GetHashCode().ToString() + "\"><em>" + dr[1] + " " + dr[0] + "</em><small>" + text + "</small></a></li>";
                        litTage.Text = litTage.Text + " <div class=\"iLayer\" id=\"waTag" + dr[0].GetHashCode().ToString() + "\" title=\"" + dr[1] + " " + dr[0] + "\"><div class=\"iBlock\"><h1>Heute gibts</h1><p>" + replace(text) + "</p></div></div>";

                    }
                catch(Exception ex) {

                    text=             dr[0].ToString() + " " + ex.Message;
                    litListe.Text = litListe.Text + "<li><a href=\"#_Tag" + dr[0].ToString().GetHashCode().ToString() + "\"><em>" + "fehler" + " " + "fehler" +"</em><small>" + text + "</small></a></li>";
                litTage.Text = litTage.Text + " <div class=\"iLayer\" id=\"waTag" + dr[0].ToString().GetHashCode().ToString() + "\" title=\"" + "fehler" + " " + "fehler" + "\"><div class=\"iBlock\"><h1>Heute gibts</h1><p>" + text + "</p></div></div>";


       
                
                }


            }




            //litListe.Text="<li><a href=\"#_Tag1.10.2008\"><em>Mittwoch, 1.10.2008</em><small>Bohnen</small></a></li><li><a href=\"#_Article\"><em>Donnerstag, 2.10.2008</em><small>Kraut</small></a></li>";

            //litTage.Text = " <div class=\"iLayer\" id=\"waTag1.10.2008\" title=\"Speiseplan 1.10.2008\"><div class=\"iBlock\"><h1>Heute gibts</h1><p>Bohnen</p></div></div>";





        }
    }

    private string replace(string _text)
    {
        string[] splitter=_text.Split('€');
        _text = "";

        for (int i = 0; i < splitter.Length-1; i++)
        {
            if (i + 1 >= splitter.Length - 1) {

                _text = _text + splitter[i] + "€";
            }
            else
            {
                _text = _text + splitter[i] + "€</p><p>";
            }
        }
        
        return _text;
    
    }



    private bool  IsIPhoneUser()
    {

      
        return HttpContext.Current.Request.UserAgent.ToLower().Contains("iphone");
   
    }

    private string switchDay(string day)
    {
        string ret="";

        switch (day)
        { 
            case "Monday":
                ret= "Montag";
                break;

            case "Tuesday":
                ret = "Dienstag";
                break;


            case "Wednesday":
                ret = "Mittwoch";
                break;


            case "Thursday":
                ret = "Donnerstag";
                break;


            case "Friday":
                ret = "Freitag";
                break;


            case "Saturday":
                ret = "Samstag";
                break;


            case "Sunday":
                ret = "Sonntag";
                break;
        
        }


        return  ret;
    }


}
