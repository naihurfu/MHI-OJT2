<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Evaluation.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Evaluation" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        input[type=number] {
            -moz-appearance: textfield;
            text-align: center;
        }

        .topic-score {
            width: 150px !important;
        }

        table thead tr th {
            vertical-align: top !important;
        }

        .dataTables_scroll {
            padding: 20px 0 !important;
        }

        table.dataTable thead .sorting_asc {
            background-image: none !important;
        }

        .dataTables_wrapper {
            padding-bottom: 20px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-12">
                    <h1 runat="server" id="title" class="m-0"></h1>
                </div>
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
                <div class="card-body" style="padding: 1.25rem 1.25rem 0 !important">
                    <table class="hover" id="evaluateTable" style="width: 100%; border-top: 1px solid #ccc; margin-top: 20px 0 !important;">
                        <thead>
                            <tr>
                                <th scope="col" class="no-sort">รหัสพนักงาน</th>
                                <th scope="col" class="no-sort">ชื่อ-สกุล</th>
                                <th scope="col" class="topic-score no-sort">1.ความรู้ในงานและหน้าที่ (Knowledge in work and duties)</th>
                                <th scope="col" class="topic-score no-sort">2.คุณภาพของงาน (Quality of work)</th>
                                <th scope="col" class="topic-score no-sort">3.ความไว้วางใจ ความรับผิดชอบต่อหน้าที่ (Reliability, Responsibi-lity for duties )</th>
                                <th scope="col" class="topic-score no-sort">4.ความสามารถในการทำงานตามระยะเวลาที่กำหนด (Ability to work on time)</th>
                                <th scope="col" class="topic-score no-sort">5.การปฎิบัติงานตามขั้นตอนเอกสารที่กำหนด (Working follow documents procedure to define)</th>
                                <th scope="col" class="topic-score no-sort">ผลการฝึกอบรม (Training Result)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RepeatCourseTable" runat="server">
                                <ItemTemplate>
                                    <tr class="row__data" data-personid='<%# Eval("PersonID") %>'>
                                        <td>
                                            <%# Eval("PersonCode") %>
                                        </td>
                                        <td style="white-space: nowrap">
                                            <%# Eval("EMPLOYEE_NAME_TH") %>
                                        </td>
                                        <td>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_1") %>' class='<%# "form-control input__score input__score__1__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 1)' />
                                        </td>
                                        <td>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_2") %>' class='<%# "form-control input__score input__score__2__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 2)' />
                                        </td>
                                        <td>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_3") %>' class='<%# "form-control input__score input__score__3__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 3)' />
                                        </td>
                                        <td>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_4") %>' class='<%# "form-control input__score input__score__4__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 4)' />
                                        </td>
                                        <td>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_5") %>' class='<%# "form-control input__score input__score__5__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 5)' />
                                        </td>
                                        <td>
                                            <input type="number" value='<%# Eval("TOTAL_SCORE") %>' class='<%# "form-control total__score__" + Eval("EVALUATE_ID").ToString() %>' disabled="disabled" />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    <div class="row justify-content-end">
                        <input type="hidden" runat="server" id="hiddenCourseId" />
                        <% if (_isEvaluation == 1)
                            { %>
                        <button type="button" class="btn btn-warning" onclick="saved(true)">บันทึก (ร่าง)</button>
                        <button type="button" class="btn btn-success ml-2 w-25" onclick="saved(false)">บันทึก</button>
                        <% } %>
                    </div>
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
    <!-- (total score * 100) / 25 = total score % -->
    <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        (function () {
            $("#evaluateTable").DataTable({
                responsive: true,
                scrollX: 500,
                scrollCollapse: true,
                scroller: true,
                columnDefs: [{
                    orderable: false,
                    targets: "no-sort"
                }],
                "oLanguage": {
                    "sSearch": "ค้นหา :",
                    "sLengthMenu": "แสดง _MENU_ รายการ"
                },
                "language": {
                    searchPlaceholder: "รหัสพนักงาน/ชื่อ-สกุล",
                    "info": "แสดง _START_-_END_ รายการ ทั้งหมด _TOTAL_ รายการ",
                    "paginate": {
                        "previous": "ย้อนกลับ",
                        "next": "หน้าถัดไป"
                    }
                },
                aLengthMenu: [
                    [ "All"]
                ],
                paging: false
            });
            if (!<%= _isEvaluation %>) {
                $('.input__score').attr('disabled', 'disabled');
            }
        })();

        function calculate(id, inputNumber) {
            let _this = $('.input__score__' + inputNumber + '__' + id)
            if (_this.val() <= 5 && _this.val() >= 0) {
                _this.removeClass('is-invalid')

                let evaluatedScore = 0;
                let totalPercentage = 0;
                for (let i = 1; i <= 5; i++) {
                    let inputScore = $('.input__score__' + i + '__' + id).val()
                    evaluatedScore += parseInt(inputScore)
                }

                totalPercentage = (evaluatedScore * 100) / 25
                $('.total__score__' + id).val(totalPercentage)
            } else {
                _this.addClass('is-invalid')
            }
        }

        // hidden function if is evaluation !== 1
        function saved(isDraft) {
            var row = $('.row__data')
            var evaluatedList = []

            // loop find personId
            for (let i = 0; i < row.length; i++) {
                let person = {}
                let personId = row[i].dataset.personid
                let td = row[i].children

                let score1 = parseInt(td[2].firstElementChild.value)
                let score2 = parseInt(td[3].firstElementChild.value)
                let score3 = parseInt(td[4].firstElementChild.value)
                let score4 = parseInt(td[5].firstElementChild.value)
                let score5 = parseInt(td[6].firstElementChild.value)
                let totalScore = parseInt(td[7].firstElementChild.value)

                if (score1 > 5 || score1 < 0 || score2 > 5 || score2 < 0 || score3 > 5 || score3 < 0 || score4 > 5 || score4 < 0 || score5 > 5 || score5 < 0 || totalScore > 100 || totalScore < 0) {
                    sweetAlert("error", "Failed!", "Please enter correct score.")
                    return
                }

                person.PersonID = parseInt(personId);
                person.Score_1 = score1
                person.Score_2 = score2
                person.Score_3 = score3
                person.Score_4 = score4
                person.Score_5 = score5
                person.Total = totalScore

                evaluatedList.push(person)
            }

            <% if (_isEvaluation == 1)
            { %>
            if (evaluatedList.length > 0) {
                $.ajax({
                    url: "/Pages/Management/Evaluation.aspx/SaveEvaluateResults",
                    data: "{ 'EvaluatedList': " + JSON.stringify(evaluatedList) + ", 'IsDraft': " + isDraft + " }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (res) {
                        window.location.href = window.location.protocol + "//" + window.location.host + "/Pages/Management/Courses.aspx"
                    }
                });
            }
            <% } %>
        }
        function handleApprove(isApprove) {
            let body = {}
            body.APPROVE_ID = `${<%= _approveId %>}`
            body.COURSE_ID = `${<%= _courseId %>}`
            body.APPROVAL_SEQUENCE = `${<%= _approveSequence %>}`
            body.IS_APPROVE = isApprove

            $.ajax({
                type: "POST",
                url: "/Pages/Management/Approval.aspx/HandleApprove",
                data: "{ '_ApproveResult': " + JSON.stringify(body) + " }",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (results) {
                    switch (results.d) {
                        case "ERROR":
                            Swal.fire('Error!', 'Network connection encountered a problem. Please try again later.', 'error')
                            break

                        default:
                            window.location.href = window.location.protocol + "//" + window.location.host + "/Pages/Management/Approval.aspx"

                    }
                },
                error: function (err) {
                    console.log(err)
                }
            });
        }
    </script>
</asp:Content>


