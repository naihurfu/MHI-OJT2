<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Courses" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/timepicker.js/latest/timepicker.min.css" rel="stylesheet" />
    <style type="text/css">
        input[type=checkbox], input[type=radio] {
            width: 20px !important;
            height: 20px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 400 !important;
        }

        FIELDSET {
            margin: 8px;
            border: 1px solid silver;
            padding: 8px;
            border-radius: 4px;
        }

        LEGEND {
            width: auto !important;
            padding: 2px;
            font-size: 16px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">จัดการหลักสูตร</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-primary" onclick="handleShowAddModal('add')">
                            <i class="fa fa-plus-circle mr-2"></i>
                            สร้างหลักสูตร</button>
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
                    <table class="hover nowrap" id="courseTable" style="width: 100%">
                        <thead>
                            <tr>
                                <th class="text-center">ลำดับ</th>
                                <th class="text-center">แก้ไข</th>
                                <th>รายละเอียด</th>
                                <th>แผนก</th>
                                <th>ชื่อหลักสูตร</th>
                                <th>ผู้จัดทำ</th>
                                <th>วันที่เริ่มอบรม</th>
                                <th>วันที่จัดทำแผน</th>
                                <th class="text-center">ประเภท</th>
                                <th class="text-center">สถานะ</th>
                                <th class="text-center">ดาวโหลดรายงาน</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RepeatCourseTable" runat="server" OnItemCommand="RepleaterItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <th scope="row" class="text-center">
                                            <%# Container.ItemIndex + 1 %>
                                        </th>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-sm btn-primary" onclick="handleEditCourse(<%# Eval("COURSE_ID") %>)" <%# Session["roles"].ToString().ToLower() != "admin" ? (int)Eval("STATUS_CODE") == 10 ? "disabled" : "" : "" %>>แก้ไข</button>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-link" onclick="handleViewCourseDetail(<%# Eval("COURSE_ID") %>)">
                                                แสดง
                                                <%# Eval("FILE_UPLOAD").ToString().ToUpper() == "SYSTEM.BYTE[]" ? " <i class='fa fa-file-pdf text-danger'></i>" : "" %>
                                            </button>
                                        </td>
                                        <td><%# Eval("DEPARTMENT_NAME") %></td>
                                        <td><%# Eval("COURSE_NAME") %></td>
                                        <td><%# Eval("CREATED_NAME") %></td>
                                        <td><%# String.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd/MM/yyyy}", Eval("START_DATE")) %></td>
                                        <td><%# Eval("PLAN_DATE").ToString() != "" ? String.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd/MM/yyyy}", Eval("PLAN_DATE")) : "-"%></td>
                                        <td class="text-center">
                                            <span class="badge badge-<%# int.Parse(Eval("PLANNED").ToString()) == 1 ? "warning" : "info" %>">
                                                <%# int.Parse(Eval("PLANNED").ToString()) == 1 ? "ในแผน" : "นอกแผน" %>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class='<%# (int)Eval("STATUS_CODE") == 1 ? "btn btn-sm btn-primary" : (int)Eval("STATUS_CODE") == 2 ? "btn btn-sm btn-warning" : (int)Eval("STATUS_CODE") == 9 ? "btn btn-sm btn-success" : (int)Eval("STATUS_CODE") == 10 ? "btn btn-sm btn-danger" : "btn btn-sm btn-secondary" %>' onclick="handleShowModal(<%# Eval("COURSE_ID") %>,'<%# (int)Eval("STATUS_CODE")== 1 ? "add-employee" : (int)Eval("STATUS_CODE")== 2 ? "evaluate" : "view-status" %>')" style="width: 220px !important;">
                                                <%# Eval("STATUS_TEXT") %>
                                            </button>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class='btn btn-sm btn-success' onclick="handleExportReport({COURSE_ID: <%# Eval("COURSE_ID") %>, COURSE_CODE : '<%# Eval("COURSE_NUMBER") %>' , COURSE_NAME : '<%# Eval("COURSE_NAME") %>', COURSE_TIMES: '<%# Eval("TIMES") %>' , COURSE_START_DATE : '<%# Eval("START_DATE") %>', CREATED_NAME : '<%# Eval("CREATED_NAME") %>'})" <%# (int)Eval("STATUS_CODE") >= 3 ? "" : "disabled" %>>
                                                Training/Evaluation OJT
                                            </button>
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
    <%-- add course modal --%>
    <div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-xl">
            <div class="modal-content ">
                <div class="modal-header">
                    <h5 class="modal-title" id="addModalTitle"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="plan-section-container">
                        <div class="pt-2 check-plan-container">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="plan" id="checkPlan" runat="server">
                                <label class="form-check-label" for="<%= checkPlan.ClientID %>">อบรมตามแผน</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="plan" id="checkNotPlan" runat="server">
                                <label class="form-check-label" for="<%= checkNotPlan.ClientID %>">อบรมนอกแผน</label>
                            </div>
                        </div>
                        <div class="form-group py-3 select-plan-container">
                            <label>เลือกแผนฝึกอบรม</label>
                            <select class="form-control selectpicker" id="trainingPlan" runat="server" data-live-search="true">
                                <option selected>-</option>
                            </select>
                        </div>
                        <hr />
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>รหัสหลักสูตร</label>
                            <input type="text" class="form-control" id="courseNumber" runat="server">
                        </div>
                        <div class="form-group col-md-6">
                            <label><span class="text-danger">*</span> ครั้งที่</label>
                            <input type="text" class="form-control" id="times" runat="server">
                        </div>
                    </div>
                    <div class="form-group">
                        <label><span class="text-danger">*</span> ชื่อหลักสูตร</label>
                        <input type="text" class="form-control" id="courseName" runat="server">
                    </div>
                    <div class="form-group">
                        <label>วัตถุประสงค์</label>
                        <textarea class="form-control" id="objective" rows="3" runat="server"></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label><span class="text-danger">*</span> วันที่เริ่มอบรม</label>
                            <input type="tel" id="startDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                        </div>
                        <div class="form-group col-md-6">
                            <label><span class="text-danger">*</span> วันที่สิ้นสุด</label>
                            <input type="tel" id="endDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label><span class="text-danger">*</span> เวลาเริ่ม</label>
                            <input type="time" class="form-control" id="startTime" runat="server" />
                        </div>
                        <div class="form-group col-md-4">
                            <label><span class="text-danger">*</span> เวลาสิ้นสุด</label>
                            <input type="time" class="form-control" id="endTime" runat="server" />
                        </div>
                        <div class="form-group col-md-4">
                            <label><span class="text-danger">*</span> รวมจำนวนชั่วโมง</label>
                            <input type="number" class="form-control" id="totalHours" min="0" max="24" runat="server">
                        </div>
                    </div>
                    <div class="evaluate-type-container">
                        <label><span class="text-danger">*</span> รูปแบบการประเมิน</label>
                        <div class="row mb-4 mt-1">
                            <div class="form-check form-check-inline px-2">
                                <input class="form-check-input" type="checkbox" runat="server" id="realWorkEvaluate">
                                <label class="form-check-label" for='<%= realWorkEvaluate.ClientID %>'>แบบปฏิบัติงานจริง</label>
                            </div>
                            <div class="form-check form-check-inline px-2">
                                <input class="form-check-input" type="checkbox" runat="server" id="examEvaluate">
                                <label class="form-check-label" for='<%= examEvaluate.ClientID %>'>แบบข้อสอบ</label>
                            </div>
                            <div class="form-inline" style="width: calc(100% - 312px);">
                                <div class="input-group">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">
                                            <input class="form-check-input" type="checkbox" runat="server" id="otherEvaluate">
                                            <label class="form-check-label mx-2" for='<%= otherEvaluate.ClientID %>'>อื่นๆ </label>
                                        </span>
                                    </div>
                                    <input type="text" class="form-control" style="width: 698px;" id="otherEvaluateRemark" runat="server" disabled="disabled" placeholder="หมายเหตุ">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label><span class="text-danger">*</span> แผนก</label>
                        <select class="form-control" id="department" runat="server">
                            <option selected>-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><span class="text-danger">*</span> สถานที่ฝึกอบรม</label>
                        <select class="form-control" id="location" runat="server">
                            <option selected>-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><span class="text-danger">*</span> วิทยากร</label>
                        <select class="form-control" id="teacher" runat="server">
                            <option selected>-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>รายละเอียด</label>
                        <textarea class="form-control" id="detail" rows="3" runat="server"></textarea>
                    </div>
                    <div class="form-group" id="upload-file-container" style="padding: 15px 0 5px 0;">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">แนบไฟล์</span>
                            </div>
                            <div class="custom-file">
                                <input type="file" runat="server" class="custom-file-input" id="fileUpload" accept=".pdf" />
                                <script type="text/javascript">
                                    $('#<%= fileUpload.ClientID %>').on('change', function (e) {
                                        var fileName = e.target.files[0].name;
                                        $('#fileName').text(fileName);
                                    })
                                </script>
                                <label class="custom-file-label" id="fileName">-</label>
                            </div>
                        </div>
                    </div>
                    <div class="assessor-container-all">
                        <div class="form-group assessor-container-1">
                            <label><span class="text-danger">*</span> ผู้อนุมัติคนที่ 1</label>
                            <select class="form-control selectpicker" id="Assessor1" runat="server" data-live-search="true">
                            </select>
                        </div>
                        <div class="form-group assessor-container-2">
                            <label>ผู้อนุมัติคนที่ 2</label>
                            <select class="form-control selectpicker" id="Assessor2" runat="server" data-live-search="true">
                            </select>
                        </div>
                        <div class="form-group assessor-container-3">
                            <label>ผู้อนุมัติคนที่ 3</label>
                            <select class="form-control selectpicker" id="Assessor3" runat="server" data-live-search="true">
                            </select>
                        </div>
                        <div class="form-group assessor-container-4">
                            <label>ผู้อนุมัติคนที่ 4</label>
                            <select class="form-control selectpicker" id="Assessor4" runat="server" data-live-search="true">
                            </select>
                        </div>
                        <div class="form-group assessor-container-5">
                            <label>ผู้อนุมัติคนที่ 5</label>
                            <select class="form-control selectpicker" id="Assessor5" runat="server" data-live-search="true">
                            </select>
                        </div>
                        <div class="form-group assessor-container-6">
                            <label>ผู้อนุมัติคนที่ 6</label>
                            <select class="form-control selectpicker" id="Assessor6" runat="server" data-live-search="true">
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:HiddenField ID="downloadFileId" runat="server" />
                    <button type="button" runat="server" id="btnDownloadFileDocument" class="btn btn-primary mr-auto" style="display: none;" onserverclick="DownloadPDFDocument">ดาวโหลดเอกสารที่เกี่ยวข้อง</button>
                    <button type="button" runat="server" id="btnDelete" class="btn btn-danger mr-auto" onserverclick="btnDelete_ServerClick" style="display: none;">ลบ</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด</button>
                    <button type="button" runat="server" id="btnEdit" class="btn btn-primary" onserverclick="btnEdit_Click" style="display: none;">บันทึก</button>
                    <button type="button" runat="server" id="btnInserted" class="btn btn-primary" onserverclick="btnInserted_Click" onclick="if (addCourseValidation())" style="display: none;">บันทึก</button>
                    <input type="hidden" runat="server" id="hiddenId" />
                    <input type="hidden" runat="server" id="hiddenCourseAndPlanId" />
                </div>
            </div>
        </div>
    </div>
    <%-- add employee modal --%>
    <div class="modal fade" id="addEmployeeModal" tabindex="-1" aria-labelledby="addModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-xl" style="box-shadow: none !important;">
            <div class="modal-content ">
                <div class="modal-header">
                    <h5 class="modal-title ">เลือกพนักงานเข้าฝึกอบรม</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="height: 575px !important;">
                    <div class="transfer"></div>
                </div>
                <div class="modal-footer" style="justify-content: end !important;">
                    <div class="action-button-area">
                        <input type="hidden" runat="server" id="hiddenCourseId_AddEmployeeModal" />
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด</button>
                        <button type="button" class="btn btn-primary" onclick="handleInsertEmployee(true);" style="width: 120px !important;">บันทึก (ร่าง) </button>
                        <button type="button" class="btn btn-success" onclick="handleInsertEmployee(false);" style="width: 80px !important;">บันทึก</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="viewStatusModal" tabindex="-1" aria-labelledby="viewStatusModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg" style="box-shadow: none !important;">
            <div class="modal-content ">
                <div class="modal-header">
                    <h5 class="modal-title ">ตรวจสอบสถานะการอนุมัติ</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="text-center my-5" id="approval-loading">
                        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                            <span class="sr-only">โปรดรอ...</span>
                        </div>
                    </div>
                    <div class="table-responsive" id="approval-table-container">
                        <table class="table m-0" id="approval-table">
                            <thead>
                                <tr>
                                    <th class="text-center">ลำดับ</th>
                                    <th>ชื่อผู้อนุมัติ</th>
                                    <th class="text-center">สถานะ</th>
                                    <th class="text-center">วันที่</th>
                                    <th>หมายเหตุ</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer" style="justify-content: end !important;">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="ExportReportModal" tabindex="-1" aria-labelledby="ExportReportModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-xl" style="box-shadow: none !important;">
            <div class="modal-content ">
                <div class="modal-header">
                    <h5 class="modal-title ">ลงชื่อผู้ทำการฝึกอบรมและประเมิน</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="d-flex justify-content-center my-3">
                        <h5>[<span id="export-report-code"></span>] - 
                            <span id="export-report-title"></span>
                        </h5>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>วันที่อบรม : <b id="export-report-start-date"></b></span>
                        <span>ผู้จัดทำ : <b id="export-report-created-name"></b></span>
                    </div>

                    <fieldset>
                        <legend>ลงชื่อคนที่ 1</legend>
                        <div class="row">
                            <div class="col-4 form-group">
                                <label>ลงชื่อ</label>
                                <input type="text" runat="server" id="commanderName" class="form-control" />
                            </div>
                            <div class="col-4 form-group">
                                <label>ตำแหน่ง</label>
                                <input type="text" runat="server" id="commanderPositionName" class="form-control" />
                            </div>
                            <div class="col-4 form-group mb-2">
                                <label>ลงวันที่</label>
                                <input type="tel" id="commanderDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                    </fieldset>
                    <fieldset>
                        <legend>ลงชื่อคนที่ 2</legend>
                        <div class="row">
                            <div class="col-4 form-group">
                                <label>ลงชื่อ</label>
                                <input type="text" runat="server" id="assessorName" class="form-control" />
                            </div>
                            <div class="col-4 form-group">
                                <label>ตำแหน่ง</label>
                                <input type="text" runat="server" id="assessorPositionName" class="form-control" />
                            </div>
                            <div class="col-4 form-group">
                                <label>ลงวันที่</label>
                                <input type="tel" id="assessorDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                    </fieldset>

                    <fieldset>
                        <legend>ลงชื่อคนที่ 3</legend>
                        <div class="row">
                            <div class="col-4 form-group">
                                <label>ลงชื่อ</label>
                                <input type="text" runat="server" id="sectionManagerName" class="form-control" />
                            </div>
                            <div class="col-4 form-group">
                                <label>ตำแหน่ง</label>
                                <input type="text" runat="server" id="sectionManagerPositionName" class="form-control" />
                            </div>
                            <div class="col-4 form-group">
                                <label>ลงวันที่</label>
                                <input type="tel" id="sectionManagerDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                    </fieldset>

                </div>
                <div class="modal-footer" style="justify-content: space-between !important;">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" id="isSigned" runat="server">
                        <label class="form-check-label" for="<%= isSigned.ClientID %>">ลงลายเซ็นต์พนักงาน</label>
                    </div>
                    <input type="hidden" id="EXPORT_REPORT_COURSE_ID" runat="server" />
                    <asp:Button ID="btnExportReport" Text="พิมพ์รายงาน" runat="server" CssClass="btn btn-success" OnClick="ExportReportEvaluationOJT" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ScriptContent" ContentPlaceHolderID="script" runat="server">
    <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
                                        (function () {
                                            // initial datatable
                                            $("#courseTable").DataTable({
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
                                            // hide select option value - 
                                            $("#<%= trainingPlan.ClientID %> option[value='-']").hide()
                                            $("#<%= trainingPlan.ClientID %>").prop("disabled", "disabled")
                                        })();

        function handleExportReport(d) {
            if (d.COURSE_ID) {
                let modal = $('#ExportReportModal')
                let hiddenId = $('#<%= EXPORT_REPORT_COURSE_ID.ClientID %>')
                $('#export-report-title').text(d.COURSE_NAME)
                $('#export-report-code').text(d.COURSE_CODE)
                $('#export-report-start-date').text(d.COURSE_START_DATE.split(' ')[0] ?? "")
                $('#export-report-created-name').text(d.CREATED_NAME)

                hiddenId.val(d.COURSE_ID)
                modal.modal('show')

            } else {
                toasts("ผิดพลาด", "พบข้อผิดพลาดขณะเตรียมข้อมูล กรุณาตรวจสอบการเชื่อมต่อเครือข่าย และลองใหม่ภายหลัง", "bg-danger")
            }

        }

        function handleShowAddModal() {
            $('#<%= btnInserted.ClientID %>').show()
            $('#<%= btnEdit.ClientID %>').hide()

            isDisabledInput(false)

            assessor1.val(0).change()
            $('.assessor-container-all').show()
            $('#addModalTitle').text('เพิ่มหลักสูตร')
            $('#upload-file-container').show()
            $('#<%= otherEvaluateRemark.ClientID %>').attr('disabled', 'disabled')
            $('#addModal').modal('show')
        };
        function handleShowModal(courseId, modalName) {
            switch (modalName) {
                case 'add-employee':
                    $('#<%= hiddenCourseId_AddEmployeeModal.ClientID %>').val(courseId)
                    iniTransferBox(courseId)
                    $('#addEmployeeModal').modal('show')
                    break;

                case 'evaluate':
                    $.ajax({
                        type: "POST",
                        url: "<%= ajax %>" + "/Pages/Management/Courses.aspx/CreateSessionToEvaluate",
                        data: "{'courseId': " + courseId + "}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (results) {
                            if (results.d === "SUCCESS") {
                                window.location.href = window.location.protocol + "//" + window.location.host + "/Pages/Management/Evaluation.aspx"
                            }
                        },
                        error: function (err) {
                            console.log(err)
                        }
                    });

                    break;

                case 'view-status':
                    $('#viewStatusModal').modal('show')

                    var approval_loading = $('#approval-loading')
                    var approval_container = $('#approval-table-container')
                    $('#approval-table tbody tr').remove()

                    approval_loading.show()
                    approval_container.hide()
                    $.ajax({
                        type: "POST",
                        url: "<%= ajax %>" + "/Pages/Management/Courses.aspx/GetApprovalList",
                        data: "{'courseId': " + courseId + "}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (results) {
                            var data = JSON.parse(results.d)
                            var tableBody = $('#approval-table tbody')
                            console.log(data)
                            approval_loading.hide()
                            approval_container.show()

                            data.forEach(function (r) {
                                let icon = '<i class="ml-2 fa fa-check"></i>'
                                let statusText = 'อนุมัติ'
                                let badgeColor = 'success'
                                let actionDate = r.ACTION_DATE !== null ? new Date(r.ACTION_DATE).toLocaleDateString("th-TH") : "รอผลการอนุมัติ"

                                if (!r.IS_APPROVED) {
                                    icon = '<i class="ml-2 fa fa-spinner"></i>'
                                    badgeColor = 'warning'
                                    statusText = 'รออนุมัติ'
                                } else {
                                    if (!r.APPROVAL_RESULT) {
                                        icon = '<i class="ml-2 fa fa-times"></i>'
                                        badgeColor = 'danger'
                                        statusText = 'ไม่อนุมัติ'
                                    }
                                }

                                var tableRow = `<tr>
                                            <td class="text-center">${r.APPROVAL_SEQUENCE}</td>
                                            <td>${r.InitialT} ${r.FnameT} ${r.LnameT}</td>
                                            <td class="text-center">
                                                <span class="badge badge-${badgeColor}">${statusText} ${icon}</span>
                                            </td>
                                            <td class="text-center">
                                                ${actionDate}
                                            </td>
                                            <td>
                                                ${r.REMARK ?? "-"}
                                            </td>
                                        </tr>`;
                                tableBody.append(tableRow);
                            });
                        },
                        error: function (err) {
                            console.log(err)
                        }
                    });
                    break;

                default: sweetAlert("error", "WTF!")
            }
        };
        var dualBox;
        function handleInsertEmployee(isDraft) {
            // get course id
            var courseId = $('#<%= hiddenCourseId_AddEmployeeModal.ClientID %>').val()

            // get employee selected list
            var selectedList = dualBox.getSelectedItems()

            try {
                var employeeList = []
                // loop insert employee list
                for (var i = 0; i < selectedList.length; i++) {
                    let employee = {}

                    employee.CourseID = parseInt(courseId)
                    employee.PersonID = parseInt(selectedList[i].PersonID)

                    employeeList.push(employee)
                }

                if (!employeeList.length) throw new Error('กรุณาเลือกพนักงานก่อนกดบันทึก')

                $.ajax({
                    type: "POST",
                    url: "<%= ajax %>" + "/Pages/Management/Courses.aspx/InsertEmployee",
                    data: "{'EmployeeSelectedList': " + JSON.stringify(employeeList) + ", 'CourseId': " + courseId + ", 'IsDraft': " + isDraft + "}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: (res) => {
                        $('#addEmployeeModal').modal('hide')
                        window.location.href = window.location.href;
                    },
                    error: function (err) {
                        console.log(err)
                        sweetAlert("error", "Error!", err)
                    }
                });
            } catch (err) {
                toasts("แจ้งเตือน", err.message)
            }
        };
        function iniTransferBox(courseId) {
            $(".transfer-double").remove()
            var allEmployee = []
            var data = "{'courseId': " + courseId + "}"
            $.ajax({
                type: "POST",
                url: "<%= ajax %>" + "/Pages/Management/Courses.aspx/GetEmployeeList",
                data: data,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    console.log(results.d)
                    allEmployee = JSON.parse(results.d)
                    var settings = {
                        itemName: "fullName",
                        valueName: "PersonID",
                        tabNameText: "เลือกพนักงาน",
                        rightTabNameText: "พนักงานที่เข้าอบรม",
                        searchPlaceholderText: "ค้นหาพนักงาน",
                        dataArray: allEmployee,
                    };
                    dualBox = $(".transfer").transfer(settings);
                },
                error: function (err) {
                    console.log(err)
                }
            });
        }
        $('#<%= checkPlan.ClientID %>').on('change', function () {
            if (this.checked) {
                $('.select-plan-container').find('div').find('button').removeClass('disabled')
            }
        });
        $('#<%= checkNotPlan.ClientID %>').on('change', function () {
            if (this.checked) {
                $('#<%= trainingPlan.ClientID %>').val("-").change()
                $('.select-plan-container').find('div').find('button').addClass('disabled')
            }
        });
        $('#<%= otherEvaluate.ClientID %>').on('change', function () {
            if (this.checked) {
                $('#<%= otherEvaluateRemark.ClientID %>').removeAttr('disabled')
            } else {
                $('#<%= otherEvaluateRemark.ClientID %>').attr('disabled', 'disabled')
                $('#<%= otherEvaluateRemark.ClientID %>').val('')
            }
        })
        function handleEditCourse(courseId) {
            $.ajax({
                type: "POST",
                url: "<%= ajax %>" + "/Pages/Management/Courses.aspx/GetCourseDetailById",
                data: "{'courseId': " + courseId + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    var data = JSON.parse(results.d)[0]
                    OpenModalViewOrEdit('edit', data)
                },
                error: function (err) {
                    console.log(err)
                }
            });
        }
        function handleViewCourseDetail(id) {
            $.ajax({
                type: "POST",
                url: "<%= ajax %>" + "/Pages/Management/Courses.aspx/GetCourseDetailById",
                data: "{'courseId': " + id + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    var data = JSON.parse(results.d)[0]
                    OpenModalViewOrEdit('view', data)
                },
                error: function (err) {
                    console.log(err)
                }
            });
        }
        function OpenModalViewOrEdit(type, data) {
            ClearInputValue()
            $('#addModal').modal('show')
            if (type === 'view') {
                $('#plan-section-container').hide()
                $('#addModalTitle').text('รายละเอียดหลักสูตร')
                $('#<%= btnInserted.ClientID %>').hide()
                $('#<%= btnEdit.ClientID %>').hide()
                isDisabledInput(true)
                $('.assessor-container-all').show()

                if (data.FILE_UPLOAD) {
                    $('#<%= downloadFileId.ClientID %>').val(data.ID)
                    $('#<%= btnDownloadFileDocument.ClientID %>').show()
                }
            }

            if (type === 'edit') {
                $('.evaluate-type-container').hide()
                $('#upload-file-container').show()
                $('#plan-section-container').hide()
                $('#addModalTitle').text('แก้ไขหลักสูตร')
                $('#<%= btnDelete.ClientID %>').show()
                $('#<%= btnEdit.ClientID %>').show()
                $('#<%= btnInserted.ClientID %>').hide()
                isDisabledInput(false)
                $('#<%= btnDownloadFileDocument.ClientID %>').hide()
            }

            $('#<%= checkPlan.ClientID %>').prop('checked', data.PLAN_ID !== null ? true : false);
            $('#<%= checkNotPlan.ClientID %>').prop('checked', data.PLAN_ID === null ? true : false);
            $('#<%= checkPlan.ClientID %>').attr('disabled', true);
            $('#<%= checkNotPlan.ClientID %>').attr('disabled', true);

            if (data.PLAN_ID !== null) {
                $('#<%= trainingPlan.ClientID %>').val(data.PLAN_ID).change()
                $('.select-plan-container').find('div').find('button').removeClass('disabled')
            }
            $('#<%= examEvaluate.ClientID %>').prop('checked', data.IS_EXAM_EVALUATE)
            $('#<%= realWorkEvaluate.ClientID %>').prop('checked', data.IS_REAL_WORK_EVALUATE)
            $('#<%= otherEvaluate.ClientID %>').prop('checked', data.IS_OTHER_EVALUATE)
            $('#<%= otherEvaluateRemark.ClientID %>').val(data.OTHER_EVALUATE_REMARK)
            $('#<%= courseNumber.ClientID %>').val(data.COURSE_NUMBER)
            $('#<%= times.ClientID %>').val(data.TIMES)
            $('#<%= courseName.ClientID %>').val(data.COURSE_NAME)
            $('#<%= objective.ClientID %>').val(data.OBJECTIVE)
            $('#<%= startDate.ClientID %>').val(SQLDateToInput(data.START_DATE))
            $('#<%= endDate.ClientID %>').val(SQLDateToInput(data.END_DATE))
            $('#<%= startTime.ClientID %>').val(data.START_TIME)
            $('#<%= endTime.ClientID %>').val(data.END_TIME)
            $('#<%= totalHours.ClientID %>').val(data.TOTAL_HOURS)
            $('#<%= department.ClientID %>').val(data.DEPARTMENT_ID)
            $('#<%= location.ClientID %>').val(data.LOCATION_ID)
            $('#<%= teacher.ClientID %>').val(data.TEACHER_ID)
            $('#<%= Assessor1.ClientID %>').val(data.ASSESSOR1_ID !== 0 && data.ASSESSOR1_ID !== null ? data.ASSESSOR1_ID : 0).change();
            $('#<%= Assessor2.ClientID %>').val(data.ASSESSOR2_ID !== 0 && data.ASSESSOR2_ID !== null ? data.ASSESSOR2_ID : 0).change();
            $('#<%= Assessor3.ClientID %>').val(data.ASSESSOR3_ID !== 0 && data.ASSESSOR3_ID !== null ? data.ASSESSOR3_ID : 0).change();
            $('#<%= Assessor4.ClientID %>').val(data.ASSESSOR4_ID !== 0 && data.ASSESSOR4_ID !== null ? data.ASSESSOR4_ID : 0).change();
            $('#<%= Assessor5.ClientID %>').val(data.ASSESSOR5_ID !== 0 && data.ASSESSOR5_ID !== null ? data.ASSESSOR5_ID : 0).change();
            $('#<%= Assessor6.ClientID %>').val(data.ASSESSOR6_ID !== 0 && data.ASSESSOR6_ID !== null ? data.ASSESSOR6_ID : 0).change();
            $('#<%= hiddenId.ClientID %>').val(data.ID)
            $('#<%= hiddenCourseAndPlanId.ClientID %>').val(data.PLAN_AND_COURSE_ID)

        }
        $('#addModal').on('hidden.bs.modal', function () {
            ClearInputValue()
        })
        function ClearInputValue() {
            $('#<%= btnDownloadFileDocument.ClientID %>').hide()
            $('.evaluate-type-container').show()
            $('#<%= downloadFileId.ClientID %>').val("")
            $('#<%= btnDelete.ClientID %>').hide()
            $('.assessor-container-all').hide()
            $('#upload-file-container').hide()
            $('#plan-section-container').show()

            $('#<%= checkPlan.ClientID %>').prop('checked', false)
            $('#<%= checkNotPlan.ClientID %>').prop('checked', false)
            $('#<%= checkPlan.ClientID %>').attr('disabled', false)
            $('#<%= checkNotPlan.ClientID %>').attr('disabled', false)
            $('#<%= trainingPlan.ClientID %>').val('-').change()
            $('.select-plan-container').find('div').find('button').addClass('disabled')
            $('#<%= courseNumber.ClientID %>').val('')
            $('#<%= times.ClientID %>').val('')
            $('#<%= courseName.ClientID %>').val('')
            $('#<%= objective.ClientID %>').val('')
            $('#<%= startDate.ClientID %>').val('')
            $('#<%= endDate.ClientID %>').val('')
            $('#<%= startTime.ClientID %>').val('')
            $('#<%= endTime.ClientID %>').val('')
            $('#<%= totalHours.ClientID %>').val('')
            $('#<%= department.ClientID %>')[0].selectedIndex = 0;
            $('#<%= location.ClientID %>')[0].selectedIndex = 0;
            $('#<%= teacher.ClientID %>')[0].selectedIndex = 0;
            $('#<%= fileUpload.ClientID %>').val('');
            $('#<%= examEvaluate.ClientID %>').prop('checked', false)
            $('#<%= realWorkEvaluate.ClientID %>').prop('checked', false)
            $('#<%= otherEvaluate.ClientID %>').prop('checked', false)
            $('#<%= Assessor1.ClientID %>').val('-').change()
            $('#<%= Assessor2.ClientID %>').val('-').change()
            $('#<%= Assessor3.ClientID %>').val('-').change()
            $('#<%= Assessor4.ClientID %>').val('-').change()
            $('#<%= Assessor5.ClientID %>').val('-').change()
            $('#<%= Assessor6.ClientID %>').val('-').change()
            $('#<%= hiddenId.ClientID %>').val('')
            $('#<%= hiddenCourseAndPlanId.ClientID %>').val('')
            $('#<%= otherEvaluateRemark.ClientID %>').val('')
        }

        // handle assessor selected
        var assessor1 = $('#<%= Assessor1.ClientID %>')
        var assessor2 = $('#<%= Assessor2.ClientID %>')
        var assessor3 = $('#<%= Assessor3.ClientID %>')
        var assessor4 = $('#<%= Assessor4.ClientID %>')
        var assessor5 = $('#<%= Assessor5.ClientID %>')
        var assessor6 = $('#<%= Assessor6.ClientID %>')

        var assorContainer1 = $('.assessor-container-1')
        var assorContainer2 = $('.assessor-container-2')
        var assorContainer3 = $('.assessor-container-3')
        var assorContainer4 = $('.assessor-container-4')
        var assorContainer5 = $('.assessor-container-5')
        var assorContainer6 = $('.assessor-container-6')
        assessor1.on('change', function (e) {
            var value = parseInt($(this).val())
            if (value === 0) {
                assessor2.val(0).change()
                assessor3.val(0).change()
                assessor4.val(0).change()
                assessor5.val(0).change()
                assessor6.val(0).change()

                assorContainer2.hide()
                assorContainer3.hide()
                assorContainer4.hide()
                assorContainer5.hide()
                assorContainer6.hide()
            } else {
                assorContainer2.show()
            }
        })
        assessor2.on('change', function (e) {
            var value = parseInt($(this).val())
            if (value === 0) {
                assessor3.val(0).change()
                assessor4.val(0).change()
                assessor5.val(0).change()
                assessor6.val(0).change()

                assorContainer3.hide()
                assorContainer4.hide()
                assorContainer5.hide()
                assorContainer6.hide()
            } else {
                assorContainer3.show()
            }
        })
        assessor3.on('change', function (e) {
            var value = parseInt($(this).val())
            if (value === 0) {
                assessor4.val(0).change()
                assessor5.val(0).change()
                assessor6.val(0).change()

                assorContainer4.hide()
                assorContainer5.hide()
                assorContainer6.hide()
            } else {
                assorContainer4.show()
            }
        })
        assessor4.on('change', function (e) {
            var value = parseInt($(this).val())
            if (value === 0) {
                assessor5.val(0).change()
                assessor6.val(0).change()

                assorContainer5.hide()
                assorContainer6.hide()
            } else {
                assorContainer5.show()
            }
        })
        assessor5.on('change', function (e) {
            var value = parseInt($(this).val())
            if (value === 0) {
                assessor6.val(0).change()
                assorContainer6.hide()
            } else {
                assorContainer6.show()
            }
        })
        function isDisabledInput(isDisabled) {
            if (isDisabled === true) {
                $('#<%= trainingPlan.ClientID %>').prop("disabled", 'disabled')
                $('#<%= courseNumber.ClientID %>').prop('disabled', 'disabled')
                $('#<%= times.ClientID %>').prop('disabled', 'disabled')
                $('#<%= courseName.ClientID %>').prop('disabled', 'disabled')
                $('#<%= objective.ClientID %>').prop('disabled', 'disabled')
                $('#<%= startDate.ClientID %>').prop('disabled', 'disabled')
                $('#<%= endDate.ClientID %>').prop('disabled', 'disabled')
                $('#<%= startTime.ClientID %>').prop('disabled', 'disabled')
                $('#<%= endTime.ClientID %>').prop('disabled', 'disabled')
                $('#<%= totalHours.ClientID %>').prop('disabled', 'disabled')
                $('#<%= department.ClientID %>').prop('disabled', 'disabled')
                $('#<%= location.ClientID %>').prop('disabled', 'disabled')
                $('#<%= teacher.ClientID %>').prop('disabled', 'disabled')
                $('#<%= detail.ClientID %>').prop('disabled', 'disabled')
                $('#<%= Assessor1.ClientID %>').prop('disabled', 'disabled')
                $('#<%= Assessor2.ClientID %>').prop('disabled', 'disabled')
                $('#<%= Assessor3.ClientID %>').prop('disabled', 'disabled')
                $('#<%= Assessor4.ClientID %>').prop('disabled', 'disabled')
                $('#<%= Assessor5.ClientID %>').prop('disabled', 'disabled')
                $('#<%= Assessor6.ClientID %>').prop('disabled', 'disabled')
                $('#<%= hiddenId.ClientID %>').prop('disabled', 'disabled')
                $('#<%= realWorkEvaluate.ClientID %>').prop('disabled', 'disabled')
                $('#<%= examEvaluate.ClientID %>').prop('disabled', 'disabled')
                $('#<%= otherEvaluate.ClientID %>').prop('disabled', 'disabled')
                $('#<%= otherEvaluateRemark.ClientID %>').prop('disabled', 'disabled')
                $('.select-plan-container').find('div').find('button').prop("disabled", "disabled");
                $('.assessor-container-1').find('div').find('button').prop("disabled", "disabled");
                $('.assessor-container-2').find('div').find('button').prop("disabled", "disabled");
                $('.assessor-container-3').find('div').find('button').prop("disabled", "disabled");
                $('.assessor-container-4').find('div').find('button').prop("disabled", "disabled");
                $('.assessor-container-5').find('div').find('button').prop("disabled", "disabled");
                $('.assessor-container-6').find('div').find('button').prop("disabled", "disabled");

            } else {
                $('#<%= trainingPlan.ClientID %>').prop("disabled", false)
                $('#<%= courseNumber.ClientID %>').prop('disabled', false)
                $('#<%= times.ClientID %>').prop('disabled', false)
                $('#<%= courseName.ClientID %>').prop('disabled', false)
                $('#<%= objective.ClientID %>').prop('disabled', false)
                $('#<%= startDate.ClientID %>').prop('disabled', false)
                $('#<%= endDate.ClientID %>').prop('disabled', false)
                $('#<%= startTime.ClientID %>').prop('disabled', false)
                $('#<%= endTime.ClientID %>').prop('disabled', false)
                $('#<%= totalHours.ClientID %>').prop('disabled', false)
                $('#<%= department.ClientID %>').prop('disabled', false)
                $('#<%= location.ClientID %>').prop('disabled', false)
                $('#<%= teacher.ClientID %>').prop('disabled', false)
                $('#<%= detail.ClientID %>').prop('disabled', false)
                $('#<%= Assessor1.ClientID %>').prop('disabled', false)
                $('#<%= Assessor2.ClientID %>').prop('disabled', false)
                $('#<%= Assessor3.ClientID %>').prop('disabled', false)
                $('#<%= Assessor4.ClientID %>').prop('disabled', false)
                $('#<%= Assessor5.ClientID %>').prop('disabled', false)
                $('#<%= Assessor6.ClientID %>').prop('disabled', false)
                $('#<%= hiddenId.ClientID %>').prop('disabled', false)
                $('#<%= realWorkEvaluate.ClientID %>').prop('disabled', false)
                $('#<%= examEvaluate.ClientID %>').prop('disabled', false)
                $('#<%= otherEvaluate.ClientID %>').prop('disabled', false)
                $('#<%= otherEvaluateRemark.ClientID %>').prop('disabled', false)
                $('.select-plan-container').find('div').find('button').removeProp("disabled", "disabled");
                $('.assessor-container-1').find('div').find('button').prop("disabled", false);
                $('.assessor-container-1').find('div').find('button').removeProp("disabled", "disabled");
                $('.assessor-container-2').find('div').find('button').removeProp("disabled", "disabled");
                $('.assessor-container-3').find('div').find('button').removeProp("disabled", "disabled");
                $('.assessor-container-4').find('div').find('button').removeProp("disabled", "disabled");
                $('.assessor-container-5').find('div').find('button').removeProp("disabled", "disabled");
                $('.assessor-container-6').find('div').find('button').removeProp("disabled", "disabled");
            }
        }

        function addCourseValidation() {
            // true === pass
            // false === validate error
            let notifyTitle = "แจ้งเตือน"

            // check plan or not plan
            if (!$('#<%= checkPlan.ClientID %>')[0].checked && !$('#<%= checkNotPlan.ClientID %>')[0].checked) {
                toasts(notifyTitle, "กรุณาเลือกรูปแบบแผนการอบรม")
                return false
            }

            if ($('#<%= courseName.ClientID %>').val().trim() === "") {
                toasts(notifyTitle, "กรุณาระบุชื่อหลักสูตร")
                return false
            }

            let startD = $('#<%= startDate.ClientID %>').val().trim()
            let endD = $('#<%= endDate.ClientID %>').val().trim()
            if (startD === "" || endD === "" || startD.length !== 10 || endD.length !== 10) {
                toasts(notifyTitle, "กรุณาระบุวันที่เริ่มและสิ้นสุดการอบรมให้ถูกต้อง")
                return false
            }

            let yearOfStartDate = parseInt(startD.split('/')[2])
            let yearOfEndDate = parseInt(startD.split('/')[2])
            if (yearOfStartDate < 2000 || yearOfStartDate > 2700 || yearOfEndDate < 2000 || yearOfEndDate > 2700) {
                toasts(notifyTitle, "กรุณาระบุวันที่เริ่มและสิ้นสุดการอบรมให้ถูกต้อง")
                return false
            }

            if ($('#<%= startTime.ClientID %>').val().trim() === "" || $('#<%= endTime.ClientID %>').val().trim() === "") {
                toasts(notifyTitle, "กรุณาระบุเวลาเริ่มและสิ้นสุดการอบรมให้ถูกต้อง")
                return false
            }

            // check assessor selected min 1 person
            if (assessor1.val() === "0") {
                toasts(notifyTitle, "กรุณาเลือกผู้อนุมัติอย่างน้อย 1 คน")
                return false
            }

            return true;
        }
    </script>
</asp:Content>
