<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Evaluation.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Evaluation" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        th, td {
            vertical-align: middle !important;
            white-space: nowrap;
        }

        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            /* display: none; <- Crashes Chrome on hover */
            -webkit-appearance: none;
            margin: 0; /* <-- Apparently some margin are still there even though it's hidden */
        }

        input[type=number] {
            -moz-appearance: textfield; /* Firefox */
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
                    <div class="table-responsive-xl">
                        <table class="table table-hover">
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
                                        <tr>
                                            <td>
                                                <%# Eval("PersonCode") %>
                                            </td>
                                            <td>
                                                <%# Eval("EMPLOYEE_NAME_EN") %>
                                            </td>
                                            <td>
                                                <input type="number" min="0" max="5" value='<%# Eval("SCORE_1") %>' class='<%# "form-control input__score__1__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 1)' />
                                            </td>
                                            <td>
                                                <input type="number" min="0" max="5" value='<%# Eval("SCORE_2") %>' class='<%# "form-control input__score__2__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 2)' />
                                            </td>
                                            <td>
                                                <input type="number" min="0" max="5" value='<%# Eval("SCORE_3") %>' class='<%# "form-control input__score__3__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 3)' />
                                            </td>
                                            <td>
                                                <input type="number" min="0" max="5" value='<%# Eval("SCORE_4") %>' class='<%# "form-control input__score__4__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 4)' />
                                            </td>
                                            <td>
                                                <input type="number" min="0" max="5" value='<%# Eval("SCORE_5") %>' class='<%# "form-control input__score__5__" + Eval("EVALUATE_ID").ToString() %>' onchange='calculate(<%# Eval("EVALUATE_ID") %>, 5)' />
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
                </div>
                <div class="card-footer">
                    <div class="row justify-content-end">
                        <button type="button" class="btn btn-warning" onclick="saved()">Save (Draft)</button>
                        <button type="button" class="btn btn-success ml-2 w-25">Save</button>
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
    <script type="text/javascript">
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

        function saved() {
            for (let i = 1; i <= 5; i++) {
                let inputScore = $('.input__score__' + i + '__' + id).val()
                console.log(parseInt(inputScore))
            }
        }
    </script>
</asp:Content>


