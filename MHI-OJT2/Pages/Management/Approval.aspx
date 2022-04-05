<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Approval.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Approval" %>
<asp:Content ID="HeaderContent" ContentPlaceHolderID="head" runat="server">
    <style>
        div.swal2-popup.swal2-modal.swal2-show {
            min-width: 560px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">อนุมัติหลักสูตร</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-primary" onclick="handleShowHistoryModal()">
                            <i class="fa fa-plus-circle mr-2"></i>
                            ประวัติการอนุม้ติย้อนหลัง</button>
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
                    <table class="hover nowrap" style="width: 100%">
                        <thead>
                            <tr>
                                <th class="text-center">ลำดับ</th>
                                <th>รหัสหลักสูตร</th>
                                <th>ชื่อหลักสูตร</th>
                                <th class="text-center">แผนก</th>
                                <th class="text-center">คะแนน</th>
                                <th class="text-center">ดาวโหลดรายงาน</th>
                                <th class="text-center">อนุมัติ/ไม่อนุมัติ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RepeatTable" runat="server" OnItemCommand="RepeatTable_ItemCommand">
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
                                            <button type="button" class="btn btn-success btn-sm ml-2" onclick="handleShowScore({courseId: <%# Eval("COURSE_ID") %>, aprovalId: <%# Eval("APPROVAL_ID") %>, approvalSequence: <%# Eval("APPROVAL_SEQUENCE") %>})">ดูคะแนน</button>
                                        </td>
                                        <td class="text-center">
                                            <asp:Button ID="btnExportReportApproval" CommandName="DOWNLOAD_REPORT_OJT" Text="Training/Evaluation OJT" runat="server" CommandArgument='<%# Eval("COURSE_ID") %>' CssClass="btn btn-sm btn-info"/>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-danger btn-sm" onclick="handleApprove({courseId: <%# Eval("COURSE_ID") %>, aprovalId: <%# Eval("APPROVAL_ID") %>, isApprove: 0, approvalSequence: <%# Eval("APPROVAL_SEQUENCE") %>})">ไม่อนุมัติ</button>
                                            <button type="button" class="btn btn-success btn-sm ml-2" onclick="handleApprove({courseId: <%# Eval("COURSE_ID") %>, aprovalId: <%# Eval("APPROVAL_ID") %>, isApprove: 1, approvalSequence: <%# Eval("APPROVAL_SEQUENCE") %>})">อนุมัติ</button>
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
                scroller: true,
                "oLanguage": {
                    "sSearch": "ค้นหา :",
                    "sLengthMenu": "แสดง _MENU_ รายการ"
                },
                "language": {
                    "info": "แสดง _START_-_END_ รายการ ทั้งหมด _TOTAL_ รายการ",
                    "paginate": {
                        "previous": "ย้อนกลับ",
                        "next": "หน้าถัดไป"
                    }
                }
            });

        })();
        function handleShowScore(data) {
            const { aprovalId, courseId, approvalSequence } = data
            let body = "{'APPROVE_ID': " + aprovalId + ",'COURSE_ID': " + courseId + ",'APPROVAL_SEQUENCE': " + approvalSequence + "}"
            $.ajax({
                type: "POST",
                url: "/OJT/Pages/Management/Approval.aspx/ShowScore",
                data: "{ '_ApproveResult': " + body + " }",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    switch (results.d) {
                        case "ERROR":
                            Swal.fire('Error!', 'Network connection encountered a problem. Please try again later.', 'error')
                            break

                        default:
                            window.location.href = window.location.protocol + "//" + window.location.host + "/Pages/Management/Evaluation.aspx"

                    }
                },
                error: function (err) {
                    console.log(err)
                }
            });
        }

        function handleApprove(data) {
            const { aprovalId, courseId, isApprove, approvalSequence } = data
            Swal.fire({
                title: isApprove ? 'คุณต้องการ <b class="text-success">อนุมัติ</b> ใช่หรือไม่?' : 'คุณต้องการ <b class="text-danger">ปฏิเสธการอนุมัติ</b> ใช่หรือไม่?',
                html: `<div class="form-group text-left">
                            <textarea type="text" id="remark" class="form-control dark-mode text-light" rows="3" placeholder="หมายเหตุ"></textarea>
                       </div>`,
                showConfirmButton: true,
                confirmButtonColor: isApprove ? '#28a745' : '#dc3545',
                showCancelButton: true,
                confirmButtonText: isApprove ? 'อนุมัติ' : 'ยืนยัน',
                cancelButtonText: `ปิด`,

            }).then((result) => {
                if (result.isConfirmed) {
                    let remark = $('#remark').val()
                    let body = "{'APPROVE_ID': " + aprovalId + ",'COURSE_ID': " + courseId + ",'IS_APPROVE': " + isApprove + ",'APPROVAL_SEQUENCE': " + approvalSequence + ", 'REMARK': '" + remark + "'}"
                    $.ajax({
                        type: "POST",
                        url: "/OJT/Pages/Management/Approval.aspx/HandleApprove",
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
