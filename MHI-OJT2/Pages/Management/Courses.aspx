<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Courses" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/timepicker.js/latest/timepicker.min.css" rel="stylesheet" />
    <style type="text/css">
        input[type=checkbox], input[type=radio] {
            width: 20px !important;
            height: 20px !important;
        }

        .bootstrap-select > .dropdown-toggle {
            background-color: #fff !important;
            border: 1px solid #ced4da !important;
            border-radius: .25rem !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
             font-weight: 400 !important; 
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
                        <button type="button" class="btn btn-primary" onclick="handleShowAddModal('add')">สร้างหลักสูตร</button>
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
                                <th class="text-center">รายละเอียด</th>
                                <th>รหัสหลักสูตร</th>
                                <th>ชื่อหลักสูตร</th>
                                <th>ผู้จัดทำ</th>
                                <th>วันที่เริ่มอบรม</th>
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
                                            <button type="button" class="btn btn-sm btn-primary" onclick="handleEditCourse(<%# Eval("COURSE_ID") %>)">แก้ไข</button>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-sm btn-link" onclick="handleViewCourseDetail(<%# Eval("COURSE_ID") %>)">แสดง</button>
                                        </td>
                                        <td><%# Eval("COURSE_NUMBER") %></td>
                                        <td><%# Eval("COURSE_NAME") %></td>
                                        <td><%# Eval("CREATED_NAME") %></td>
                                        <td><%# String.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd MMM yyyy}", Eval("START_DATE")) %></td>
                                        <td class="text-center">
                                            <button type="button" class='<%# (int)Eval("STATUS_CODE") == 1 ? "btn btn-sm btn-primary" : (int)Eval("STATUS_CODE") == 2 ? "btn btn-sm btn-warning" : (int)Eval("STATUS_CODE") == 9 ? "btn btn-sm btn-success" : (int)Eval("STATUS_CODE") == 10 ? "btn btn-sm btn-danger" : "btn btn-sm btn-secondary" %>' onclick="handleShowModal(<%# Eval("COURSE_ID") %>,'<%# (int)Eval("STATUS_CODE")== 1 ? "add-employee" : (int)Eval("STATUS_CODE")== 2 ? "evaluate" : "view-status" %>')" style="width: 220px !important;">
                                                <%# Eval("STATUS_TEXT") %>
                                            </button>
                                        </td>
                                        <td class="text-center">
                                            <asp:Button ID="btnExportReport" CommandName="EXPORT_REPORT_MANAGE_COURSE" Text="Training/Evaluation OJT" runat="server" CommandArgument='<%# Eval("COURSE_ID") %>' CssClass="btn btn-sm btn-success" Enabled='<%# (int)Eval("STATUS_CODE") >= 3 ? true : false %>' />
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
            <div class="modal-content dark-mode">
                <div class="modal-header">
                    <h5 class="modal-title" id="addModalTitle"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="text-light">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
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
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>รหัสหลักสูตร</label>
                            <input type="text" class="form-control" id="courseNumber" runat="server">
                        </div>
                        <div class="form-group col-md-6">
                            <label>ครั้งที่</label>
                            <input type="text" class="form-control" id="times" runat="server">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>ชื่อหลักสูตร</label>
                        <input type="text" class="form-control" id="courseName" runat="server">
                    </div>
                    <div class="form-group">
                        <label>วัตถุประสงค์</label>
                        <textarea class="form-control" id="objective" rows="3" runat="server"></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>วันที่เริ่มอบรม</label>
                            <input type="tel" id="startDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                        </div>
                        <div class="form-group col-md-6">
                            <label>วันที่สิ้นสุด</label>
                            <input type="tel" id="endDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>เวลาเริ่ม</label>
                            <input type="time" class="form-control" id="startTime" runat="server" />
                        </div>
                        <div class="form-group col-md-4">
                            <label>เวลาสิ้นสุด</label>
                            <input type="time" class="form-control" id="endTime" runat="server" />
                        </div>
                        <div class="form-group col-md-4">
                            <label>รวมจำนวนชั่วโมง</label>
                            <input type="number" class="form-control" id="totalHours" min="0" max="24" runat="server">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>แผนก</label>
                        <select class="form-control" id="department" runat="server">
                            <option selected>-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>สถานที่ฝึกอบรม</label>
                        <select class="form-control" id="location" runat="server">
                            <option selected>-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>วิทยากร</label>
                        <select class="form-control" id="teacher" runat="server">
                            <option selected>-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>รายละเอียด</label>
                        <textarea class="form-control" id="detail" rows="3" runat="server"></textarea>
                    </div>
                    <div class="assessor-container-all">
                        <div class="form-group assessor-container-1">
                            <label>ผู้อนุมัติคนที่ 1</label>
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
                    <button type="button" runat="server" id="btnDelete" class="btn btn-danger mr-auto" onserverclick="btnDelete_ServerClick" style="display: none;">ลบ</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด</button>
                    <button type="button" runat="server" id="btnEdit" class="btn btn-primary" onserverclick="btnEdit_Click" style="display: none;">บันทึก</button>
                    <button type="button" runat="server" id="btnInserted" class="btn btn-primary" onserverclick="btnInserted_Click" style="display: none;">บันทึก</button>
                    <input type="hidden" runat="server" id="hiddenId" />
                    <input type="hidden" runat="server" id="hiddenCourseAndPlanId" />
                </div>
            </div>
        </div>
    </div>
    <%-- add employee modal --%>
    <div class="modal fade" id="addEmployeeModal" tabindex="-1" aria-labelledby="addModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-xl" style="box-shadow: none !important;">
            <div class="modal-content dark-mode">
                <div class="modal-header">
                    <h5 class="modal-title text-light">เลือกพนักงานเข้าฝึกอบรม</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="height: 575px !important;">
                    <div class="transfer"></div>
                </div>
                <div class="modal-footer" style="justify-content: end !important;">
                    <button type="button" id="btnScanBarcode" runat="server" class="btn btn-warning d-none" onserverclick="btnScanBarcode_ServerClick">Scan Barcode</button>
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
            <div class="modal-content dark-mode">
                <div class="modal-header">
                    <h5 class="modal-title text-light">ตรวจสอบสถานะการอนุมัติ</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
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

        function handleShowAddModal() {
            $('#<%= btnInserted.ClientID %>').show()
            $('#<%= btnEdit.ClientID %>').hide()

            isDisabledInput(false)

            assessor1.val(0).change()
            $('.assessor-container-all').show()
            $('#addModalTitle').text('Add course')
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
                        url: "/Pages/Management/Courses.aspx/CreateSessionToEvaluate",
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
                        url: "/Pages/Management/Courses.aspx/GetApprovalList",
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
                    url: "/Pages/Management/Courses.aspx/InsertEmployee",
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
                url: "/Pages/Management/Courses.aspx/GetEmployeeList",
                data: data,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
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

        function handleEditCourse(courseId) {
            $.ajax({
                type: "POST",
                url: "/Pages/Management/Courses.aspx/GetCourseDetailById",
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
                url: "/Pages/Management/Courses.aspx/GetCourseDetailById",
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
                $('#addModalTitle').text('Course detail')
                $('#<%= btnInserted.ClientID %>').hide()
                $('#<%= btnEdit.ClientID %>').hide()
                $('#<%= btnDelete.ClientID %>').show()
                isDisabledInput(true)
                $('.assessor-container-all').show()
            }

            if (type === 'edit') {
                $('#addModalTitle').text('Edit course')
                $('#<%= btnEdit.ClientID %>').show()
                $('#<%= btnInserted.ClientID %>').hide()
                isDisabledInput(false)
            }

            $('#<%= checkPlan.ClientID %>').prop('checked', data.PLAN_ID !== null ? true : false);
            $('#<%= checkNotPlan.ClientID %>').prop('checked', data.PLAN_ID === null ? true : false);
            $('#<%= checkPlan.ClientID %>').attr('disabled', true);
            $('#<%= checkNotPlan.ClientID %>').attr('disabled', true);

            if (data.PLAN_ID !== null) {
                $('#<%= trainingPlan.ClientID %>').val(data.PLAN_ID).change()
                $('.select-plan-container').find('div').find('button').removeClass('disabled')
            }

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
            $('#<%= btnDelete.ClientID %>').hide()
            $('.assessor-container-all').hide()

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
            $('#<%= Assessor1.ClientID %>').val('-').change()
            $('#<%= Assessor2.ClientID %>').val('-').change()
            $('#<%= Assessor3.ClientID %>').val('-').change()
            $('#<%= Assessor4.ClientID %>').val('-').change()
            $('#<%= Assessor5.ClientID %>').val('-').change()
            $('#<%= Assessor6.ClientID %>').val('-').change()
            $('#<%= hiddenId.ClientID %>').val('')
            $('#<%= hiddenCourseAndPlanId.ClientID %>').val('')
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
        assessor5.on
        function isDisabledInput(isDisabled) {
            let readOnlyColor = "background-color: #e9ecef !important;"
            let openInputColor = "background-color: #fff !important;"
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
                $('.select-plan-container').find('div').find('button').css("cssText", readOnlyColor);
                $('.assessor-container-1').find('div').find('button').css("cssText", readOnlyColor);
                $('.assessor-container-2').find('div').find('button').css("cssText", readOnlyColor);
                $('.assessor-container-3').find('div').find('button').css("cssText", readOnlyColor);
                $('.assessor-container-4').find('div').find('button').css("cssText", readOnlyColor);
                $('.assessor-container-5').find('div').find('button').css("cssText", readOnlyColor);
                $('.assessor-container-6').find('div').find('button').css("cssText", readOnlyColor);
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
                $('.select-plan-container').find('div').find('button').css("cssText", openInputColor);
                $('.assessor-container-1').find('div').find('button').css("cssText", openInputColor);
                $('.assessor-container-2').find('div').find('button').css("cssText", openInputColor);
                $('.assessor-container-3').find('div').find('button').css("cssText", openInputColor);
                $('.assessor-container-4').find('div').find('button').css("cssText", openInputColor);
                $('.assessor-container-5').find('div').find('button').css("cssText", openInputColor);
                $('.assessor-container-6').find('div').find('button').css("cssText", openInputColor);
            }
        }
    </script>
</asp:Content>
