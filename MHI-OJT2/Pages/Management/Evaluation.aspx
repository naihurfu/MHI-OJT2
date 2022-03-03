<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Evaluation.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Evaluation" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/jquery.dataTables.min.css">
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
                        <table class="hover nowrap" id="evaluateTable"  style="width: 100%">
                            <thead>
                                <tr>
                                    <th scope="col">Employee ID</th>
                                    <th scope="col">Employee name</th>
                                    <th scope="col">Score 1</th>
                                    <th scope="col">Score 2</th>
                                    <th scope="col">Score 3</th>
                                    <th scope="col">Score 4</th>
                                    <th scope="col">Score 5</th>
                                    <th scope="col" class="text-center">Total score</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="RepeatCourseTable" runat="server">
                                    <ItemTemplate>
                                        <tr class="row__data" data-personId='<%# Eval("PersonID") %>'>
                                            <td>
                                                <%# Eval("PersonCode") %>
                                            </td>
                                            <td>
                                                <%# Eval("EMPLOYEE_NAME_EN") %>
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
                        <button type="button" class="btn btn-warning" onclick="saved(true)">Save (Draft)</button>
                        <button type="button" class="btn btn-success ml-2 w-25" onclick="saved(false)">Save</button>
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
                scroller: true
            });
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

        function saved(isDraft) {
            var row = $('.row__data')
            var evaluatedList = []

            // loop find personId
            for (let i = 0; i < row.length; i++) {
                let person = {}
                let personId = row[i].dataset.personid
                let td = row[i].children

                person.PersonID = parseInt(personId);
                person.Score_1 = parseInt(td[2].firstElementChild.value)
                person.Score_2 = parseInt(td[3].firstElementChild.value)
                person.Score_3 = parseInt(td[4].firstElementChild.value)
                person.Score_4 = parseInt(td[5].firstElementChild.value)
                person.Score_5 = parseInt(td[6].firstElementChild.value)
                person.Total = parseInt(td[7].firstElementChild.value)

                evaluatedList.push(person)
            }

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
        }
    </script>
</asp:Content>


