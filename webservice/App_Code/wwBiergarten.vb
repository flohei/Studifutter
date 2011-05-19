Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports System.Net
Imports System.IO
Imports System.Globalization
Imports System.Xml
Imports System.Threading


<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class wwBiergarten
     Inherits System.Web.Services.WebService


    <WebMethod()> _
 Public Function getSpeiseplanwwBiergarten() As XmlDataDocument


        Dim dt As DataTable = getSpeisen().Tables("Futter").Copy()
        Dim ds As New DataSet()
        ds.Tables.Add(dt)

        Return New XmlDataDocument(ds)


    End Function


    Dim dtFutter As DataTable = New DataTable("Futter")


    Public Function getSpeisen() As DataSet





        dtFutter.Columns.Add("datum")
        dtFutter.Columns.Add("speise")
        dtFutter.Columns.Add("studipreis")
        dtFutter.Columns.Add("normalpreis")



        Dim dsFuttern As DataSet = New DataSet("Futtern")

        dsFuttern.Tables.Add(dtFutter)

     
        Thread.CurrentThread.CurrentCulture = New CultureInfo("de-DE")


        Dim dStart As DateTime = Now.Date
        Dim dEnde As DateTime = dStart.AddDays(31)

        While (DateTime.Compare(dStart, dEnde) <= 0)



            setGerichte(dStart.ToShortDateString(), "3 Bratwürste im Weggla")
            setGerichte(dStart.ToShortDateString(), "3 Bratwürste mit Kartoffelsalat oder Sauerkraut")
            setGerichte(dStart.ToShortDateString(), "6 Bratwürste mit Kartoffelsalat oder Sauerkraut")
            setGerichte(dStart.ToShortDateString(), "Grillfleisch mit Pommes Frittes")
            setGerichte(dStart.ToShortDateString(), "Grillfleisch im Weggla")
            setGerichte(dStart.ToShortDateString(), "Grillfleisch mit Kartoffelsalat oder Sauerkraut")
            setGerichte(dStart.ToShortDateString(), "Pommes in der Tüte")
            setGerichte(dStart.ToShortDateString(), "Pommes auf dem Teller")
            setGerichte(dStart.ToShortDateString(), "Krustenbrot mit Apfelgriebenschmalz")
            setGerichte(dStart.ToShortDateString(), "Krustenbrot mit ges. Butter u. Schnittlauch")
            setGerichte(dStart.ToShortDateString(), "Krustenbrot mit Tomate")
            setGerichte(dStart.ToShortDateString(), "Krustenbrot mit Vesperhack")
            setGerichte(dStart.ToShortDateString(), "Krustenbrot mit gekochtem Ei")
            setGerichte(dStart.ToShortDateString(), "Lachsbagel mit Rucolla")
            setGerichte(dStart.ToShortDateString(), "Obatzter mit Krustenbrot")
            setGerichte(dStart.ToShortDateString(), "Sülze mit Musik u. Frühlingszwiebeln")
            setGerichte(dStart.ToShortDateString(), "Stadtwurst mit Musik u. Krustenbrot")
            setGerichte(dStart.ToShortDateString(), "Schweizer(Wurstsalat)")
            setGerichte(dStart.ToShortDateString(), "Geräucherte Bratwürste mit Krustenbrot")
            setGerichte(dStart.ToShortDateString(), "Vinschgerl mit ger. Schinkenstreifen")
            setGerichte(dStart.ToShortDateString(), "Vinschgerl mit herzh. Emmentaler")
            setGerichte(dStart.ToShortDateString(), "Vinschgerl mit Mozzarella u. Tomate")
            setGerichte(dStart.ToShortDateString(), "Wies'n Brotzeitbrettl (1-2 Pers.)")
            setGerichte(dStart.ToShortDateString(), "1/2 Meter Wies'n Brotzeit (für 2-4 Pers.)")
            setGerichte(dStart.ToShortDateString(), "Wies'n Käsbrettl (Für 1-2 Pers.)")
            setGerichte(dStart.ToShortDateString(), "Ciabatta mit Mozzarella u. Tomate")
            setGerichte(dStart.ToShortDateString(), "Ger. Forelle mit Krustenbrot u. Meerettich")
            setGerichte(dStart.ToShortDateString(), "Knackiger(Wies)'n Sommer-Salat")
            setGerichte(dStart.ToShortDateString(), "Butterbrez'n")
            setGerichte(dStart.ToShortDateString(), "Brez'n mit Camenbert o. Emmentaler")

            dStart = dStart.AddDays(1)


        End While




        Return dsFuttern



        'End If

    End Function

    Private Sub setGerichte(ByVal datum As String, ByVal speise As String)





        Dim row As DataRow = dtFutter.NewRow()
        row("datum") = datum
        row("speise") = speise
        row("studipreis") = ""
        row("normalpreis") = ""

        dtFutter.Rows.Add(row)


    End Sub

   


End Class


