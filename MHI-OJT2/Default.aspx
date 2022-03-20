<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MHI_OJT2.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .info-box {
            height: 90px !important;
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

        .cal-card-height, canvas {
            /*min-height: calc(100vh - calc(7rem + (150px *2)))!important;*/
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
                    <div class="info-box">
                        <span class="info-box-icon bg-info elevation-1"><i class="fas fa-cog"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">ทั้งหมด</span>
                            <span class="info-box-number"><%= allCourseCount %> <small>หลักสูตร</small></span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 d-flex align-items-stretch">
                    <div class="info-box">
                        <span class="info-box-icon bg-gradient-warning elevation-1"><i class="fas fa-cog"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">ที่อบรมในปีนี้</span>
                            <span class="info-box-number"><%= trainedThisYear %> <small>หลักสูตร</small></span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 d-flex align-items-stretch">
                    <div class="info-box">
                        <span class="info-box-icon bg-success elevation-1"><i class="fas fa-cog"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">รอประเมินผล</span>
                            <span class="info-box-number"><%= waitingForEvaluation %> <small>หลักสูตร</small>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 d-flex align-items-stretch">
                    <div class="info-box">
                        <span class="info-box-icon bg-secondary elevation-1"><i class="fas fa-cog"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">รออนุมัติ</span>
                            <span class="info-box-number"><%= waitingForApproval %> <small>หลักสูตร</small>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row cal-card-height">
                <div class="col-lg-7 d-flex align-items-stretch">
                    <div class="card">
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
                        <div class="card-footer text-center">
                            <a href="~/Pages/Training-profile.aspx" runat="server">ดูเพิ่มเติม</a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5 d-flex align-items-stretch">
                    <div class="card">
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
<asp:Content ID="ScriptContent" ContentPlaceHolderID="script" runat="server">
    <script type="text/javascript">
        (function () {
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
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                data: datas,
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.5)',
                                    'rgba(54, 162, 235, 0.5)',
                                    'rgba(255, 206, 86, 0.5)',
                                    'rgba(75, 192, 192, 0.5)',
                                    'rgba(153, 102, 255, 0.5)',
                                    'rgba(255, 159, 64, 0.5)'
                                ],
                                borderColor: [
                                    'rgba(255, 99, 132, 1)',
                                    'rgba(54, 162, 235, 1)',
                                    'rgba(255, 206, 86, 1)',
                                    'rgba(75, 192, 192, 1)',
                                    'rgba(153, 102, 255, 1)',
                                    'rgba(255, 159, 64, 1)'
                                ],
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            legend: {
                                display: false
                            },
                            scales: {
                                yAxes: [{
                                    display: true,
                                    ticks: {
                                        beginAtZero: true,
                                        <%= (string)Session["roles"] == "user" ? "max: 100" : "" %>
                                    }
                                }],
                            },
                        }
                    });
                },
                error: function (err) {
                    console.log(err)
                }
            });
        })();
    </script>
</asp:Content>
