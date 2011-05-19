<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="speiseplan" %>

<%@ Register Assembly="AdSenseASP.NET" Namespace="AdSenseASP.NET" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Mensa Speiseplan</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        &nbsp;</div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:DropDownList ID="ddlPeriode" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPeriode_SelectedIndexChanged" DataSourceID="SqlDataSource1" DataTextField="Periode" DataValueField="Periode">
                </asp:DropDownList><asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                    SelectCommand="SELECT DISTINCT [Periode] FROM [Speiseplan] ORDER BY [Periode] DESC">
                </asp:SqlDataSource>
                <br />
        
        <table>
        <tr>
        <td style="height: 242px" valign="top">
        <asp:GridView ID="gvSpeiseplan" runat="server" AutoGenerateColumns="False" CellPadding="4"
            DataKeyNames="datum,text" ForeColor="#333333" GridLines="None" AllowPaging="True" AllowSorting="True" PageSize="5" OnPageIndexChanging="gvSpeiseplan_PageIndexChanging">
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="tag" />
                <asp:BoundField DataField="datum" HeaderText="Datum" />
                <asp:BoundField DataField="text" HeaderText="Text" />
            </Columns>
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" VerticalAlign="Top" Wrap="True" />
            <EditRowStyle BackColor="#999999" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" Wrap="True" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        </asp:GridView>
        </td>
        <td style="height: 242px" valign="top">
           <script type="text/javascript"><!--
google_ad_client = "pub-3211012110888318";
/* 120x240, Erstellt 07.03.08 */
google_ad_slot = "0378747567";
google_ad_width = 120;
google_ad_height = 240;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script></td>
        </tr>
        
        </table>
            </ContentTemplate>
        </asp:UpdatePanel>
        &nbsp; &nbsp;
        &nbsp; &nbsp;
        <asp:ImageButton ID="imgbOutlook" runat="server" ImageUrl="~/outlook-2003.jpg" OnClick="imgbOutlook_Click" Width="40px" />
        <asp:ImageButton ID="imgbIcal" runat="server" ImageUrl="~/hero_ical.jpg" Width="40px" />&nbsp;
    </form>
</body>
</html>
