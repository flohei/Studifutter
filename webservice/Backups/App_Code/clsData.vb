Imports System
Imports System.Data
Imports System.Data.SqlClient

Public Class clsData

    Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString
    Dim con As New SqlConnection(connStr)
    Dim cmd As SqlCommand = New SqlCommand




    Public Function getDataSet(ByVal sql As String, ByVal name As String) As DataSet
        Dim ds As New DataSet

        'dbconnection()

        cmd.Connection = con
        cmd.CommandText = sql

        Dim da As New SqlDataAdapter

        Try
            da.SelectCommand = cmd
            da.Fill(ds, name)

        Catch ex As Exception

        Finally
            cmd.Connection.Close()
        End Try

        Return ds



    End Function

    Public Function getDataTable(ByVal sql As String, ByVal name As String) As DataTable
        Dim dt As New DataTable
        Dim ds As New DataSet

        'dbconnection()

        cmd.Connection = con
        cmd.CommandText = sql

        Dim da As New SqlDataAdapter

        Try
            da.SelectCommand = cmd
            da.Fill(ds, name)

            dt = ds.Tables(0)
            ds.Tables.Clear()
        Catch ex As Exception

        Finally
            cmd.Connection.Close()
        End Try

        Return dt

    End Function

    Public Function getOneData(ByVal sql As String)

        'dbconnection()

        cmd.Connection = con
        cmd.CommandText = sql

        Dim back As String = -1

        Try
            cmd.Connection.Open()

            back = cmd.ExecuteScalar

        Catch ex As Exception
        Finally
            cmd.Connection.Close()
        End Try

        Return back
    End Function

    Public Function setData(ByVal sql As String) As Boolean


        'dbconnection()

        cmd.Connection = con
        cmd.CommandText = sql

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()

        Catch ex As Exception
            Return False
        Finally
            cmd.Connection.Close()
        End Try

        Return True
    End Function


    Public Function stringReplace(ByVal str As String) As String

        str = str.Replace("&quot", "")

        Dim test As String = "ABCDEFGHIHKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzß1234567890€,.-ÄäüÜöÖ"
        Dim text2 As String
        For i As Integer = 0 To str.Length - 1
            If test.IndexOf(str(i)) < 0 Then
                text2 = text2 + " "
            Else
                text2 = text2 + str(i)
            End If
        Next

        str = text2

        Return str
    End Function

    Public Function getSpeiseplanPeriode(ByVal periode As String) As DataTable
        'noch auf Periode prüfen!!

        If periode = "" Then
            If Now.Month < 10 Then
                periode = periode & "0" & Now.Month & "/" & Replace(Now.Year, "20", "")
            Else
                periode = periode & Now.Month & "/" & Replace(Now.Year, "20", "")
            End If
        End If

        Dim dt As DataTable = getDataTable("select text as tag,datum, text from speiseplan where periode='" + periode + "'", "speiseplan")
        Dim dati As DateTime
        For Each dr As DataRow In dt.Rows
            dati = Convert.ToDateTime(dr(1))
            dr(0) = dati.DayOfWeek.ToString()
        Next

        Return dt
    End Function

    Public Function getPerioden() As DataTable
        Dim dt As DataTable = getDataTable("select distinct periode from speiseplan order by periode asc", "speiseplan")
        Return dt
    End Function

    Public Function checkVorhanden(ByVal datum As String) As Boolean

        Dim count As Integer = Convert.ToInt32(getOneData("select count(datum) from speiseplan where datum='" + datum + "'"))
        If count >= 1 Then
            Return True
        Else
            Return False
        End If

    End Function

    Public Function toPeriode(ByVal datum As String) As String
        Dim splitter() As String = datum.Split(".")
        Return splitter(1) & "/" & splitter(2)
    End Function

    Public Function setSpeiseplan(ByVal datum As String, ByVal text As String, ByVal periode As String) As Boolean
        If checkVorhanden(datum) = False Then
            setData("insert into speiseplan(datum, text, periode) values('" + datum + "', '" + stringReplace(text) + "', '" + periode + "')")
            Return True
        Else
            Return False
        End If
    End Function
   
End Class
