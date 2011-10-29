Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports System.Net
Imports System.Collections.Generic

Public Class clsData

    Dim connStr As String = ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString
    Dim con As New SqlConnection(connStr)
    Dim cmd As SqlCommand = New SqlCommand




    Private Function getDataSet(ByVal sql As String, ByVal name As String) As DataSet
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

    Public Function getFutterPlaces() As DataTable
        Dim dtFutterPlaces As DataTable = New DataTable()
        Try
            dtFutterPlaces = getDataSet("select * from futterplaces where active='1'", "futterplaces").Tables(0)
            Return dtFutterPlaces
        Catch ex As Exception

        End Try
        

        Return dtFutterPlaces

    End Function


End Class
