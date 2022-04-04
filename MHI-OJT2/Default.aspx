<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MHI_OJT2.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .info-box {
            height: 90px !important;
            background-color: #343a40;
            color: #fff;
            box-shadow: 0 0 1px rgb(0 0 0 / 13%), 0 1px 3px rgb(0 0 0 / 20%);
        }

        .info-box .info-box-content {
            line-height: 2.5;
        }

        .info-box .info-box-icon {
            width: 30% !important;
            font-size: 2rem !important;
        }

        .card {
            width: 100% !important;
        }

        .info-box:hover {
            background-color: rgba(52, 58, 64, 0.3);
            cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">แดชบอร์ด</h1>
                </div>
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container-fluid -->
    </div>

    <!-- Main content -->
    <div class="content">
        <div class="container-fluid align-items-stretch h-100">

            <div class="row">
                <div class="col-lg-3 d-flex align-items-stretch">
                    <div class="info-box" onclick="HandleCardClicked('all-course-count')">
                        <span class="info-box-icon bg-info elevation-1"><i class="fas fa-calendar-alt"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">ทั้งหมด</span>
                            <span class="info-box-number"><%= allCourseCount %> <small>หลักสูตร</small></span>
                        </div>
                        <div class="overlay" id="card-all-course-count">
                          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 d-flex align-items-stretch">
                    <div class="info-box" onclick="HandleCardClicked('trained-this-year')">
                        <span class="info-box-icon bg-gradient-warning elevation-1"><i class="fas fa-calendar-check"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">ที่อบรมในปีนี้</span>
                            <span class="info-box-number"><%= trainedThisYear %> <small>หลักสูตร</small></span>
                        </div>
                        <div class="overlay" id="card-this-year-count">
                          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 d-flex align-items-stretch">
                    <div class="info-box" onclick="HandleCardClicked('wait-for-evaluation')">
                        <span class="info-box-icon bg-success elevation-1"><i class="fas fa-chart-bar"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">รอประเมินผล</span>
                            <span class="info-box-number"><%= waitingForEvaluation %> <small>หลักสูตร</small>
                            </span>
                        </div>
                        <div class="overlay" id="card-wait-for-evaluation-count">
                          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 d-flex align-items-stretch">
                    <div class="info-box" onclick="HandleCardClicked('wait-for-approval')">
                        <span class="info-box-icon bg-danger elevation-1"><i class="fas fa-user-clock"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">รออนุมัติ</span>
                            <span class="info-box-number"><%= waitingForApproval %> <small>หลักสูตร</small>
                            </span>
                        </div>
                        <div class="overlay" id="card-wait-for-approval-count">
                          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row cal-card-height">
                <div class="col-lg-7 d-flex align-items-stretch">
                    <div class="card text-light" style="background-color: #343a40;">
                        <div class="card-header border-0">
                            <h3 class="card-title">สถานะหลักสูตร</h3>
                        </div>
                        <div class="card-body p-0 table-responsive">
                            <table class="table m-0">
                                <thead>
                                    <tr>
                                        <th>ชื่อหลักสูตร</th>
                                        <th class="text-center">ครั้งที่</th>
                                        <th class="text-center">วันที่อบรม</th>
                                        <th class="text-center">สถานะ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (statusTableRowCount > 0)
                                        { %>
                                    <asp:Repeater ID="statusTableRepeater" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("COURSE_NAME") %></td>
                                                <td class="text-center"><%# Eval("TIMES") %></td>
                                                <td class="text-center"><%# String.Format(new System.Globalization.CultureInfo("th-TH"), "{0:dd MMMM yyyy}", Eval("START_DATE")) %></td>
                                                <td class="text-center">
                                                    <span class='badge badge-<%# (int)Eval("STATUS_CODE") == 1 ? "primary" : (int)Eval("STATUS_CODE") == 2 ? "warning" : (int)Eval("STATUS_CODE") == 9 ? "success" : (int)Eval("STATUS_CODE") == 10 ? "danger" : "secondary" %>'>
                                                        <%# Eval("STATUS_TEXT") %>
                                                    </span>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <% }
                                        else
                                        { %>
                                    <tr>
                                        <td colspan="4" class="text-center">ไม่พบรายการ
                                        </td>
                                    </tr>

                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <div class="card-footer text-center dark-mode" >
                            <a href="~/Pages/Training-profile.aspx" runat="server" class="text-light">ดูเพิ่มเติม</a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5 d-flex align-items-stretch">
                    <div class="card text-light" style="background-color: #343a40;">
                        <div class="card-header border-0">
                            <h3 class="card-title">
                                <%= (string)Session["roles"] == "user" ? "คะแนนการอบรม (ปีปัจจุบัน)" : "จำนวนคนแต่ละหลักสูตร" %>
                            </h3>
                        </div>
                        <div class="card-body h-75">
                            <canvas id="score-chart" style="display: block; min-height: 400px; height: 100%; width: 100%;" class="chartjs-render-monitor"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.container-fluid -->
        </div>
    </div>
    <!-- /.content -->
</asp:Content>
<asp:Content ID="ModalContent" ContentPlaceHolderID="modal" runat="server">
    <div class="modal fade" id="ViewCardModal" tabindex="-1" aria-labelledby="ViewCardModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-lg" style="box-shadow: none !important;">
            <div class="modal-content dark-mode">
                <div class="modal-header border-0">
                    <h5 class="modal-title text-light" id="view-card-title"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="text-center my-5" id="view-card-loading">
                      <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                        <span class="sr-only">โปรดรอ...</span>
                      </div>
                    </div>
                    <div class="table-responsive" id="view-card-table-container">
                        <table class="table m-0" id="view-card-table">
                            <thead>
                                <tr>
                                    <th class="text-center">ลำดับ</th>
                                    <th class="text-center">แผนก</th>
                                    <th>ชื่อหลักสูตร</th>
                                    <th class="text-center">ผู้จัดทำ</th>
                                    <th class="text-center">วันที่เริ่มอบรม</th>
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
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-autocolors"></script>
    <script type="text/javascript">
        (function () {
            const autocolors = window['chartjs-plugin-autocolors'];
            // call chart data
            let id = `<%= Session["userId"] %>`
            let role = `<%= Session["roles"].ToString().ToLower() %>`
            let data = `{ 'PersonID': ${id}, 'Roles': '${role}' }`
            $.ajax({
                type: "POST",
                url: "/Default.aspx/GetChart",
                data: data,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    const data = JSON.parse(results.d)

                    let labels = data.map((item) => item.labels);
                    let datas = data.map((item) => item.datas);
                    // create chart 
                    const ctx = document.getElementById('score-chart').getContext('2d');
                    let delayed;
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                data: datas,
                                backgroundColor: Array.from({ length: datas.length }, (x, i) => {
                                    return getColor()
                                }),
                                borderColor: [],
                                borderWidth: 0,
                                borderRadius: 15,
                            }]
                        },
                        options: {
                            plugins: {
                                legend: {
                                    display: false
                                }
                            },
                            responsive: true,
                            scales: {
                                xAxis: {
                                    ticks: {
                                        color: 'rgba(255, 255, 255, 1)'
                                    },
                                },
                                yAxis: {
                                    precision: 0,
                                    min: 0,
                                    max: parseInt(`${<%= (string)Session["roles"] == "user" ? "100" : "Math.max(...datas) + 5" %>}`),
                                    ticks: {
                                        color: 'rgba(255, 255, 255, 1)'
                                    },
                                }
                            }
                        }
                    });
                },
                error: function (err) {
                    console.log(err)
                }
            });
            function getColor() {
                return "hsla(" + ~~(360 * Math.random()) + "," +
                    "70%," +
                    "80%,1)"
            }
        })();
        
        var allCourseCountTable = []
        var trainedThisYearTable = []
        var waitForEvaluationTable = []
        var waitForApprovalTable = []
        function PreloadCardCountData() {
            let id = `<%= Session["userId"] %>`
            let role = `<%= Session["roles"].ToString().ToLower() %>`
            let data = `{ 'userId': ${id}, 'role': '${role}' }`

            // get all course count table
            $.ajax({
                type: "POST",
                url: "/Default.aspx/GetAllCourseCountTable",
                data: data,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    var data = JSON.parse(results.d)
                    allCourseCountTable = data
                    $('#card-all-course-count').remove()
                },
                error: function (err) {
                    console.log(err)
                }
            });

            // get trained this year table
            $.ajax({
                type: "POST",
                url: "/Default.aspx/GetTrainedThisYearTable",
                data: data,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    var data = JSON.parse(results.d)
                    trainedThisYearTable = data
                    $('#card-this-year-count').remove()
                },
                error: function (err) {
                    console.log(err)
                }
            });

            // get wait for evaluation table
            $.ajax({
                type: "POST",
                url: "/Default.aspx/GetWaitForEvaluationTable",
                data: data,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    var data = JSON.parse(results.d)
                    waitForEvaluationTable = data
                    $('#card-wait-for-evaluation-count').remove()
                },
                error: function (err) {
                    console.log(err)
                }
            });

            // get wait for approval table
            $.ajax({
                type: "POST",
                url: "/Default.aspx/GetWaitForApprovalTable",
                data: data,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    var data = JSON.parse(results.d)
                    waitForApprovalTable = data
                    $('#card-wait-for-approval-count').remove()
                },
                error: function (err) {
                    console.log(err)
                }
            });
        }
        PreloadCardCountData()
        function HandleCardClicked(cardName) {

            // modal information
            let modal = $('#ViewCardModal')
            let title = $('#view-card-title')
            let loading = $('#view-card-loading')
            let container = $('#view-card-table-container')

            // hide table and show loading icon
            container.hide()
            loading.show()

            // remove tr in tbody
            $('#view-card-table tbody tr').remove()
            switch (cardName.toUpperCase()) {
                case "ALL-COURSE-COUNT":
                    title.text("หลักสูตรทั้งหมด")
                    HandleDataShowInTable(allCourseCountTable)
                    container.show()
                    loading.hide()
                    modal.modal('show')
                    break;

                case "TRAINED-THIS-YEAR":
                    title.text("หลักสูตรที่จัดฝึกอบรมในปีนี้")
                    HandleDataShowInTable(trainedThisYearTable)
                    container.show()
                    loading.hide()
                    modal.modal('show')
                    break

                case "WAIT-FOR-EVALUATION":
                    title.text("หลักสูตรที่รอการประเมินผล")
                    HandleDataShowInTable(waitForEvaluationTable)
                    container.show()
                    loading.hide()
                    modal.modal('show')
                    break

                case "WAIT-FOR-APPROVAL":
                    title.text("หลักสูตรที่รอการอนุมัติ")
                    HandleDataShowInTable(waitForApprovalTable)
                    container.show()
                    loading.hide()
                    modal.modal('show')
                    break

                default: console.log('not found!')
            }

        }
        function HandleDataShowInTable(items) {
            let table = $('#view-card-table tbody')
            items.forEach((item, index) => {
                let startDate = new Date(item.START_DATE).toLocaleDateString("th-TH")
                var tableRow = `<tr>
                                            <td class="text-center">
                                                ${index + 1}
                                            </td>
                                            <td class="text-center">
                                                ${item.DEPARTMENT_NAME}
                                            </td>
                                            <td>
                                                ${item.COURSE_NAME}
                                            </td>
                                            <td>
                                                ${item.CREATED_NAME}
                                            </td>
                                            <td class="text-center">
                                                ${startDate}
                                            </td>
                                        </tr>`
                table.append(tableRow)
            })
        }

    </script>
</asp:Content>
