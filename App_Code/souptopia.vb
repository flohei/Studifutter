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
Public Class souptopia
    Inherits System.Web.Services.WebService


    <WebMethod()> _
 Public Function getSpeiseplanSouptopia() As XmlDataDocument


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

        Dim sHTMLResult As String = ""
        Dim sURL As String = ""
        Dim doppelt As Integer = 0

       
        sURL = "http://souptopia.de/plan/plan.html"


        Dim periode As String = Now.Ticks()



        Try
            'Web Request 
            Dim HttpWReq As HttpWebRequest = WebRequest.Create(HttpUtility.UrlDecode(sURL))
            HttpWReq.KeepAlive = False


            'Timeout wird gesetzt in ms 
            HttpWReq.Timeout = 20000

            'Laden der Seite 
            Dim HttpWResp As HttpWebResponse = HttpWReq.GetResponse()

            'Dim stm As Stream = HttpWReq.GetRequestStream()
            Dim enc As Encoding = Encoding.GetEncoding(1252)


            'Abrufen der Seite und zuweisen 
            Dim x As StreamReader = New StreamReader(HttpWResp.GetResponseStream())

            sHTMLResult = x.ReadToEnd

            sHTMLResult = HttpUtility.HtmlDecode(sHTMLResult)





            'Schliesen des Stream Readers
            x.Close()

            'Ersetzen aller Anführungszeichen
            sHTMLResult = Replace(sHTMLResult, """", "")

            'Ersetzen von strong
            sHTMLResult = Replace(sHTMLResult, "<strong>", "")
            sHTMLResult = Replace(sHTMLResult, "</strong>", "")

            sHTMLResult = Replace(sHTMLResult, "<p>", "")
            sHTMLResult = Replace(sHTMLResult, "</p>", "")
            sHTMLResult = Replace(sHTMLResult, "<br>", "")
            sHTMLResult = Replace(sHTMLResult, "   ", "")
            sHTMLResult = Replace(sHTMLResult, "  ", "")
            sHTMLResult = Replace(sHTMLResult, "\n", "")

            Dim beschr1 As String
            Dim preis1 As String
            Dim preis1N As String
            Dim datum As String
            Dim beschr2 As String
            Dim preis2 As String
            Dim preis2N As String
            Dim beschr3 As String
            Dim preis3 As String
            Dim preis3N As String

            Dim split() As String
            Dim body As String = ""




            Try
                Dim i As Integer = 0
                Dim result As String = ""
                Dim sresult As String = ""
                Dim splitter() As String
                Dim a As Integer = 0




                'Auslesen der Woche

                result = sHTMLResult.Substring(sHTMLResult.IndexOf("SPEISEPLAN"), 200)

                splitter = result.Split("<")

                splitter = splitter(0).Split(" ")
                splitter = splitter(splitter.Length - 1).Split("-")

                Dim culture As CultureInfo = New CultureInfo("de-DE")
                '                Dim dati As DateTime
                '                Dim tag As String = ""
                '                dati = Convert.ToDateTime(datum, culture)

                Thread.CurrentThread.CurrentCulture = New CultureInfo("de-DE")


                Dim dStart As DateTime = Convert.ToDateTime(splitter(0) + Now.Year.ToString())
                Dim dEnde As DateTime = Convert.ToDateTime(splitter(1) + Now.Year.ToString())

                'Index nach Wochenkarte setzen




                result = sHTMLResult.Substring(sHTMLResult.IndexOf("WOCHENANGEBOT"))

                Dim wochenangebot As String = result.Substring(0, result.IndexOf("ce3"))




                While (DateTime.Compare(dStart, dEnde) <= 0)

                    result = result.Substring(result.IndexOf("ce3") + 3)


                    Dim text As String = result.Substring(0, result.IndexOf("ce7"))



                    While (text.Contains("ce4"))

                        text = text.Substring(getGericht(text, dStart.Date.ToShortDateString()))
                        Try
                            text = text.Substring(text.IndexOf("ce4"))
                        Catch ex As Exception
                            Exit While
                        End Try


                    End While

                    getWochenangebot(dStart, wochenangebot)

                    dStart = dStart.AddDays(1)


                End While


            Catch ex As Exception
            End Try




        Catch ex As Exception

            MsgBox(ex.Message)
        End Try

        Return dsFuttern



        'End If

    End Function

    Private Function getGericht(ByVal text As String, ByVal datum As String) As Integer

        Dim gericht As String
        Dim beschreibung As String
        Dim preisklein As String
        Dim preisgros As String

        'Dim splitter() As String = datum.Split(".")
        'datum = splitter(1) + "." + splitter(0) + "." + splitter(2)



        Dim row As DataRow = dtFutter.NewRow()
        row("datum") = datum


        gericht = getText(text.Substring(text.IndexOf("ce4")))
        row("speise") = gericht
        preisklein = getText(text.Substring(text.IndexOf("ce13")))
        preisgros = getText(text.Substring(text.IndexOf("ce17")))
        row("studipreis") = preisklein
        row("normalpreis") = preisgros
        Try
            Dim ireturn As Integer = 0
            If (text.IndexOf("ce5") < text.IndexOf("ce6") Or text.IndexOf("ce6") = -1) Then
                beschreibung = getText(text.Substring(text.IndexOf("ce5")))
                ireturn = text.IndexOf("ce5")
            Else
                beschreibung = getText(text.Substring(text.IndexOf("ce6")))
                ireturn = text.IndexOf("ce6")
            End If

            row("speise") = row("speise") + " - " + beschreibung

            dtFutter.Rows.Add(row)
            Return ireturn + 5

        Catch ex As Exception
            beschreibung = ""

            dtFutter.Rows.Add(row)
            Return text.IndexOf("ce17") + 5

        End Try




    End Function

    Private Sub getWochenangebot(ByVal tag As DateTime, ByVal text As String)
        'Dim iindex As Integer = text.IndexOf("WOCHENANGEBOT")
        'Dim result As String

        'result = text.Substring(iindex)
        'result = result.Substring(0, result.IndexOf("ce3"))


       

        Dim result As String = text



        Try
            While (result.Contains("ce4"))

                result = result.Substring(getGericht(result, tag.ToShortDateString()))

                result = result.Substring(result.IndexOf("ce4"))



            End While
        Catch ex As Exception


        End Try
    End Sub

    Private Function getText(ByVal text As String) As String

        text = text.Substring(text.IndexOf(">") + 1, text.IndexOf("<") - 1)

        Dim splitter() As String = text.Split("<")

        text = splitter(0)

        Return text

    End Function


End Class

