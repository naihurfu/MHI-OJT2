<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Evaluation.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Evaluation" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        th, td {
            vertical-align: middle !important;
            white-space: nowrap;
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
                <div class="card-body">
                    <div class="table-responsive-xl">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Employee ID</th>
                                    <th scope="col">Employee name</th>
                                    <th scope="col">Score 1</th>
                                    <th scope="col">Score 2</th>
                                    <th scope="col">Score 3</th>
                                    <th scope="col">Score 4</th>
                                    <th scope="col">Score 5</th>
                                    <th scope="col">Total score</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="RepeatCourseTable" runat="server">
                                    <ItemTemplate>
                                        <tr class="row__data" data-id='<%# Eval("EVALUATE_ID") %>'>
                                            <th scope="row" class="text-center">
                                                <%# Container.ItemIndex + 1 %>
                                            </th>
                                             <td>
                                                <%# Eval("PersonCode") %>
                                            </td>
                                            <td>
                                                <%# Eval("EMPLOYEE_NAME_EN") %>
                                            </td>
                                            <td>
                                                <input class="" type="number" value='<%# Eval("SCORE_1") %>' class="form-control" />
                                            </td>
                                            <td>
                                                <input type="number" value='<%# Eval("SCORE_2") %>' class="form-control" />
                                            </td>
                                            <td>
                                                <input type="number" value='<%# Eval("SCORE_3") %>' class="form-control" />
                                            </td>
                                            <td>
                                                <input type="number" value='<%# Eval("SCORE_4") %>' class="form-control" />
                                            </td>
                                            <td>
                                                <input type="number" value='<%# Eval("SCORE_5") %>' class="form-control"/>
                                            </td>
                                            <td>
                                                <input type="number" value='<%# Eval("TOTAL_SCORE") %>' class="form-control" disabled="disabled"/>
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
                        <button type="button" class="btn btn-warning">Save (Draft)</button>
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
</asp:Content>


