<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Training-profile.aspx.cs" Inherits="MHI_OJT2.Pages.Training_profile" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">ประวัติการฝึกอบรม</h1>
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
            <div class="card ">
                <div class="card-body">
                    <table class="hover nowrap" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="text-center">ลำดับ</th>
                                <th>รหัสหลักสูตร</th>
                                <th>ชื่อหลักสูตร</th>
                                <% if (roles != "user")
                                            { %>
                                <th>ชื่อผู้เข้าอบรม</th>
                                        <%} %>
                                <th class="text-center">แผนก</th>
                                <th class="text-center">วันที่อบรม</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RepeatTable" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <th scope="row" class="text-center">
                                            <%# Container.ItemIndex + 1 %>
                                        </th>
                                        <td><%# Eval("COURSE_NUMBER") %></td>
                                        <td><%# Eval("COURSE_NAME") %></td>
                                        <% if (roles != "user")
                                            { %>
                                            <td><%# Eval("InitialT") %> <%# Eval("FnameT") %> <%# Eval("LnameT") %></td>
                                        <%} %>
                                        <td class="text-center"><%# Eval("DEPARTMENT_NAME") %></td>
                                        <td class="text-center"><%# String.Format(new System.Globalization.CultureInfo("th-TH"), "{0:d MMMM yyyy}", Eval("START_DATE")) %></td>
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
    </script>
</asp:Content>
