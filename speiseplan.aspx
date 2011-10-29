<%@ Page Language="VB" AutoEventWireup="false" CodeFile="speiseplan.aspx.vb" Inherits="speiseplan" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Mensa Speiseplan</title>
</head>
<body bgcolor="#a9acaf">
    <form id="form1" runat="server">
    <div>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                    SelectCommand="SELECT DISTINCT [Periode] FROM [Speiseplan] ORDER BY [Periode] DESC">
                </asp:SqlDataSource>
                <br />
                <asp:ImageButton ID="ImageButton1" runat="server" Height="30px" 
                    ImageUrl="~/ical_icon.gif" Visible="False" />
                <br />
        <asp:GridView ID="gvSpeiseplan" runat="server" AutoGenerateColumns="False" CellPadding="4"
            DataKeyNames="datum,text" ForeColor="#333333" GridLines="None" AllowPaging="True" AllowSorting="True" PageSize="5" OnPageIndexChanging="gvSpeiseplan_PageIndexChanging" OnSelectedIndexChanged="gvSpeiseplan_SelectedIndexChanged">
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <Columns>
                <asp:BoundField DataField="tag" HeaderText="Tag" >
                </asp:BoundField>
                <asp:BoundField DataField="datum" HeaderText="Datum">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="text" HeaderText="Futter" />
                <asp:CommandField ButtonType="Image" NewImageUrl="~/ical_icon.gif" SelectImageUrl="~/ical_icon.gif"
                    ShowSelectButton="True" >
                    <ControlStyle Height="30px" />
                    <ItemStyle Height="20px" />
                </asp:CommandField>
            </Columns>
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" VerticalAlign="Top" Wrap="True" />
            <EditRowStyle BackColor="#999999" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" Wrap="True" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        </asp:GridView>
        </div>
    </form>
</body>
</html>
