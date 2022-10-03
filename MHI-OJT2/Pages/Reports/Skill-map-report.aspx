<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Skill-map-report.aspx.cs" Inherits="MHI_OJT2.Pages.Reports.Skill_map_report" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        table.rotate-table-grid {
            box-sizing: border-box;
            border-collapse: collapse;
            width: 100% !important;
        }

        .rotate-table-grid tr, .rotate-table-grid td, .rotate-table-grid th {
            border: 1px solid grey !important;
            position: relative;
            padding: 5px;
        }

        .rotate-table-grid th span {
            transform-origin: 0 50%;
            transform: rotate(-90deg);
            white-space: nowrap;
            display: block;
            position: absolute;
            bottom: 0;
            left: 50%;
        }

        #table-skill-map thead {
            font-size:25px !important;
        }

        #table-skill-map tbody {
            font-size:22px !important;    
        }

        .main__div {
            display: flex;
            justify-content: center;
            font-size: 22px !important;
        }

        .main__div div {
            border: 1px solid grey;
            border-right: 0;
            border-bottom: 0;
            text-align: center;
            padding: 0.5rem 0;
            height: 175px;
            width: 145px;
        }

        .main__div div:last-child {
            border-right: 1px solid grey;
        }

        .main__div div span {
            text-align: center;
            padding: 0.3rem;
        }

        .main__div div hr {
            border-top: 1px solid grey;
        }

        .main__div div pre {
            padding: 0 10px;
            border: 0;
        }

        .div__footer {
            padding-top: 15px;
        }

        ul {
            margin: 0;
            padding: 0;
        }

        ul li {
            padding: 5px 0;
            display: flex;
            align-items: center;
        }

        .daigonal {
            width:300px;
            color: grey;
        }
        svg {
            position: absolute;
            width: 100%;
            height: 100%;
            color: grey;
        }

        #print_me * {
            font-family: 'AngsanaUPC' !important;
        }

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
    <style type="text/css" media="print">
        @page {
            size: landscape;
            margin: 1.5rem 1.5rem;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">รายงาน Skill map</h1>
                </div>
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container-fluid -->
    </div>

    <!-- Main content -->
    <div class="content">
        <div class="container-fluid align-items-stretch h-100">
            <div class="card card-primary">
                <div class="card-header">
                    <h3 class="card-title">เลือกเงื่อนไขเพื่อออกรายงาน</h3>
                </div>
                <div class="card-body">
                    <div class="form-group col">
                        <label for='<%= section.ClientID %>'>เลือกแผนก</label>
                        <select class="form-control" id="section" runat="server">
                        </select>
                    </div>
                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <label for='<%= section.ClientID %>'>ช่วงวันที่เริ่มอบรม</label>
                                <input type="tel" id="startDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label for='<%= section.ClientID %>'>ถึง</label>
                                <input type="tel" id="endDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                    </div>
                    <hr style="border-top: 1px solid #6c757d" />
                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <label>วันที่ประเมินผล Evaluate</label>
                                <input type="tel" id="evaluate_date" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label>Prepared By</label>
                                <input type="text" id="prepared_by" class="form-control" placeholder="Prepared By" value="" />
                            </div>
                            <div class="form-group">
                                <label>Prepared Date</label>
                                <input type="tel" id="prepared_date" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label>Reviewed By</label>
                                <input type="text" id="revieweb_by" class="form-control" placeholder="Reviewed By" />
                            </div>
                            <div class="form-group">
                                <label>Reviewed Date</label>
                                <input type="tel" id="revieweb_date" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label>Approved By</label>
                                <input type="text" id="approved_by" class="form-control" placeholder="Approved By" />
                            </div>
                            <div class="form-group">
                                <label>Approved Date</label>
                                <input type="tel" id="approved_date" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-footer">
                    <button type="button" id="btnDownloadReport" class="btn btn-success btn-block" onclick="PrepareReport()">เลือกหลักสูตร</button>
                </div>
            </div>
            <div class="card" id="card-print">
                <div class="card-body page" id="print_me">
                    <div class="d-flex justify-content-between" style="padding-bottom: 15px; vertical-align: middle;">
                        <img src="../../Reports/Pic/OJTlogo-report.png" />
                        <h1 style="font-size: 29px !important; font-weight: bold;">MHI Automotive climate control (Thailand) Co., Ltd.</h1>
                        <span style="font-size: 22px; font-weight: bold; width: 221px; text-align: right;">(HR-T-05)</span>
                    </div>
                    <div class="d-flex justify-content-between" style="vertical-align: middle;">
                        <div class="section__wrap d-flex align-items-end">
                            <h3 style="font-size: 25px !important; font-weight: bold; width: 580px;">แผนก(Section) : <span id="report_section"></span></h3>
                        </div>
                        <h2 style="font-size: 27px !important; font-weight: bold;">รายงานผลแสดงความสามารถของพนักงาน (Skill Map Result Report)</h2>
                        <div class="main__div">
                            <div>
                                <span>วันที่ประเมิน
                                     Evaluate
                                </span>
                                <hr />
                                <pre style="margin-top: 2.6rem;" id="report_evaluate_date"> </pre>
                            </div>
                            <div>
                                <span>Prepared By 
                                </span>
                                <hr />
                                <pre id="report_prepared_by"> </pre>
                                <hr />
                                <pre id="report_prepared_date"> </pre>
                            </div>
                            <div>
                                <span>Reviewed By
                                </span>
                                <hr />
                                <pre id="report_reviewed_by"> </pre>
                                <hr />
                                <pre id="report_reviewed_date"> </pre>
                            </div>
                            <div>
                                <span>Approved By
                                </span>
                                <hr />
                                <pre id="report_approved_by"> </pre>
                                <hr />
                                <pre id="report_approved_date"> </pre>
                            </div>
                        </div>
                    </div>
                    <table class="rotate-table-grid" id="table-skill-map" style="width: 100% !important;">
                        <thead>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        </tfoot>
                    </table>
                    <div class="div__footer" style="font-size: 20px;">
                        <div class="row">
                            <div class="col-3">
                                <ul style="list-style:none;">
                                    <li>
                                        <img src="~/Reports/Pic/0_19_NOT_STAR.png" width="50" height="47" runat="server" />
                                        <span>= (0 คะแนน) ยังไม่มีทักษะในการปฏิบัติ Unskillful.</span>
                                    </li>
                                    <li>
                                        <img src="~/Reports/Pic/20_25_NOT_STAR.png" width="50" height="47" runat="server" />
                                        <span>= (20-25 คะแนน) ทราบทฤษฎีเบื้องต้นเท่านั้น Only theoretically.</span>
                                    </li>
                                    <li >
                                        <img src="~/Reports/Pic/26_50_NOT_STAR.png" width="50" height="47" runat="server" />
                                        <span>= (26-50 คะแนน) สามารถปฏิบัติงานได้ภายใต้การควบคุมของหัวหน้างาน Can work under Leader.</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-3">
                                <ul style="list-style:none;">
                                    <li >
                                        <img src="~/Reports/Pic/51_75.png" width="50" height="47" runat="server" />
                                        <span>= (51-75 คะแนน) สามารถปฏิบัติงานได้ด้วยตัวเอง Can work by himself.</span>
                                    </li>
                                    <li >
                                        <img src="~/Reports/Pic/76_100.png" width="50" height="47" runat="server" />
                                        <span> = (76-100 คะแนน) สามารถปฏิบัติงานได้ด้วยตนเองและถ่ายทอดให้ผู้อื่นได้ Can work by himself & Can teach others.</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-3">
                                <ul style="list-style:none;">
                                    <li >
                                        <img src="~/Reports/Pic/0_19_NOT_STAR.png"  width="50" height="47" runat="server" /> 
                                        วงใน คือ เป้าหมาย อ้างอิงตามตารางมาตรฐานกำหนดความสามารถของพนักงาน (FR-HR01-019) Inside circle : Target  Ref.to Competency Mapping Standard (FR-HR01-019)
                                    </li>
                                    <li>
                                        <img src="~/Reports/Pic/WONG_NAI.png"  width="50" height="47" runat="server" /> 
                                        วงนอก : ปฏิบัติได้จริง Outside circle : Actual
                                    </li>
                                </ul>
                            </div>
                            <div class="col-3 d-flex">
                                <span style="white-space:nowrap; margin: 5px 5px 0 0;">Note : </span>
                                <ul style="width: 100%">
                                    <li style="width: 100%">1. ประเมินพนักงานใหม่ ต้องทำการประเมินภายในวันที่ 91 Probation period. The evaluation will do within 91st of Probation period since start working</li>
                                    <li style="width: 100%">2. ประเมินพนักงานหลังบรรจุเป็นพนักงานประจำแล้ว โดยต้องทำการประเมินทุก 6 เดือน After Passed Probation. Re-Evaluation every 6 months (2 times/year)</li>
                                    <li style="width: 100%">3. ต้นสังกัด จัดเก็บไฟล์อิเล็กทรอนิกส์ (Each section keep eclectronic file)</li>
                                </ul>
                            </div>
                        </div>
                        <div class="row justify-content-end" style="padding-right:8px;">
                            <b>FR-HR01-007 ED:22-Jan-19 (Rev.00)</b>   
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="chooseCourseModal" tabindex="-1" aria-labelledby="addModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-xl" style="box-shadow: none !important;">
            <div class="modal-content ">
                <div class="modal-header">
                    <h5 class="modal-title ">เลือกหลักสูตรที่ต้องการแสดงผลในรายงาน</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="height: 575px !important;">
                    <div class="transfer"></div>
                </div>
                <div class="modal-footer" style="justify-content: end !important;">
                    <div class="action-button-area">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" onclick="GetReportData()" style="width: 80px !important;">Print</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ModalContent" ContentPlaceHolderID="modal" runat="server">
</asp:Content>
<asp:Content ID="ScriptContent" ContentPlaceHolderID="script" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.8.1/html2pdf.bundle.min.js" integrity="sha512-vDKWohFHe2vkVWXHp3tKvIxxXg0pJxeid5eo+UjdjME3DBFBn2F8yWOE0XmiFcFbXxrEOR1JriWEno5Ckpn15A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script type="text/javascript">
        (function () {
            let today = moment();
            let currentYears = today.year();
            let startDate = moment(`${currentYears}-01-01`);
            let endDate = moment(`${currentYears}-12-31`);
            $('#<%= startDate.ClientID %>').val(startDate.format("DD/MM/YYYY"))
            $('#<%= endDate.ClientID %>').val(endDate.format("DD/MM/YYYY"))

            $('#card-print').hide()
        })();

        var dualBox; 

        function PrepareReport() {
            var depId = $('#<%= section.ClientID %>').val()

            if (depId) {
                iniTransferBox(depId)
            } else {
                Swal.fire("Somthing went wrong!", "", "error")
                return false;
            }
        }

        function iniTransferBox(departmentId) {
                var sD = $('#<%= startDate.ClientID %>').val()
                var eD = $('#<%= endDate.ClientID %>').val()

                if (!moment(sD, "DD/MM/YYY", true).isValid() || !moment(eD, "DD/MM/YYYY", true).isValid()) {
                    Swal.fire("ผิดพลาด", "รูปแบบวันที่ไม่ถูกต้อง", 'error')
                    return;
                }

                if (moment(eD, "DD/MM/YYYY").diff(moment(sD, "DD/MM/YYYY")) < 0) {
                    Swal.fire("ผิดพลาด", "วันที่เริ่มต้นมากกว่าวันที่สิ้นสุด", 'error')
                    return;
                }
            

                $('#chooseCourseModal').modal('show')
                $(".transfer-double").remove()
                var courseLists = []
                var data = "{'departmentId': " + departmentId + ", 'startDate': '" + sD + "', 'endDate': '" + eD + "' }"
                $.ajax({
                    type: "POST",
                    url: "<%= ajax %>" + "/Pages/Reports/Skill-map-report.aspx/GetCourseList",
                    data: data,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (results) {
                        courseLists = JSON.parse(results.d)
                        var settings = {
                            itemName: "courseName",
                            valueName: "courseId",
                            tabNameText: "เลือกหลักสูตร",
                            rightTabNameText: "หลักสูตรที่เลือก",
                            searchPlaceholderText: "ค้นหาหลักสูตร",
                            dataArray: courseLists,
                        };
                        dualBox = $(".transfer").transfer(settings);
                    },
                    error: function (err) {
                        console.log(err)
                    }
                });
        }

        function GetReportData() {
            let selectedList = dualBox.getSelectedItems()
            console.log(selectedList)
            let strCourseLists = ''

            for (i = 0; i < selectedList.length; i++) {
                if (strCourseLists.length > 0) {
                    strCourseLists += ',' + selectedList[i].courseId

                } else {
                    strCourseLists = selectedList[i].courseId
                }
            }

            if (strCourseLists.length <= 0) {
                Swal.fire("กรุณาเลือกหลักสูตรอย่างน้อย 1 หลักสูตร", "", "error")
                return false
            }
            

            let startDate = $('#<%= startDate.ClientID %>').val()
            let endDate = $('#<%= endDate.ClientID %>').val()
            let section = $('#<%= section.ClientID %>').val()
            let body = `{ 'sectionId': ${section}, 'startDate' : '${startDate}', 'endDate': '${endDate}', 'courseList': '${strCourseLists}'}`


            $('#report_section').text($('#<%= section.ClientID %> option:selected').text())

            $('#report_evaluate_date').text($('#evaluate_date').val() === "" ? "  " : $('#evaluate_date').val())

            $('#report_prepared_by').text($('#prepared_by').val() === "" ? "  " : $('#prepared_by').val())
            $('#report_prepared_date').text($('#prepared_date').val() === "" ? "  " : $('#prepared_date').val())

            $('#report_reviewed_by').text($('#revieweb_by').val() === "" ? "  " : $('#revieweb_by').val())
            $('#report_reviewed_date').text($('#revieweb_date').val() === "" ? "  " : $('#revieweb_date').val())

            $('#report_approved_by').text($('#approved_by').val() === "" ? "  " : $('#approved_by').val())
            $('#report_approved_date').text($('#approved_date').val() === "" ? "  " : $('#approved_date').val())

            $.ajax({
                type: "POST",
                 url: "<%= ajax %>" + "/Pages/Reports/Skill-map-report.aspx/GetReportData",
                data: body,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    var promises = [];
                    let data = JSON.parse(results.d)
                    if (!data.length) {
                        Swal.fire("ไม่พบหลักสูตรการอบรม", "", "error")
                        return
                    }

                    // clear old data
                    $('table thead tr').remove()
                    $('table tbody tr').remove()
                    $('table tfoot tr').remove()

                    let tableThead = $('table thead')
                    let tableBody = $('table tbody')
                    let keyNames = Object.keys(data[0]);
                    let rowWithKey = []
                    let departmentGroup = []


                    let tableHeader = `<tr id="table-row-department" style="height: 70px !important; padding: 0; margin: 0;">
                                          <th class="text-center" rowspan="2" style="width: 10px;">No.</th>
                                          <td class="diagonal" colspan="3" style="padding: 0; margin: 0;">
                                            <span style="position: absolute; top: 0; left: 0; margin: 0 10px;"><b>Process Description</b></span>
                                            <span style="position: absolute; bottom: 0; right: 0; margin: 0 10px;"><b>Employee</b></span>
                                            <svg viewBox="0 0 10 10" preserveAspectRatio="none" style="top: 0">
                                                <line x1="10" y1="0" x2="0" y2="10" stroke="grey" stroke-width="0.03"></line>
                                            </svg>
                                          </td>`

                    for (let i = 4; i >= 4 && i <= (keyNames.length - 5); i++) {
                        var request = $.ajax({
                            type: "POST",
                             url: "<%= ajax %>" + "/Pages/Reports/Skill-map-report.aspx/GetDepartmentName",
                            data: `{ 'courseId': ${keyNames[i].split("|")[1]} }`,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: (results) => {
                                let department = String(results.d)
                                console.log("department : ", department)
                                tableHeader += `<td class="${department.replace(/[^a-zA-Z ]/g, "").replace(/ +/g, "")}" style="text-align: center;">
                                                    <b>${department}</b>
                                                </td>`
                                departmentGroup.push(department)
                            },
                            error: function (err) {
                                console.log(err)
                            }
                        })
                        promises.push(request);
                    }
                    $.when.apply(null, promises).done(() => {
                        tableHeader += `<td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>`
                        tableHeader += `</tr>`
                        tableHeader += `<tr>`
                        for (let i = 0; i < keyNames.length; i++) {
                            if (i === 0) {
                                // emp code
                                tableHeader += `<th class="text-center" style="width: 25px !important;">
                                                    EMP.<br/>CODE
                                                </th>`
                            } else if (i === keyNames.length - 5 + 4) {
                                // ระบุจำนวนงาน(Specify job no.)  จำนวนงานที่ไม่ถึงเกณฑ์ต้องติดตาม (No.of Job to Follow up)
                                tableHeader += `<th style="width: 75px !important">
                                                    <span style="bottom: -25px !important;">
                                                     ${keyNames[i]} <br/> จำนวนงานที่ไม่ถึงเกณฑ์ต้องติดตาม (No.of Job to Follow up)
                                                    <span>
                                                </th>`
                            } else if (i === keyNames.length - 5 + 3) {
                                // (B / A * 100)  เปอร์เซ็นต์ของจำนวนงานที่ผ่าน (Percentage of actual)
                                tableHeader += `<th style="width: 75px !important">
                                                    <span style="bottom: -25px !important;">
                                                     ${keyNames[i]} <br/> เปอร์เซ็นต์ของจำนวนงานที่ผ่าน (Percentage of actual)
                                                    <span>
                                                </th>`
                            } else if (i === keyNames.length - 5 + 1 || i === keyNames.length - 5 + 2) {
                                // plan A and plan B จำนวนงาน / คน   (Job / Person)
                                tableHeader += `<th style="width: 75px !important">
                                                    <span style="bottom: -25px !important;">
                                                     ${keyNames[i]} <br/> จำนวนงาน / คน   (Job / Person)
                                                    <span>
                                                </th>`
                            } else if (i > keyNames.length - 5) {
                                tableHeader += `<th class="text-center" style="width: 40px !important;">
                                                    <span>
                                                     ${keyNames[i]}
                                                    <span>
                                                </th>`

                            } else if (i > 3 && i <= keyNames.length - 5) {
                                // course name
                                tableHeader += `<th> 
                                                    <span>
                                                        ${keyNames[i].split("|")[0]}
                                                    </span>
                                                </th>`
                            } else if (i === 1) {
                                // name and start working
                                tableHeader += `<th style="text-align: center; padding: 0 !important; width: 80px !important;">
                                                <div>Name</div>
                                                <hr style="border-top: 1px solid grey; margin-top: 1.5rem; margin-bottom: 1.5rem;"/>
                                                <div>Start working</div>
                                            </th>`

                            } else if (i === 2) {
                            } else {
                                // position
                                tableHeader += `<th style="text-align: center; width: 200px !important;">
                                                ${keyNames[i]}
                                            </th>`
                            }

                        }
                        tableHeader += `</tr>`
                        tableThead.append(tableHeader)

                        for (let i = 0; i < data.length; i++) {
                            let tableRow = `<tr style="vertical-align: middle;">`
                            let row = data[i]
                            row.key = function (n) {
                                return this[Object.keys(this)[n]];
                            }
                            rowWithKey.push(row)
                            for (let j = 0; j < Object.keys(row).length; j++) {
                                // for No.
                                if (j === 0) {
                                    tableRow += `<td class="text-center">${i + 1}</td>`
                                }
                                let nameIsNull = row.key(1) === ""
                                let name = nameIsNull === true ? "0" : row.key(1)
                                let date = moment(row.key(2)).format("D/M/YY")
                                if (j > 3 && j <= (keyNames.length - 5)) {
                                    let picName = ""

                                    if (row.key(j) !== null) {
                                        let score = row.key(j) ?? 0
                                        if (score >= 20 && score <= 25) {
                                            picName = "20_25"

                                        } else if (score >= 26 && score <= 50) {
                                            picName = "26_50"

                                        } else if (score >= 51 && score <= 75) {
                                            picName = "51_75"

                                        } else if (score >= 76 && score <= 100) {
                                            picName = "76_100"

                                        } else {
                                            picName = "0_19"

                                        }

                                        tableRow += `<td style="padding: 0; margin: 0; text-align: center;">
                                                        <img src="../../Reports/Pic/${picName}.png" width="50" height="47"/>
                                                     </td>`

                                    } else {
                                        // score null or employee is not in course
                                        tableRow += `<td style="padding: 0; margin: 0; text-align: center;">
                                                            <span style="width:50px; height:47px;"></span>
                                                     </td>`
                                    }

                                } else if (j === 1) {
                                    tableRow += `<td style="text-align: center; padding: 0 !important; vertical-align: middle; white-space: nowrap !important;">
                                                ${nameIsNull === true ? `<pre style="margin-bottom: unset; padding: 10.77px;"> </pre>` : `<div style="padding: 10px;">${name}</div>`}
                                                <hr style="border-top: 1px solid grey; margin: 0;"/>
                                                <div style="padding: 10px">${date}</div>
                                             </td>`

                                } else if (j === 2) {
                                } else {
                                    tableRow += `<td class="text-center" >${j === 2 ? date : (row.key(j) ?? 0)}</td>`
                                }
                            }
                            tableRow += `</tr>`
                            tableBody.append(tableRow)

                        }

                        // remove key columns
                        let tableTR = $('table tr')
                        tableTR.find('td:last-child').remove()

                        // table footer count plan and actual 
                        let rowFooter = `<tr style="font-size: 22px;">
                                        <td
                                            colspan="3"
                                            rowspan="2"
                                            style="vertical-align: middle; text-align:center; padding: 0.25rem 0 !important; border: 1px solid grey;"
                                          >
                                            จำนวนคนทดแทน / งาน
                                            <br/>
                                            (Compensate Person / Job)
                                          </td>
                                          <td rowspan="2" colspan="1" style="vertical-align: middle; text-align:center; padding: 0.25rem 0 !important; border: 1px solid grey;">
                                            <span>Plan</span>
                                            <hr style="margin: 2px 0 !important; border-top: 1px solid grey;" />
                                            <span>Actual</span>
                                          </td>`
                        for (let i = 4; i >= 4 && i <= (keyNames.length - 5); i++) {
                            let actualSummary = 0;
                            for (let k = 0; k < Object.keys(rowWithKey).length; k++) {
                                if (rowWithKey[k].key(i) > 50) {
                                    actualSummary += 1
                                }
                            }
                            rowFooter += `<td style="text-align:center; padding: 0.25rem 0 !important; border: 1px solid grey;">
                                            <span>${rowWithKey.length}</span>
                                            <hr style="margin: 2px 0 !important; border-top: 1px solid grey;" />
                                            <span>${actualSummary}</span>
                                      </td>`
                        }
                        rowFooter += `<td></td>
                                  <td></td>
                                  <td></td><td></td>`
                        rowFooter += `</tr>
                                  <tr></tr>`
                        tableBody.append(rowFooter)

                        // row fix value
                        let rowFixValue = `<tr style="font-size: 22px;">
                                        <td colspan="4" style="text-align:center; padding: 0.1rem 0 !important; border: 1px solid grey;">
                                                คะแนนเต็ม (Full Scores)
                                        </td>`

                        for (let i = 5; i > 4 && i <= (keyNames.length - 4); i++) {
                            rowFixValue += `<td style="text-align:center; padding: 0.25rem 0 !important; border: 1px solid grey;">
                                            4
                                        </td>`
                        }
                        rowFixValue += `<td></td>
                                    <td></td>
                                    <td style="text-align: center;">100</td>
                                    <td></td>`
                        rowFixValue += `</tr>`
                        tableBody.append(rowFixValue)


                        var header_height = 450;
                        $('.rotate-table-grid th span').each(function () {
                            var strLen = $(this).text().trim().length
                            var calHeight = strLen * 7.5

                            console.log(strLen)
                            console.log(calHeight)
                            if (calHeight > header_height) {
                                header_height = calHeight
                            }
                        });
                        $('.rotate-table-grid th').height(header_height);

                        // auto merge department
                        $('#table-row-department td').each(function () {
                            $(this).each(function () {
                                if ($(this).attr('class')) {
                                    var cls = $(this).attr('class'),
                                        nextCells = $(this).nextUntil('td:not(.' + cls + ')'),
                                        colspan = nextCells.length + 1;
                                    if (colspan > 1) {
                                        $(this).attr('colspan', colspan);
                                        nextCells.remove();
                                    }
                                }
                            });
                        });

                        $('#print_me').printThis({
                            importCSS: true,
                            importStyle: true
                        });

                        $('#card-print').hide()
                    })
                }
            });
        }
    </script>
</asp:Content>
