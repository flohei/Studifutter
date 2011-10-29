Imports System.IO
Imports System.Text
Imports system.Net
Imports System.Xml

Imports System
Imports System.Data
Imports System.Globalization




Partial Class speiseplan
    Inherits System.Web.UI.Page
    Dim data As DataTable
    Dim clsSpeisen As clsSpeiseplan = New clsSpeiseplan()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        If IsPostBack = False Then
            Cache("data") = clsSpeisen.getSpeiseplanAktuell()

        End If

        If (Cache("data") Is Nothing) Then
            Cache("data") = clsSpeisen.getSpeiseplanAktuell()
        End If

        gvSpeiseplan.DataSource = Cache("data")
        gvSpeiseplan.DataBind()
    End Sub


    Protected Sub gvSpeiseplan_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSpeiseplan.RowDataBound
        Try
            e.Row.Cells(2).Text = Replace(e.Row.Cells(2).Text.Trim, "€", "€ <br />")

        Catch
        End Try

    End Sub


    'Protected Sub imgbOutlook_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgbOutlook.Click


    '    Dim datum As String
    '    Dim text As String
    '    Dim splitter() As String
    '    Dim sdatum As String

    '    'Response.AddHeader("Content-Disposition", "attachment; filename=test.ics")
    '    'Response.ContentType = "text/plain"

    '    'Response.Write("BEGIN:VCALENDAR")
    '    'Response.Write(vbCrLf)
    '    'Response.Write("PRODID:-//Microsoft Corporation//Outlook MIMEDIR//EN")
    '    'Response.Write(vbCrLf)
    '    'Response.Write("VERSION:1.0")

    '    'For i As Integer = 0 To 4
    '    '    Try
    '    '        datum = gvSpeiseplan.DataKeys(i + gvSpeiseplan.PageIndex).Values("datum")
    '    '        text = gvSpeiseplan.DataKeys(i + gvSpeiseplan.PageIndex).Values("text")


    '    '        splitter = datum.Split(" ")
    '    '        splitter = splitter(0).Split(".")


    '    '        sdatum = splitter(2) + splitter(1) + splitter(0)


    '    '        Response.Write(vbCrLf)

    '    '        Response.Write("BEGIN:VEVENT")
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("ORGANIZER:MAILTO:msevent@microsoft.com")
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("DTSTART:" + sdatum + "T130000Z")
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("DTEND:" + sdatum + "T131500Z")
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("LOCATION;CHARSET=UTF-8:Mensa")
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("DESCRIPTION;CHARSET=UTF-8:" + text)
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("SUMMARY;CHARSET=UTF-8:Speiseplan")
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("CATEGORIES:Business")
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("PRIORITY:0")
    '    '        Response.Write(vbCrLf)
    '    '        Response.Write("END:VEVENT")
    '    '        If i = 4 Then
    '    '            Response.Write(vbCrLf)
    '    '        End If

    '    '    Catch
    '    '        Exit For
    '    '    End Try
    '    'Next




    '    For i As Integer = 0 To 4
    '        Try
    '            datum = gvSpeiseplan.DataKeys(i).Values("datum")
    '            text = gvSpeiseplan.DataKeys(i).Values("text")


    '            splitter = datum.Split(" ")
    '            splitter = splitter(0).Split(".")


    '            sdatum = splitter(2) + splitter(1) + splitter(0)


    '            Response.AddHeader("Content-Disposition", "attachment; filename=" & sdatum.Replace(".", "") & ".ics")
    '            Response.ContentType = "text/plain"

    '            Response.Write("BEGIN:VCALENDAR")
    '            Response.Write(vbCrLf)
    '            Response.Write("PRODID:-//Microsoft Corporation//Outlook MIMEDIR//EN")
    '            Response.Write(vbCrLf)
    '            Response.Write("VERSION:1.0")
    '            Response.Write(vbCrLf)
    '            Response.Write("BEGIN:VEVENT")
    '            Response.Write(vbCrLf)
    '            Response.Write("ORGANIZER:MAILTO:msevent@microsoft.com")
    '            Response.Write(vbCrLf)
    '            Response.Write("DTSTART:" + sdatum + "T130000Z")
    '            Response.Write(vbCrLf)
    '            Response.Write("DTEND:" + sdatum + "T131500Z")
    '            Response.Write(vbCrLf)
    '            Response.Write("LOCATION;CHARSET=UTF-8:Mensa")
    '            Response.Write(vbCrLf)
    '            Response.Write("DESCRIPTION;CHARSET=UTF-8:" + text)
    '            Response.Write(vbCrLf)
    '            Response.Write("SUMMARY;CHARSET=UTF-8:Speiseplan")
    '            Response.Write(vbCrLf)
    '            Response.Write("CATEGORIES:Business")
    '            Response.Write(vbCrLf)
    '            Response.Write("PRIORITY:0")
    '            Response.Write(vbCrLf)
    '            Response.Write("END:VEVENT")
    '            Response.Write(vbCrLf)
    '            Response.Write("END:VCALENDAR")
    '            Response.End()

    '        Catch ex As Exception

    '        End Try
    '    Next





    'End Sub

    Protected Sub gvSpeiseplan_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs)

        gvSpeiseplan.PageIndex = e.NewPageIndex
        gvSpeiseplan.DataSource = Cache("data")
        gvSpeiseplan.DataBind()
    End Sub

    Protected Sub gvSpeiseplan_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim clsvc As vCalendar = New vCalendar()
        Dim vevent As vCalendar.vEvent = New vCalendar.vEvent()

        Dim culture As CultureInfo = New CultureInfo("de-DE")
        Dim dati As DateTime
        Dim tag As String = ""


        Dim datum As String = gvSpeiseplan.SelectedDataKey("datum")
        Dim sdatum As String = datum
        Dim Text As String = gvSpeiseplan.SelectedDataKey("text")
        Text = Text.Replace(ControlChars.NewLine, "")








        vevent.Description = Text
        vevent.Location = "Mensa"
        vevent.Summary = "Lunch"
        datum = sdatum + " 13:00:00"
        vevent.DTStart = Convert.ToDateTime(datum, culture)
        datum = sdatum + " 13:30:00"
        vevent.DTEnd = Convert.ToDateTime(datum, culture)
        vevent.URL = ""


        clsvc.Events.Add(vevent)

        Response.Clear()
        Response.AddHeader("Content-Disposition", "attachment; filename=" & sdatum.Replace(".", "") & ".ics")
        Response.ContentType = "text/plain"

        Response.Write(clsvc.ToString())
        Response.End()

    End Sub

    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click

        Try

       
            If (Cache("data") Is Nothing) Then
                Cache("data") = clsSpeisen.getSpeiseplanAktuell()
            End If

            Dim dt As DataTable = Cache("data")

            Dim clsvc As vCalendar = New vCalendar()
            Dim vevent As vCalendar.vEvent
            Dim dati As DateTime
            Dim datum As String
            Dim sdatum As String
            Dim Text As String
            Dim culture As CultureInfo = New CultureInfo("de-DE")

            For Each dr As DataRow In dt.Rows

                vevent = New vCalendar.vEvent()

                datum = dr("datum")
                sdatum = datum

                Text = dr("text")
                Text = Text.Replace(ControlChars.NewLine, "")

                datum = datum + " 13:00:00"
                dati = Convert.ToDateTime(datum, culture)

                vevent.Description = Text
                vevent.Location = "Mensa"
                vevent.Summary = "Speiseplan Mensa"
                vevent.DTEnd = dati
                vevent.DTStart = dati
                vevent.URL = ""


                clsvc.Events.Add(vevent)

            Next





            Response.Clear()
            Response.AddHeader("Content-Disposition", "attachment; filename=" & "MensaSpeiseplan" & ".ics")
            Response.ContentType = "text/plain"

            Response.Write(clsvc.ToString())
            Response.End()

        Catch ex As Exception

        End Try

    End Sub
End Class
