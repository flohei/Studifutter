Imports System.IO
Imports System.Text
Imports system.Net
Imports System.Xml

Imports System
Imports System.Data




Partial Class speiseplan
    Inherits System.Web.UI.Page
    Dim data As DataTable
    Dim periode As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim clsdb As clsData = New clsData()

        If IsPostBack = False Then
            Cache("data") = clsdb.getSpeiseplanPeriode(ddlPeriode.SelectedValue)
            Tage()

        End If

        If (Cache("data") Is Nothing) Then
            Cache("data") = clsdb.getSpeiseplanPeriode(ddlPeriode.SelectedValue)
        End If

        gvSpeiseplan.DataSource = Cache("data")
            gvSpeiseplan.DataBind()
    End Sub


    Public Sub Tage()
        Dim sHTMLResult As String = ""
        Dim sURL As String = ""
        Dim doppelt As Integer = 0

        'überprüfen, ob es eine neue periode gibt!

        'dazu neues feld periode in der tabelle.
        'für die periode einfach den aktuellen monat nehmen

        sURL = "http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-n-mensateria.shtml"

        Cache("periode") = ""



        Try
            'Web Request 
            Dim HttpWReq As HttpWebRequest = WebRequest.Create(sURL)
            HttpWReq.KeepAlive = False


            'Timeout wird gesetzt in ms 
            HttpWReq.Timeout = 20000

            'Laden der Seite 
            Dim HttpWResp As HttpWebResponse = HttpWReq.GetResponse()

            'Abrufen der Seite und zuweisen 
            Dim x As StreamReader = New StreamReader(HttpWResp.GetResponseStream(), Encoding.UTF7)

            sHTMLResult = x.ReadToEnd

            'Schliesen des Stream Readers
            x.Close()

            'Ersetzen aller Anführungszeichen
            sHTMLResult = Replace(sHTMLResult, """", "")

            Dim beschr1 As String
            Dim preis1 As String
            Dim datum As String
            Dim beschr2 As String
            Dim preis2 As String
            Dim beschr3 As String
            Dim preis3 As String

            Dim split() As String
            Dim body As String = ""

            Dim clsdb As clsData = New clsData()

            Try

                Dim i As Integer = 0
                Dim result As String = ""
                Dim sresult As String = ""
                Dim splitter() As String
                Dim a As Integer = 0

                'Für alle Tage im Monat die Schleife durchlaufen (Tage Max < 30!)
                For c As Integer = 0 To 30

                    'Suchen nach der Startposition "Essen 1"
                    result = sHTMLResult.Substring(sHTMLResult.IndexOf("Essen 1"), 2000)
                    'Weiterschalten für die nächste Suche
                    sHTMLResult = sHTMLResult.Substring(sHTMLResult.IndexOf("Essen 1") + 1)

                    '"eindeutiges" Zeichen definieren
                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)

                    splitter = sresult.Split(">")
                    splitter = splitter(1).Split("<")
                    beschr1 = splitter(0)
                    beschr1 = beschr1.Remove(beschr1.Length - 2, 2)

                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)

                    splitter = sresult.Split(">")
                    splitter = splitter(1).Split("<")
                    preis1 = splitter(0)
                    preis1 = preis1.Remove(preis1.Length - 2, 2)
                    preis1 = preis1 & "€"

                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)

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
                    splitter = splitter(1).Split("<")
                    beschr2 = splitter(0)
                    beschr2 = beschr2.Remove(beschr2.Length - 2, 2)

                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)

                    splitter = sresult.Split(">")
                    splitter = splitter(1).Split("<")
                    preis2 = splitter(0)
                    preis2 = preis2.Remove(preis2.Length - 2, 2)
                    preis2 = preis2 & "€"

                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)


                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)
                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)
                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)
                    splitter = sresult.Split(">")
                    splitter = splitter(1).Split("<")
                    beschr3 = splitter(0)
                    beschr3 = beschr3.Remove(beschr3.Length - 2, 2)

                    sresult = result.Substring(result.IndexOf("div align="))
                    result = result.Substring(result.IndexOf("div align=") + 1)

                    splitter = sresult.Split(">")
                    splitter = splitter(1).Split("<")
                    preis3 = splitter(0)
                    preis3 = preis3.Remove(preis3.Length - 2, 2)
                    preis3 = preis3 & "€"

                    'Füllen des Kalendereintrags
                    body = ""
                    body = beschr1 & " " & preis1 & vbCrLf & beschr2 & " " & preis2 & vbCrLf & beschr3 & " " & preis3


                    If Cache("periode") = "" Then
                        Cache("periode") = clsdb.toPeriode(datum)
                    End If


                    If clsdb.setSpeiseplan(datum, body, Cache("periode")) = False Then
                        doppelt = doppelt + 1
                        If doppelt >= 3 Then
                            Exit For
                        End If
                    End If

                Next

            Catch ex As Exception

            End Try

            If doppelt < 3 Then
                Cache("data") = clsdb.getSpeiseplanPeriode(Cache("periode"))
                gvSpeiseplan.DataSource = Cache("data")
                gvSpeiseplan.DataBind()
            End If

        Catch ex As Exception

            MsgBox(ex.Message)
        End Try

       



    End Sub

    Protected Sub gvSpeiseplan_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSpeiseplan.RowDataBound
        Try
            e.Row.Cells(2).Text = Replace(e.Row.Cells(2).Text.Trim, "€", "€ <br />")
            e.Row.Cells(1).Text = Replace(e.Row.Cells(1).Text.Trim, " 00:00:00", " ")
        Catch
        End Try

    End Sub

    Protected Sub ddlPeriode_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim clsdb As clsData = New clsData()
        Cache("data") = clsdb.getSpeiseplanPeriode(ddlPeriode.SelectedValue)
        gvSpeiseplan.DataSource = data
        gvSpeiseplan.DataBind()
    End Sub

    Protected Sub imgbOutlook_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgbOutlook.Click


        Dim datum As String
        Dim text As String
        Dim splitter() As String
        Dim sdatum As String

        'Response.AddHeader("Content-Disposition", "attachment; filename=test.ics")
        'Response.ContentType = "text/plain"

        'Response.Write("BEGIN:VCALENDAR")
        'Response.Write(vbCrLf)
        'Response.Write("PRODID:-//Microsoft Corporation//Outlook MIMEDIR//EN")
        'Response.Write(vbCrLf)
        'Response.Write("VERSION:1.0")

        'For i As Integer = 0 To 4
        '    Try
        '        datum = gvSpeiseplan.DataKeys(i + gvSpeiseplan.PageIndex).Values("datum")
        '        text = gvSpeiseplan.DataKeys(i + gvSpeiseplan.PageIndex).Values("text")


        '        splitter = datum.Split(" ")
        '        splitter = splitter(0).Split(".")


        '        sdatum = splitter(2) + splitter(1) + splitter(0)


        '        Response.Write(vbCrLf)

        '        Response.Write("BEGIN:VEVENT")
        '        Response.Write(vbCrLf)
        '        Response.Write("ORGANIZER:MAILTO:msevent@microsoft.com")
        '        Response.Write(vbCrLf)
        '        Response.Write("DTSTART:" + sdatum + "T130000Z")
        '        Response.Write(vbCrLf)
        '        Response.Write("DTEND:" + sdatum + "T131500Z")
        '        Response.Write(vbCrLf)
        '        Response.Write("LOCATION;CHARSET=UTF-8:Mensa")
        '        Response.Write(vbCrLf)
        '        Response.Write("DESCRIPTION;CHARSET=UTF-8:" + text)
        '        Response.Write(vbCrLf)
        '        Response.Write("SUMMARY;CHARSET=UTF-8:Speiseplan")
        '        Response.Write(vbCrLf)
        '        Response.Write("CATEGORIES:Business")
        '        Response.Write(vbCrLf)
        '        Response.Write("PRIORITY:0")
        '        Response.Write(vbCrLf)
        '        Response.Write("END:VEVENT")
        '        If i = 4 Then
        '            Response.Write(vbCrLf)
        '        End If

        '    Catch
        '        Exit For
        '    End Try
        'Next



       
        For i As Integer = 0 To 4
            Try
                datum = gvSpeiseplan.DataKeys(i).Values("datum")
                text = gvSpeiseplan.DataKeys(i).Values("text")


                splitter = datum.Split(" ")
                splitter = splitter(0).Split(".")


                sdatum = splitter(2) + splitter(1) + splitter(0)


                Response.AddHeader("Content-Disposition", "attachment; filename=" & sdatum.Replace(".", "") & ".ics")
                Response.ContentType = "text/plain"

                Response.Write("BEGIN:VCALENDAR")
                Response.Write(vbCrLf)
                Response.Write("PRODID:-//Microsoft Corporation//Outlook MIMEDIR//EN")
                Response.Write(vbCrLf)
                Response.Write("VERSION:1.0")
                Response.Write(vbCrLf)
                Response.Write("BEGIN:VEVENT")
                Response.Write(vbCrLf)
                Response.Write("ORGANIZER:MAILTO:msevent@microsoft.com")
                Response.Write(vbCrLf)
                Response.Write("DTSTART:" + sdatum + "T130000Z")
                Response.Write(vbCrLf)
                Response.Write("DTEND:" + sdatum + "T131500Z")
                Response.Write(vbCrLf)
                Response.Write("LOCATION;CHARSET=UTF-8:Mensa")
                Response.Write(vbCrLf)
                Response.Write("DESCRIPTION;CHARSET=UTF-8:" + text)
                Response.Write(vbCrLf)
                Response.Write("SUMMARY;CHARSET=UTF-8:Speiseplan")
                Response.Write(vbCrLf)
                Response.Write("CATEGORIES:Business")
                Response.Write(vbCrLf)
                Response.Write("PRIORITY:0")
                Response.Write(vbCrLf)
                Response.Write("END:VEVENT")
                Response.Write(vbCrLf)
                Response.Write("END:VCALENDAR")
                Response.End()

            Catch ex As Exception

            End Try
        Next





    End Sub

    Protected Sub gvSpeiseplan_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs)

        gvSpeiseplan.PageIndex = e.NewPageIndex
        gvSpeiseplan.DataSource = Cache("data")
        gvSpeiseplan.DataBind()
    End Sub
End Class
