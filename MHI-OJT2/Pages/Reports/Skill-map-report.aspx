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
            padding: 10px;
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

    </style>
        
        <style type="text/css" media="print">
            @page{
                size: landscape;
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
                    <table class="rotate-table-grid"  style="width: 100% !important; font-size: 8px !important;">
                        <thead>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        </tfoot>
                    </table>
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

                    let data = JSON.parse(results.d)
                    if (!data.length) {
                        Swal.fire("ไม่พบหลักสูตรการอบรม","", "error")
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
                    let tableHeader = `<tr>`
                    for (let i = 0; i < keyNames.length; i++) {
                        if (i > 4) {
                            tableHeader += `<th> 
                                                <span>
                                                    ${keyNames[i]} 
                                                </span>
                                            </th>`
                        } else {
                            tableHeader += `<th style="text-align: center"> ${keyNames[i]} </th>`
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
                            if (j > 4 && j <= (keyNames.length - 5)) {
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

                                tableRow += `<td style="text-align: center;">
                                                <img src="../../Reports/Pic/${picName}.png" width="50" height="50"/>
                                             </td>`

                            } else {
                                let date = j === 3 ? new Date(row.key(j)).toLocaleString("th-TH").toString().split(" ")[0] : ""
                                tableRow += `<td class="${j > 4 || j === 3 ? 'text-center' : ''}" >${j === 3 ? date : (row.key(j) ?? 0)}</td>`
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
                    console.log(rowWithKey)

                    // remove key columns
                    $('table tr').find('td:last-child').remove()

                    // table footer count plan and actual 
                    let rowFooter = `<tr>
                                        <td
                                            colspan="3"
                                            rowspan="2"
                                            style="vertical-align: middle; text-align:center; padding: 0.25rem 0 !important; border: 1px solid black;"
                                          >
                                            จำนวนคน
                                          </td>
                                          <td rowspan="2" colspan="2" style="vertical-align: middle; text-align:center; padding: 0.25rem 0 !important; border: 1px solid black;">
                                            <span>Plan</span>
                                            <hr style="margin: 2px 0 !important; border-top: 1px solid black;" />
                                            <span>Actual</span>
                                          </td>`
                    for (let i = 5; i > 4 && i <= (keyNames.length - 5); i++) {
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
                                  <td></td>
                                  <td></td>`
                    rowFooter += `</tr>
                                  <tr></tr>`
                    tableFooter.append(rowFooter)

                    // row fix value
                    let rowFixValue = `<tr>
                                        <td colspan="5" style="text-align:center; padding: 0.25rem 0 !important; border: 1px solid black;">
                                                คะแนนเต็ม (Full Scores)
                                        </td>`
                    
                    for (let i = 5; i > 4 && i <= (keyNames.length - 5); i++) {
                        rowFixValue += `<td style="text-align:center; padding: 0.25rem 0 !important; border: 1px solid black;">
                                            4
                                        </td>`
                    }
                    rowFixValue += `<td></td>
                                  <td></td>
                                  <td>100</td>
                                  <td></td>`
                    rowFixValue += `</tr>`
                    tableFooter.append(rowFixValue)

                    // print 
                    $('table').printThis({
                        importCSS: true,
                        importStyle: true,
                        loadCSS: "skill-map.css"
                    });
                }
            });
        }
    </script>
</asp:Content>
