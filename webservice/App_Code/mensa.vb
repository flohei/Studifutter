Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports System.Net
Imports System.IO
Imports System.Globalization
Imports System.Xml

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class mensa
    Inherits System.Web.Services.WebService



    <WebMethod()> _
    Public Function getSpeiseplan() As String

        Dim dt As DataTable = getSpeisen().Tables("Speisen").Copy()
        Dim ds As New DataSet()
        ds.Tables.Add(dt)

        Return ds.GetXml()



    End Function

    <WebMethod()> _
   Public Function getSpeiseplanDatumText() As XmlDataDocument


        Dim dt As DataTable = getSpeisen().Tables("Speisen").Copy()
        dt.Columns.RemoveAt(1)
        Dim ds As New DataSet()
        ds.Tables.Add(dt)


        Return New XmlDataDocument(ds)





    End Function

    <WebMethod()> _
   Public Function getSpeiseplanDatumTextNeu() As XmlDataDocument


        Dim dt As DataTable = getSpeisen().Tables("Futter").Copy()
        Dim ds As New DataSet()
        ds.Tables.Add(dt)

        Return New XmlDataDocument(ds)


    End Function

    <WebMethod()> _
 Public Function getSpeiseplanMensateria() As XmlDataDocument


        Dim dt As DataTable = getSpeisen().Tables("Futter").Copy()
        Dim ds As New DataSet()
        ds.Tables.Add(dt)

        Return New XmlDataDocument(ds)


    End Function

    <WebMethod()> _
 Public Function getFutterPlaces() As XmlDataDocument

        Dim clsDB As clsData = New clsData()



        Dim dt As DataTable = clsDB.getFutterPlaces.Copy()
        Dim ds As New DataSet()
        ds.Tables.Add(dt)

        Return New XmlDataDocument(ds)


    End Function



    Private Function switchDay(ByVal day As String) As String
        Dim ret As String = ""

        Select Case day
            Case "Monday"
                ret = "Montag"

            Case "Tuesday"
                ret = "Dienstag"

            Case "Wednesday"
                ret = "Mittwoch"


            Case "Thursday"
                ret = "Donnerstag"


            Case "Friday"
                ret = "Freitag"

            Case "Saturday"
                ret = "Samstag"


            Case "Sunday"
                ret = "Sonntag"

        End Select


        Return ret

    End Function


    Public Function getSpeisen() As DataSet


        ''übeprüfen, ob neue Daten gebraucht werden
        'If checkNeuLaden() = False Then
        '    'nichts machen
        'Else


        'alte Version
        Dim dtSpeisen As DataTable = New DataTable("Speisen")
        dtSpeisen.Columns.Add("datum")
        dtSpeisen.Columns.Add("tag")
        dtSpeisen.Columns.Add("text")

        'neue Version

        Dim dtFuttern As DataTable = New DataTable("Futtern")
        Dim dtTag As DataTable = New DataTable("Tag")
        dtTag.Columns.Add("datum")
        Dim dtFutter As DataTable = New DataTable("Futter")
        dtFutter.Columns.Add("datum")
        dtFutter.Columns.Add("speise")
        dtFutter.Columns.Add("studipreis")
        dtFutter.Columns.Add("normalpreis")



        Dim dsFuttern As DataSet = New DataSet("Futtern")

        dsFuttern.Tables.Add(dtSpeisen)
        dsFuttern.Tables.Add(dtFutter)

        Dim sHTMLResult As String = ""
        Dim sURL As String = ""
        Dim doppelt As Integer = 0

        'überprüfen, ob es eine neue periode gibt!

        'dazu neues feld periode in der tabelle.
        'für die periode einfach den aktuellen monat nehmen

        sURL = "http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-n-mensateria.shtml"


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
            Dim x As StreamReader = New StreamReader(HttpWResp.GetResponseStream(), enc)

            sHTMLResult = x.ReadToEnd

            sHTMLResult = HttpUtility.HtmlDecode(sHTMLResult)





            'Schliesen des Stream Readers
            x.Close()


            'sHTMLResult = Replace(sHTMLResult, "<font", "")
            'sHTMLResult = Replace(sHTMLResult, "class=", "")
            'sHTMLResult = Replace(sHTMLResult, "font62", "")
            'sHTMLResult = Replace(sHTMLResult, "4513>", "")
            'sHTMLResult = Replace(sHTMLResult, "MSC", "")
            'sHTMLResult = Replace(sHTMLResult, "</font>", "")
            'sHTMLResult = Replace(sHTMLResult, "<font", "")
            'sHTMLResult = Replace(sHTMLResult, "class=>", "")
            'sHTMLResult = Replace(sHTMLResult, "font52", "")
            'sHTMLResult = Replace(sHTMLResult, "4513>", "")

           
           

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


                'Für alle Tage im Monat die Schleife durchlaufen (Tage Max < 30!)
                For c As Integer = 0 To 30

                    Try
                        'Suchen nach der Startposition "Essen 1"
                        result = sHTMLResult.Substring(sHTMLResult.IndexOf("Essen 1"), 2000)
                        'Weiterschalten für die nächste Suche
                        sHTMLResult = sHTMLResult.Substring(sHTMLResult.IndexOf("Essen 1") + 1)

                        '"eindeutiges" Zeichen definieren
                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")
                        If (splitter(1)(0).ToString() = "<") Then
                            For i = 1 To splitter.Length - 1
                                If (splitter(i).Contains("class") Or splitter(i).Contains("MSC") Or splitter(i).Contains("href") Or splitter(i).Contains("strong")) Then
                                Else
                                    splitter(1) = splitter(i)
                                    Exit For

                                End If
                            Next

                        End If
                        splitter = splitter(1).Split("<")
                        beschr1 = splitter(0)
                        'beschr1 = beschr1.Remove(beschr1.Length - 2, 2)

                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")

                        splitter = splitter(1).Split("<")
                        preis1 = splitter(0)

                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")
                        splitter = splitter(1).Split("<")
                        preis1N = splitter(0)
                        'preis1 = preis1.Remove(preis1.Length - 2, 2)


                        'sresult = result.Substring(result.IndexOf("div align="))
                        'result = result.Substring(result.IndexOf("div align=") + 1)

                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")
                        splitter = splitter(1).Split("<")
                        datum = splitter(0)
                        split = datum.Split(" ")
                        If split.Length = 1 Then
                            split = datum.Split(".")
                            datum = split(1) & "." & split(2) & "." & split(3)
                        Else
                            datum = split(1)
                        End If


                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)
                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")
                        If (splitter(1)(0).ToString() = "<") Then
                            For i = 1 To splitter.Length - 1
                                If (splitter(i).Contains("class") Or splitter(i).Contains("MSC") Or splitter(i).Contains("href") Or splitter(i).Contains("strong")) Then
                                Else
                                    splitter(1) = splitter(i)
                                    Exit For

                                End If
                            Next

                        End If
                        splitter = splitter(1).Split("<")
                        beschr2 = splitter(0)
                        'beschr2 = beschr2.Remove(beschr2.Length - 2, 2)

                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")
                        splitter = splitter(1).Split("<")
                        preis2 = splitter(0)
                        'preis2 = preis2.Remove(preis2.Length - 2, 2)
                        'preis2 = preis2 & "€"

                        'sresult = result.Substring(result.IndexOf("div align="))
                        'result = result.Substring(result.IndexOf("div align=") + 1)

                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")
                        splitter = splitter(1).Split("<")
                        preis2N = splitter(0)


                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)
                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)
                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)


                        splitter = sresult.Split(">")
                        If (splitter(1)(0).ToString() = "<") Then
                            For i = 1 To splitter.Length - 1
                                If (splitter(i).Contains("class") Or splitter(i).Contains("MSC") Or splitter(i).Contains("href") Or splitter(i).Contains("strong")) Then
                                Else
                                    splitter(1) = splitter(i)
                                    Exit For

                                End If
                            Next

                        End If
                        splitter = splitter(1).Split("<")

                        beschr3 = splitter(0)
                        'beschr3 = beschr3.Remove(beschr3.Length - 2, 2)

                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")
                        splitter = splitter(1).Split("<")
                        preis3 = splitter(0)
                        'preis3 = preis3.Remove(preis3.Length - 6, 6)
                        'preis3 = preis3 & "€"

                        sresult = result.Substring(result.IndexOf("div align="))
                        result = result.Substring(result.IndexOf("div align=") + 1)

                        splitter = sresult.Split(">")
                        splitter = splitter(1).Split("<")
                        preis3N = splitter(0)

                        If (beschr1 = "") Then
                            beschr1 = "kein Gericht vorhanden"
                        End If
                        If (preis1 = "") Then
                            preis1 = "?€"
                        End If
                        If (beschr2 = "") Then
                            beschr2 = "kein Gericht vorhanden"
                        End If
                        If (preis2 = "") Then
                            preis2 = "?€"
                        End If
                        If (beschr3 = "") Then
                            beschr3 = "kein Gericht vorhanden"
                        End If
                        If (preis3 = "") Then
                            preis3 = "?€"
                        End If

                        'Füllen des Kalendereintrags
                        body = ""
                        body = beschr1 & " " & preis1 & vbCrLf & beschr2 & " " & preis2 & vbCrLf & beschr3 & " " & preis3



                        Dim culture As CultureInfo = New CultureInfo("de-DE")
                        Dim dati As DateTime
                        Dim tag As String = ""
                        dati = Convert.ToDateTime(datum, culture)
                        tag = dati.DayOfWeek.ToString()
                        tag = switchDay(tag)


                        'alte version
                        Dim row As DataRow
                        row = dtSpeisen.NewRow()

                        row("datum") = datum
                        row("tag") = tag
                        row("text") = body
                        dtSpeisen.Rows.Add(row)

                        'neue version

                        row = dtFutter.NewRow()
                        row("datum") = datum
                        row("speise") = beschr1
                        row("studipreis") = preis1
                        row("normalpreis") = preis1N

                        dtFutter.Rows.Add(row)


                        row = dtFutter.NewRow()
                        row("datum") = datum
                        row("speise") = beschr2
                        row("studipreis") = preis2
                        row("normalpreis") = preis2N

                        dtFutter.Rows.Add(row)

                        row = dtFutter.NewRow()
                        row("datum") = datum
                        row("speise") = beschr3
                        row("studipreis") = preis3
                        row("normalpreis") = preis3N

                        dtFutter.Rows.Add(row)




                    Catch ex As Exception

                    End Try

                Next

            Catch ex As Exception
            End Try




        Catch ex As Exception

            MsgBox(ex.Message)
        End Try

        Return dsFuttern



        'End If

    End Function


End Class
