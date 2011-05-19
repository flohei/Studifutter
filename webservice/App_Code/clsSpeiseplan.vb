Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Globalization

Public Class clsSpeiseplan

    Public Function getSpeiseplanAktuell() As DataTable
        'noch auf Periode prüfen!!

        Dim wsSpeiseplan As mensa = New mensa()

        Dim ds As DataSet = New DataSet()
        ds.ReadXml(New System.IO.StringReader(wsSpeiseplan.getSpeiseplan()))

        Dim dt As DataTable = New DataTable()
        dt = ds.Tables(0)

        Dim dtSpeisenAktuell As DataTable = New DataTable("Speisen")

        dtSpeisenAktuell.Columns.Add("datum")
        dtSpeisenAktuell.Columns.Add("tag")
        dtSpeisenAktuell.Columns.Add("text")



        Dim dati As DateTime
        For Each dr As DataRow In dt.Rows
            Try
                Dim culture As CultureInfo = New CultureInfo("de-DE")

                dati = Convert.ToDateTime(dr(0), culture)

                If (dati >= Now.ToShortDateString) Then
                    Dim row As DataRow = dtSpeisenAktuell.NewRow()
                    row("datum") = dr(0)
                    row("tag") = dr(1)
                    row("text") = dr(2)
                    dtSpeisenAktuell.Rows.Add(row)
                End If
            Catch ex As Exception

            End Try
        Next

        Return dtSpeisenAktuell
    End Function


End Class
