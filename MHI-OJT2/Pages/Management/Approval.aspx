<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Approval.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Approval" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/jquery.dataTables.min.css">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Approval</h1>
                </div>
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
                    <table class="hover nowrap" style="width: 100%">
                        <thead>
                            <tr>
                                <th class="text-center">NO.</th>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th class="text-center">Department</th>
                                <th class="text-center">Approve</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RepeatTable" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <th scope="row" class="text-center">
                                            <%# Container.ItemIndex + 1 %>
                                        </th>
                                        <td>
                                            <%# Eval("COURSE_NUMBER") %>
                                        </td>
                                        <td>
                                            <%# Eval("COURSE_NAME") %>
                                        </td>
                                        <td class="text-center">
                                            <%# Eval("DEPARTMENT_NAME") %>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-danger btn-sm" onclick="handleApprove({courseId: <%# Eval("ID") %>, aprovalId: <%# Eval("APPROVAL_ID") %>, isApprove: 0, approvalSequence: <%# Eval("APPROVAL_SEQUENCE") %>})">Reject</button>
                                            <button type="button" class="btn btn-success btn-sm ml-2" onclick="handleApprove({courseId: <%# Eval("ID") %>, aprovalId: <%# Eval("APPROVAL_ID") %>, isApprove: 1, approvalSequence: <%# Eval("APPROVAL_SEQUENCE") %>})">Approve</button>
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
<asp:Content ID="ModalContent" ContentPlaceHolderID="modal" runat="server">
</asp:Content>
<asp:Content ID="ScriptContent" ContentPlaceHolderID="script" runat="server">
    <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        (function () {
            // initial datatable
            $("table").DataTable({
                responsive: true,
                scrollX: 500,
                scrollCollapse: true,
                scroller: true
            });

        })();

        function handleApprove(data) {
            const { aprovalId, courseId, isApprove, approvalSequence } = data
            let body = "{'APPROVE_ID': " + aprovalId + ",'COURSE_ID': " + courseId + ",'IS_APPROVE': " + isApprove + ",'APPROVAL_SEQUENCE': " + approvalSequence + "}"
            console.log(body)
            Swal.fire({
                title: isApprove ? 'Do you want to approve?' : 'Would you like to reject the request?',
                showConfirmButton: true,
                confirmButtonColor: isApprove ? '#28a745' : '#dc3545',
                showCancelButton: true,
                confirmButtonText: isApprove ? 'Approve' : 'Reject',
                cancelButtonText: `Cancel`
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: "POST",
                        url: "/Pages/Management/Approval.aspx/HandleApprove",
                        data: "{ '_ApproveResult': " + body + " }",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (results) {
                            switch (results.d) {
                                case "ERROR":
                                    Swal.fire('Error!', 'Network connection encountered a problem. Please try again later.', 'error')
                                    break

                                default:
                                    window.location.href = window.location.href;
                
                            }
                        },
                        error: function (err) {
                            console.log(err)
                        }
                    });
                }
            })
        }
    </script>
</asp:Content>
