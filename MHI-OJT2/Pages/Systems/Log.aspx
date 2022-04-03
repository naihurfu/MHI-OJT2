<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Log.aspx.cs" Inherits="MHI_OJT2.Pages.Systems.Log" %>
<asp:Content ID="HeadConent" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">SYSTEM LOG</h1>
                </div>
                <!-- /.col -->
                <%--<div class="col-sm-6">
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-primary" onclick="handleShowModal('add', {})">
                            <i class="fa fa-user-plus mr-2"></i>
                            เพิ่มผู้ใช้งาน</button>
                    </div>
                </div>--%>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container-fluid -->
    </div>

    <!-- Main content -->
    <div class="content">
        <div class="container-fluid">
            <div class="card">
                <div class="card-body">
                    <table class="hover nowrap" style="width: 100%">
                        <thead>
                            <tr>
                                <th class="text-center">ลำดับ</th>
                                <th>ประเภท</th>
                                <th>หัวข้อ</th>
                                <th>รายละเอียด</th>
                                <th>ผู้ปรับปรุงข้อมูล</th>
                                <th class="text-center">วันที่/เวลา</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RepeatTable" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td scope="row" class="text-center">
                                            <%# Container.ItemIndex + 1 %>
                                        </td>
                                        <td><%# Eval("ACTION_TYPE") %></td>
                                        <td><%# Eval("TITLE") %></td>
                                        <td><%# Eval("REMARK") %></td>
                                        <td><%# Eval("USERNAME") %></td>
                                        <td class="text-center"><%# String.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd MMM yyyy / HH:mm}", Eval("CREATED_AT")) %></td>
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
   </script>
</asp:Content>
