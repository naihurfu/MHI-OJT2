<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Skill-map-report.aspx.cs" Inherits="MHI_OJT2.Pages.Reports.Skill_map_report" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        table.rotate-table-grid {
            box-sizing: border-box;
            border-collapse: collapse;
            width: 100% !important;
        }

        .rotate-table-grid tr, .rotate-table-grid td, .rotate-table-grid th {
            border: 1px solid black !important;
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

        .main__div {
            display: flex;
            justify-content: center;
            font-size: 14px;
        }

        .main__div div {
            border: 1px solid black;
            text-align: center;
            padding: 0.5rem 0;
            height: 145px;
        }

        .main__div div span {
            text-align: center;
            padding: 0.3rem;
        }

        .main__div div hr {
            border-top: 1px solid black;
        }

        .main__div div:not(:first-child) hr {
            border-bottom: 1px solid black;
            height: 45px;
        }

        .div__footer {
            padding-top: 15px;
        }

        ul li {
            padding: 5px 0;
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
                    <div class="form-group">
                        <label for='<%= section.ClientID %>'>เลือกฝ่าย</label>
                        <select class="form-control" id="section" runat="server">
                        </select>
                    </div>
                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <label for='<%= section.ClientID %>'>วันที่เริ่มอบรม</label>
                                <input type="tel" id="startDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label for='<%= section.ClientID %>'>วันที่สิ้นสุดการอบรม</label>
                                <input type="tel" id="endDate" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-footer">
                    <button type="button" id="btnDownloadReport" class="btn btn-primary btn-block" onclick="GetReportData()">ดาวน์โหลดรายงาน</button>
                </div>
            </div>
            <div class="card">
                <div class="card-body page" id="print_me">
                    <div class="d-flex justify-content-between" style="padding-bottom: 15px; vertical-align: middle;">
                        <img src="../../Reports/Pic/OJTlogo-report.png" />
                        <h3>MHI Automotive climate control (Thailand) Co., Ltd.</h3>
                        <span>(HR-T-05)</span>
                    </div>
                    <div class="d-flex justify-content-between" style="vertical-align: middle;">
                        <div class="section__wrap d-flex align-items-end">
                            <h5>แผนก(Section) : <%= section.Value %></h5>
                        </div>
                        <h4>รายงานผลแสดงความสามารถของพนักงาน (Skill Map Result Report)</h4>
                        <div class="main__div">
                            <div>
                                <span>วันที่ประเมิน
                                     Evaluate
                                </span>
                                <hr />
                            </div>
                            <div>
                                <span>Prepared By 
                                </span>
                                <hr />

                            </div>
                            <div>
                                <span>Reviewed By
                                </span>
                                <hr />
                            </div>
                            <div>
                                <span>Approved By
                                </span>
                                <hr />
                            </div>
                        </div>
                    </div>
                    <table class="rotate-table-grid" id="table-skill-map" style="width: 100% !important; font-size: 8px !important;">
                        <thead>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        </tfoot>
                    </table>
                    <div class="div__footer">
                        <div class="row">
                            <div class="col-3">
                                <ul style="list-style:none;">
                                    <li><img src="~/Reports/Pic/0_19_NOT_STAR.png" width="50" height="47" runat="server" /> = (0 คะแนน) ยังไม่มีทักษะในการปฏิบัติ Unskillful.</li>
                                    <li><img src="~/Reports/Pic/20_25_NOT_STAR.png" width="50" height="47" runat="server" /> = (20-25 คะแนน) ทราบทฤษฎีเบื้องต้นเท่านั้น Only theoretically.</li>
                                    <li><img src="~/Reports/Pic/26_50_NOT_STAR.png" width="50" height="47" runat="server" /> = (26-50 คะแนน) สามารถปฏิบัติงานได้ภายใต้การควบคุมของหัวหน้างาน Can work under Leader.</li>
                                </ul>
                            </div>
                            <div class="col-3">
                                <ul style="list-style:none;">
                                    <li><img src="~/Reports/Pic/51_75.png" width="50" height="47" runat="server" /> = (51-75 คะแนน) สามารถปฏิบัติงานได้ด้วยตัวเอง Can work by himself.</li>
                                    <li><img src="~/Reports/Pic/76_100.png" width="50" height="47" runat="server" /> = (76-100 คะแนน) สามารถปฏิบัติงานได้ด้วยตนเองและถ่ายทอดให้ผู้อื่นได้ Can work by himself & Can teach others.</li>
                                </ul>
                            </div>
                            <div class="col-3">
                                <ul style="list-style:none;">
                                    <li><img src="~/Reports/Pic/0_19_NOT_STAR.png"  width="50" height="47" runat="server" /> วงใน คือ เป้าหมาย อ้างอิงตามตารางมาตรฐานกำหนดความสามารถของพนักงาน (FR-HR01-019) Inside circle : Target  Ref.to Competency Mapping Standard (FR-HR01-019)</li>
                                    <li><img src="~/Reports/Pic/WONG_NAI.png"  width="50" height="47" runat="server" /> วงนอก : ปฏิบัติได้จริง Outside circle : Actual</li>
                                </ul>
                            </div>
                            <div class="col-3">
                                <ul style="list-style:none;">
                                    <li>1. ประเมินพนักงานใหม่ ต้องทำการประเมินภายในวันที่ 91 Probation period. The evaluation will do within 91st of Probation period since start working</li>
                                    <li>2. ประเมินพนักงานหลังบรรจุเป็นพนักงานประจำแล้ว โดยต้องทำการประเมินทุก 6 เดือน After Passed Probation. Re-Evaluation every 6 months (2 times/year)</li>
                                    <li>3. ต้นฉบับ --> ต้นสังกัด ,สำเนา --> HR Original --> For each setion, Copied --> For HR</li>
                                </ul>
                            </div>
                        </div>
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
        function GetReportData() {
            let startDate = $('#<%= startDate.ClientID %>').val()
            let endDate = $('#<%= endDate.ClientID %>').val()
            let section = $('#<%= section.ClientID %>').val()
            let body = `{ 'sectionName': '${section}', 'startDate' : '${startDate}', 'endDate': '${endDate}'}`
            $.ajax({
                type: "POST",
                url: "/Pages/Reports/Skill-map-report.aspx/GetReportData",
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
                    let tableFooter = $('table tfoot')
                    let keyNames = Object.keys(data[0]);
                    let rowWithKey = []
                    let departmentGroup = []

                    let tableHeader = `<tr id="table-row-department">
                                          <td colspan="3" style="height: 5px !important;">
                                          </td>`

                    for (let i = 4; i >= 4 && i <= (keyNames.length - 5); i++) {
                        var request = $.ajax({
                            type: "POST",
                            url: "/Pages/Reports/Skill-map-report.aspx/GetDepartmentName",
                            data: `{ 'courseName': '${keyNames[i]}' }`,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: false,
                            success: (results) => {
                                let department = results.d
                                tableHeader += `<td class="${department}" style="text-align: center; height: 5px !important;">
                                                    ${department}
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
                        tableHeader += `<td></td><td></td><td></td><td></td><td></td>`
                        tableHeader += `</tr>`
                        tableHeader += `<tr>`
                        for (let i = 0; i < keyNames.length; i++) {
                            if (i > 3) {
                                tableHeader += `<th> 
                                                <span>
                                                    ${keyNames[i]} 
                                                </span>
                                            </th>`
                            } else if (i === 1) {
                                tableHeader += `<th style="text-align: center; padding: 0 !important">
                                                <div>Name</div>
                                                <hr style="border-top: 1px solid black"/>
                                                <div>Start working</div>
                                            </th>`

                            } else if (i === 2) { } else {
                                tableHeader += `<th style="text-align: center">
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
                                let name = row.key(1)
                                let date = moment(row.key(2)).format("D/M/YY")
                                if (j > 3 && j <= (keyNames.length - 5)) {
                                    let picName = ""
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

                                } else if (j === 1) {
                                    tableRow += `<td style="text-align: center; padding: 0 !important; vertical-align: middle;">
                                                <div style="padding: 10px">${name}</div>
                                                <hr style="border-top: 1px solid black; margin: 0;"/>
                                                <div style="padding: 10px">${date}</div>
                                             </td>`

                                } else if (j === 2) { } else {
                                    tableRow += `<td class="text-center" >${j === 2 ? date : (row.key(j) ?? 0)}</td>`
                                }
                            }
                            tableRow += `</tr>`
                            tableBody.append(tableRow)

                            var header_height = 0;
                            $('.rotate-table-grid th span').each(function () {
                                if ($(this).outerWidth() > header_height) header_height = $(this).outerWidth();
                            });
                            $('.rotate-table-grid th').height(header_height);

                        }

                        // remove key columns
                        let tableTR = $('table tr')
                        tableTR.find('td:last-child').remove()

                        // table footer count plan and actual 
                        let rowFooter = `<tr>
                                        <td
                                            colspan="2"
                                            rowspan="2"
                                            style="vertical-align: middle; text-align:center; padding: 0.25rem 0 !important; border: 1px solid black;"
                                          >
                                            จำนวนคนทดแทน / งาน
                                            <br/>
                                            (Compensate Person / Job)
                                          </td>
                                          <td rowspan="2" colspan="1" style="vertical-align: middle; text-align:center; padding: 0.25rem 0 !important; border: 1px solid black;">
                                            <span>Plan</span>
                                            <hr style="margin: 2px 0 !important; border-top: 1px solid black;" />
                                            <span>Actual</span>
                                          </td>`
                        for (let i = 4; i >= 4 && i <= (keyNames.length - 5); i++) {
                            let actualSummary = 0;
                            for (let k = 0; k < Object.keys(rowWithKey).length; k++) {
                                if (rowWithKey[k].key(i) > 50) {
                                    actualSummary += 1
                                }
                            }
                            rowFooter += `<td style="text-align:center; padding: 0.25rem 0 !important; border: 1px solid black;">
                                            <span>${rowWithKey.length}</span>
                                            <hr style="margin: 2px 0 !important; border-top: 1px solid black;" />
                                            <span>${actualSummary}</span>
                                      </td>`
                        }
                        rowFooter += `<td></td>
                                  <td></td>
                                  <td></td><td></td>`
                        rowFooter += `</tr>
                                  <tr></tr>`
                        tableFooter.append(rowFooter)

                        // row fix value
                        let rowFixValue = `<tr>
                                        <td colspan="3" style="text-align:center; padding: 0.1rem 0 !important; border: 1px solid black;">
                                                คะแนนเต็ม (Full Scores)
                                        </td>`

                        for (let i = 5; i > 4 && i <= (keyNames.length - 4); i++) {
                            rowFixValue += `<td style="text-align:center; padding: 0.25rem 0 !important; border: 1px solid black;">
                                            4
                                        </td>`
                        }
                        rowFixValue += `<td></td>
                                    <td></td>
                                    <td style="text-align: center;">100</td>
                                    <td></td>`
                        rowFixValue += `</tr>`
                        tableFooter.append(rowFixValue)

                        // auto merge department
                        $('#table-row-department').each(function () {
                            $(this).children().each(function () {
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
                            importStyle: true,
                            loadCSS: "skill-map.css"
                        });
                    })
                }
            });
        }
    </script>
</asp:Content>
