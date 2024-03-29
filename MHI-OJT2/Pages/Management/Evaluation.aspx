﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Evaluation.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Evaluation" %>

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

        .topic-score:first-child {
            width: 200px !important;
        }

        .topic-score {
            width: 150px !important;
        }

        .topic-score:last-child {
            width: 80px !important;
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

        input[type=checkbox], input[type=radio] {
            width: 20px !important;
            height: 20px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-6">
                    <h1 runat="server" id="title" class="m-0"></h1>
                </div>
                 <!-- /.col -->
                <div class='col-6 <%= _is_real_work_evaluate != true ? "d-none" : "" %>' >
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-primary" onclick="showModal()">
                            <i class="fa fa-plus-circle mr-2"></i>
                            ตัวช่วยกรอกคะแนน</button>
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
                <div class="card-body" style="padding: 1.25rem 1.25rem 0 !important">
                    <table class="hover" id="evaluateTable" style="width: 100%; border-top: 1px solid #ccc; margin-top: 20px 0 !important;">
                        <thead>
                            <tr>
                                <th scope="col" class="no-sort">รหัสพนักงาน</th>
                                <th scope="col" class="no-sort">ชื่อ-สกุล</th>
                                <%--_is_exam_evaluate == true--%>
                                <th scope="col" class='topic-score no-sort <%= _is_exam_evaluate != true ? "d-none" : "" %>'>
                                    *** คะแนนสอบ
                                    <p style="font-size:small;">การกรอกคะแนน = คะแนนที่สอบได้จริง / คะแนนเต็ม X 100</p>
                                    <p style="font-size:small;">Fill Scores = Actual Scores / Full Scores x 100</p>
                                </th>

                                <th scope="col" class='topic-score no-sort <%= _is_real_work_evaluate != true ? "d-none" : "" %>'>1.ความรู้ในงานและหน้าที่ (Knowledge in work and duties)</th>
                                <th scope="col" class='topic-score no-sort <%= _is_real_work_evaluate != true ? "d-none" : "" %>'>2.คุณภาพของงาน (Quality of work)</th>
                                <th scope="col" class='topic-score no-sort <%= _is_real_work_evaluate != true ? "d-none" : "" %>'>3.ความไว้วางใจ ความรับผิดชอบต่อหน้าที่ (Reliability, Responsibi-lity for duties )</th>
                                <th scope="col" class='topic-score no-sort <%= _is_real_work_evaluate != true ? "d-none" : "" %>'>4.ความสามารถในการทำงานตามระยะเวลาที่กำหนด (Ability to work on time)</th>
                                <th scope="col" class='topic-score no-sort <%= _is_real_work_evaluate != true ? "d-none" : "" %>'>5.การปฎิบัติงานตามขั้นตอนเอกสารที่กำหนด (Working follow documents procedure to define)</th>
                                <th scope="col" class='topic-score no-sort'>ผลการฝึกอบรม (Training Result)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RepeatCourseTable" runat="server">
                                <ItemTemplate>
                                    <tr class="row__data" data-personid='<%# Eval("PersonID") %>' data-evaluate-id='<%# Eval("EVALUATE_ID") %>'>
                                        <td>
                                            <%# Eval("PersonCode") %>
                                        </td>
                                        <td style="white-space: nowrap">
                                            <%# Eval("EMPLOYEE_NAME_TH") %>
                                        </td>

                                        <td class="text-center <%= _is_exam_evaluate != true ? "d-none" : "" %>">
                                            <input type="number" min="0" max="100" value='<%# Eval("EXAM_SCORE") %>' class='<%# "form-control input_score_0 input__score input__score__0__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 0)' />
                                        </td>

                                        <td class='<%= _is_real_work_evaluate != true ? "d-none" : "" %>'>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_1") %>' class='<%# "form-control input_score_1 input__score input__score__1__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 1)' />
                                        </td>
                                        <td class='<%= _is_real_work_evaluate != true ? "d-none" : "" %>'>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_2") %>' class='<%# "form-control input_score_2 input__score input__score__2__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 2)' />
                                        </td>
                                        <td class='<%= _is_real_work_evaluate != true ? "d-none" : "" %>'>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_3") %>' class='<%# "form-control input_score_3 input__score input__score__3__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 3)' />
                                        </td>
                                        <td class='<%= _is_real_work_evaluate != true ? "d-none" : "" %>'>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_4") %>' class='<%# "form-control input_score_4 input__score input__score__4__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 4)' />
                                        </td>
                                        <td class='<%= _is_real_work_evaluate != true ? "d-none" : "" %>'>
                                            <input type="number" min="0" max="5" value='<%# Eval("SCORE_5") %>' class='<%# "form-control input_score_5 input__score input__score__5__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 5)' />
                                        </td>
                                        <td>
                                            <input type="number" value='<%# Eval("TOTAL_SCORE") %>' class='<%# "form-control total__score__" + Eval("EVALUATE_ID").ToString() %>'  <%= _is_real_work_evaluate == true || _is_exam_evaluate == true ? "disabled='disabled'" : "" %> />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    <div class="row justify-content-between">
                        <div class="w-25">
                            <input type="hidden" runat="server" id="hiddenCourseId" />
                            <div class="form-inline">
                                <div class="form-group">
                                    <label>วันที่ประเมินผล : &nbsp;</label>
                                    <input type="tel" id="dpEvalDate" class="form-control form-control-sm text-center" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" style="width: 150px;" />
                                </div>
                            </div>
                        </div>
                        <% if (_isEvaluation == 1)
                            { %>
                        <div class="w-75 text-right">
                            <button type="button" class="btn btn-warning" onclick="saved(true)" id="btnSaveDraft">บันทึก (ร่าง)</button>
                            <button type="button" class="btn btn-success ml-2 w-25" onclick="saved(false)">บันทึก</button>
                        </div>
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
    <div class="modal fade" id="adviseModal" tabindex="-1" aria-labelledby="adviseModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal" style="box-shadow: none !important;">
            <div class="modal-content ">
                <div class="modal-header">
                    <h5 class="modal-title ">ตัวช่วยกรอกคะแนน</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" >
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row justify-content-between mx-1">
                        <div class="form-check form-check-inline">
                          <input class="form-check-input advise-check" type="checkbox" id="inlineCheckbox1" value="1">
                          <label class="form-check-label" for="inlineCheckbox1">ข้อ 1</label>
                        </div>
                        <div class="form-check form-check-inline">
                          <input class="form-check-input advise-check" type="checkbox" id="inlineCheckbox2" value="2">
                          <label class="form-check-label" for="inlineCheckbox2">ข้อ 2</label>
                        </div>
                        <div class="form-check form-check-inline">
                          <input class="form-check-input advise-check" type="checkbox" id="inlineCheckbox3" value="3">
                          <label class="form-check-label" for="inlineCheckbox3">ข้อ 3</label>
                        </div>
                        <div class="form-check form-check-inline">
                          <input class="form-check-input advise-check" type="checkbox" id="inlineCheckbox4" value="4">
                          <label class="form-check-label" for="inlineCheckbox4">ข้อ 4</label>
                        </div>
                        <div class="form-check form-check-inline">
                          <input class="form-check-input advise-check" type="checkbox" id="inlineCheckbox5" value="5">
                          <label class="form-check-label" for="inlineCheckbox5">ข้อ 5</label>
                        </div>
                    </div>
                    <div class="form-group my-3">
                        <label>คะแนน</label>
                        <input type="number" min="0" max="5" class="form-control" id="advise-input-score" />
                    </div>
                </div>
                <div class="modal-footer" style="justify-content: end !important;">
                    <div class="action-button-area">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด</button>
                        <button type="button" class="btn btn-primary" onclick="adviseSubmitScore()">ตกลง</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
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

            $('#btnSaveDraft').focus()
        })();

        var selectedArr = []
        $('.advise-check').on('change', function (e) {
            let checked = e.target.checked
            let value = Math.round(e.currentTarget.value)

            if (checked) {
                selectedArr.push(value)    
            } else {
                selectedArr = selectedArr.filter((val)=> val !== value)
            }
        })
        function adviseSubmitScore() {
            if (!selectedArr.length) return toasts('แจ้งเตือน', 'กรุณาเลือกหัวข้อที่ต้องการระบุคะแนน!')
            if ($('#advise-input-score').val() === "" || !$('#advise-input-score').val()) return toasts('แจ้งเตือน', 'กรุณาระบุคะแนน!')

            for (let i = 0; i < selectedArr.length; i++) {
                $('.input_score_' + selectedArr[i]).val($('#advise-input-score').val())
            }

            var row = $('.row__data')
            for (let i = 0; i < row.length; i++) {
                let _this = $(row[i])
                let inputId = _this.attr('data-evaluate-id')
                for (let j = 0; j < selectedArr.length; j++) {
                    calculate(inputId, selectedArr[j])
                }
            }
            

            $('#adviseModal').modal('hide')
        }
        $('#advise-input-score').on('keyup', function (e) {
            let value = e.currentTarget.value

            if (value > 5 || value < 0) {
                $(this).addClass('is-invalid')
            } else {
                $(this).removeClass('is-invalid')
            }
        })

        function showModal() {
            $('#adviseModal').modal('show')
        }

        function calculate(id, inputNumber) {
            let is_exam_evaluate = <%= _is_exam_evaluate.ToString().ToLower() %>
            let is_real_work_evaluate = <%= _is_real_work_evaluate.ToString().ToLower() %>

            console.log('is_exam_evaluate : ', is_exam_evaluate)
            console.log('is_real_work_evaluate : ', is_real_work_evaluate)

            let examScore = Math.round($('.input__score__0__' + id).val());
            let realWorkScore = 0;
            let evaluatedScore = 0;
            for (let i = 1; i <= 5; i++) {
                let inputScore = $('.input__score__' + i + '__' + id).val()
                evaluatedScore += Math.round(inputScore)
            }

            realWorkScore = (evaluatedScore * 100) / 25

            if (inputNumber > 0) {
                let _this = $('.input__score__' + inputNumber + '__' + id)
                if (_this.val() <= 5 && _this.val() >= 0) {
                    _this.removeClass('is-invalid')
                } else {
                    _this.addClass('is-invalid')
                }
            } else {
                let _this = $('.input__score__0__' + id)
                if (_this.val() <= 100 && _this.val() >= 0) {
                    _this.removeClass('is-invalid')
                } else {
                    _this.addClass('is-invalid')
                }
            }

            // summary 
            if (is_exam_evaluate === true && is_real_work_evaluate === true) {
                console.log(' true * 2 ')
                console.log('examScore : ', examScore)
                console.log(typeof examScore)
                console.log('realWorkScore : ', realWorkScore)
                let sum = examScore + realWorkScore
                $('.total__score__' + id).val(sum / 2)

            } else if (is_exam_evaluate === true && is_real_work_evaluate === false) {
                console.log(' exam true ')
                $('.total__score__' + id).val(examScore)

            } else if (is_exam_evaluate === false && is_real_work_evaluate === true) {
                console.log(' real work true ')
                $('.total__score__' + id).val(realWorkScore)
            } else {
                $('.total__score__' + id).val(realWorkScore)
            }
        }

        // hidden function if is evaluation !== 1
        function saved(isDraft) {
            var _evalDate = $('#dpEvalDate').val()
            if (!isDraft) {
                if (_evalDate.length <= 0) {
                    Swal.fire('Warning!', 'Please fill evaluate date.', 'error')
                    return;
                }
            }

            var row = $('.row__data')
            var evaluatedList = []

            // loop find personId
            for (let i = 0; i < row.length; i++) {
                let person = {}
                let personId = row[i].dataset.personid
                let td = row[i].children

                let examScore = Math.round(td[2].firstElementChild.value)
                let score1 = Math.round(td[3].firstElementChild.value)
                let score2 = Math.round(td[4].firstElementChild.value)
                let score3 = Math.round(td[5].firstElementChild.value)
                let score4 = Math.round(td[6].firstElementChild.value)
                let score5 = Math.round(td[7].firstElementChild.value)
                let totalScore = Math.round(td[8].firstElementChild.value)

                if (examScore < 0 || examScore > 100 || score1 > 5 || score1 < 0 || score2 > 5 || score2 < 0 || score3 > 5 || score3 < 0 || score4 > 5 || score4 < 0 || score5 > 5 || score5 < 0 || totalScore > 100 || totalScore < 0) {
                    sweetAlert("error", "ผิดพลาด!", "กรุณากรอกคะแนนให้ถูกต้อง")
                    return
                }

                person.PersonID = parseInt(personId);
                person.Exam = examScore
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
                let EvaluatedDate = $('#dpEvalDate').val()
                $.ajax({
                    type: "POST",
                    url: "<%= ajax %>" + "/Pages/Management/Evaluation.aspx/SaveEvaluateResults",
                    data: "{ 'EvaluatedList': " + JSON.stringify(evaluatedList) + ", 'IsDraft': " + isDraft + ", 'EvaluatedDate': '" + EvaluatedDate + "' }",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (res) {
                        var _r = res.d

                        if (_r === 0) {
                            Swal.fire('Warning!', 'Please recheck data', 'error')
                            return;
                        }

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
                url: "<%= ajax %>" + "/Pages/Management/Approval.aspx/HandleApprove",
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


