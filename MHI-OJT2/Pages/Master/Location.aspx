<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Location.aspx.cs" Inherits="MHI_OJT2.Pages.Master.Location" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/jquery.dataTables.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Location</h1>
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
                        <table class="hover nowrap" style="width:100%">
                            <thead>
                                <tr>
                                    <th class="text-center">NO.</th>
                                    <th>Location Name</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-center">Tools</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="RepeatTable" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <th scope="row" class="text-center">
                                                <%# Container.ItemIndex + 1 %>
                                            </th>
                                            <td><%# Eval("LOCATION_NAME") %></td>
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
        <!-- /.container-fluid -->
    </div>
    <!-- /.content -->
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="script" runat="server">
    <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        (function () {
            $("table").DataTable({
                responsive: true,
                scrollX: 500,
                scrollCollapse: true,
                scroller: true
            });
        })();
    </script>
</asp:Content>