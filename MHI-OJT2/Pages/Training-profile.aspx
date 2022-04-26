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
                <div class="col-sm-6">
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-success" onclick="handlePrintReportTrainingProfile()">
                            <i class="fa fa-file-pdf mr-2"></i>
                            พิมพ์รายงาน</button>
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
                                <th>รหัสพนักงาน</th>
                                <th>ชื่อผู้เข้าอบรม</th>
                                <%} %>
                                <th class="text-center">แผนก</th>
                                <th class="text-center">คะแนน</th>
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
                                        <td><%# Eval("PersonCode") %></td>
                                        <td><%# Eval("InitialT") %> <%# Eval("FnameT") %> <%# Eval("LnameT") %></td>
                                        <%} %>
                                        <td class="text-center"><%# Eval("DEPARTMENT_NAME") %></td>
                                        <td class="text-center"><%# Eval("TOTAL_SCORE") %></td>

                                        <td class="text-center"><%# String.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd/MM/yyyy}", Eval("START_DATE")) %></td>
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
    <div class="modal fade" id="ExportReportModal" tabindex="-1" aria-labelledby="ExportReportModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered" style="box-shadow: none !important;">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">เลือกเงื่อนไขเพื่อพิมพ์รายงาน</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" >
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row section__container">
                        <div class="col-12">
                            <label>ฝ่าย</label>
                             <select class="form-control selectpicker" id="section" runat="server" data-live-search="true">
                                <option selected>-</option>
                             </select> 
                        </div>
                    </div>
                    <div class="row employeeId__container mt-2">
                        <div class="col-6 form-group">
                            <label>รหัสพนักงาน</label>
                            <input type="text" id="employeeIdStart" runat="server" class="form-control" />
                        </div>
                        <div class="col-6 form-group">
                            <label>ถึง</label>
                            <input type="text" id="employeeIdEnd" runat="server" class="form-control" />
                        </div>
                    </div>
                    <div class="row course__container mt-2">
                        <div class="col-12">
                            <label>หลักสูตร</label>
                             <select class="form-control selectpicker" id="course" runat="server" data-live-search="true">
                                <option selected>-</option>
                             </select> 
                        </div>
                    </div>
                    <div class="row date__range__container mt-2">
                        <div class="col-6 form-group">
                            <label>วันที่เริ่มอบรม</label>
                            <input type="tel" id="startDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                        </div>
                        <div class="col-6 form-group">
                            <label>ถึง</label>
                            <input type="tel" id="endDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                        </div>
                    </div>
                </div> 
                <div class="modal-footer">
                    <asp:Button ID="btnExportReport" Text="พิมพ์รายงาน" runat="server" CssClass="btn btn-block btn-success" OnClick="ExportReportTrainingProfile" OnClientClick="return validationFilters()" />
                </div>
            </div>
        </div>
    </div>
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

        var roles = `<%= roles %>`
        var sectionContainer = $('.section__container')
        var employeeIdContainer = $('.employeeId__container')
        var courseContainer = $('.course__container')

        function handlePrintReportTrainingProfile() {
            let modal = $('#ExportReportModal')
            let today = moment();
            let currentYears = today.year();
            let startDate = moment(`${currentYears}-01-01`);
            let endDate = moment(`${currentYears}-12-31`);
            $('#<%= startDate.ClientID %>').val(startDate.format("DD/MM/YYYY"))
            $('#<%= endDate.ClientID %>').val(endDate.format("DD/MM/YYYY"))

            if (roles === "user") {
                sectionContainer.hide()
                employeeIdContainer.hide()
                courseContainer.hide()
            }
            modal.modal('show')
        }

        $('#<%= employeeIdStart.ClientID %>').on("keyup", function () {
            $('#<%= employeeIdEnd.ClientID %>').val($(this).val())
        })

        function validationFilters() {
            let title = "แจ้งเตือน"
            let empStart = $('#<%= employeeIdStart.ClientID %>').val().length
            let empEnd = $('#<%= employeeIdEnd.ClientID %>').val().length
            let startDate = $('#<%= startDate.ClientID %>').val().length
            let endDate = $('#<%= endDate.ClientID %>').val().length

            if (empStart) {
                if (!empEnd) {
                    toasts(title, "กรุณาระบุข้อมูลให้ครบถ้วน")
                    return false
                }
            }

            if (empEnd) {
                if (!empStart) {
                    toasts(title, "กรุณาระบุข้อมูลให้ครบถ้วน")
                    return false
                }
            }

            if (startDate !== 10 && endDate !== 10) {
                toasts(title, "กรุณาระบุข้อมูลให้ถูกต้อง")
                return false
            }

            return true
        }
    </script>
</asp:Content>
