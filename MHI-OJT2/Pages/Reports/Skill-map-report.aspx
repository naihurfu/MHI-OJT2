<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Skill-map-report.aspx.cs" Inherits="MHI_OJT2.Pages.Reports.Skill_map_report" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
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
            <div class="card" id="printingArea">
                <div class="card-body table-responsive">
                    <table class="table table-hover" style="width: 2480px; height: 3508px;" id="ok">
                        <thead>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ModalContent" ContentPlaceHolderID="modal" runat="server">
</asp:Content>
<asp:Content ID="ScriptContent" ContentPlaceHolderID="script" runat="server">
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
                    let tableThead = $('table thead')
                    let tableBody = $('table tbody')
                    let keyNames = Object.keys(data[0]);
                    //console.log(keyNames)

                    let tableHeader = `<tr>`
                    for (let i = 0; i < keyNames.length; i++) {
                        tableHeader += `<th> ${keyNames[i]} </th>`
                    }
                    tableHeader += `</tr>`
                    tableThead.append(tableHeader)

                    for (let i = 0; i < data.length; i++) {
                        let tableRow = `<tr>`
                        let row = data[i]
                        row.key = function (n) {
                            return this[Object.keys(this)[n]];
                        }

                        for (let j = 0; j < Object.keys(row).length; j++) {
                            if (j > 4 && j <= (keyNames.length - 5)) {
                                tableRow += `<td>
                                                <img src="../../Reports/Pic/76_100.png" width="50" height="50"/>
                                             </td>`

                            } else {
                                tableRow += `<td>${row.key(j) ?? 0}</td>`
                            }
                        }
                        tableRow += `</tr>`
                        tableBody.append(tableRow)
                    }
                    $('table tr').find('td:last-child').remove()

                    window.open('data:application/vnd.ms-excel,' + encodeURIComponent(document.getElementById('ok').outerHTML));
                }
            });
        }

    </script>
</asp:Content>
