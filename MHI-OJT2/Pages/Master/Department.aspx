﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Department.aspx.cs" Inherits="MHI_OJT2.Pages.Master.Department" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/jquery.dataTables.min.css">
    <style type="text/css">
        table {
            width: 100% !important;
        }

        th, td {
            vertical-align: middle !important;
            white-space: nowrap;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Department</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-primary" onclick="handleShowAddModal('add')">Create</button>
                    </div>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
        <div class="container-fluid">
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive-xl">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th class="text-center">No.</th>
                                    <th>Department Name</th>
                                    <th>Section Name</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-center">Tools</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="RepeatDepartmentTable" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <th scope="row" class="text-center">
                                                <%# Container.ItemIndex + 1 %>
                                            </th>
                                            <td><%# Eval("DEPARTMENT_NAME") %></td>
                                            <td><%# Eval("SECTION_NAME") %></td>
                                            <td class="text-center">
                                                <span class='<%# (Boolean)Eval("IS_ACTIVE") == true ? "badge badge-success" : "badge badge-danger" %>'>
                                                    <%# (Boolean)Eval("IS_ACTIVE") == true ? "ACTIVE" : "INACTIVE" %> 
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group" aria-label="Basic example">
                                                    <button type="button" class="btn btn-sm btn-warning">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-danger">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <!-- /.content -->
</asp:Content>
<asp:Content ID="ScriptContent" ContentPlaceHolderID="script" runat="server">
    <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        (function () {
            $("table").DataTable({
                responsive: true
            });
        })();
    </script>
</asp:Content>
