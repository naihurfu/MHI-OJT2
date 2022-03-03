﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Training-plans.aspx.cs" Inherits="MHI_OJT2.Pages.Management.Training_plans" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/jquery.dataTables.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Training Plans</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-primary" onclick="handleShowAddModal('add')">Create</button>
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
                <div class="card-body">
                        <table class="hover nowrap" id="trainingPlanTable" style="width:100%;">
                            <thead>
                                <tr>
                                    <th class="text-center">NO.</th>
                                    <th>Plan name</th>
                                    <th>Department</th>
                                    <th>Plan date</th>
                                    <th class="text-center">Tools</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="RepeatTrainingPlanTable" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <th scope="row" class="text-center">
                                                <%# Container.ItemIndex + 1 %>
                                            </th>
                                            <td><%# Eval("PLAN_NAME") %></td>
                                            <td><%# Eval("DEPARTMENT_NAME") %></td>
                                            <td><%# String.Format(new System.Globalization.CultureInfo("en-US"), "{0:dd MMM yyyy}", Eval("PLAN_DATE")) %></td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group" aria-label="Basic example">
                                                    <button type="button" class="btn btn-sm btn-warning" onclick="handleShowAddModal('edit', { ID: <%# Eval("ID") %>, DEPARTMENT_ID: <%# Eval("DEPARTMENT_ID") %>, PLAN_NAME: '<%# Eval("PLAN_NAME") %>', REF_DOCUMENT: '<%# Eval("REF_DOCUMENT") %>', HOURS: <%# Eval("HOURS") %>, FREQUENCY: '<%# Eval("FREQUENCY") %>', SM_MG: <%# bool.Parse(Eval("SM_MG").ToString()) == true ? 1 : 0  %>, SAM_AM: <%# bool.Parse(Eval("SAM_AM").ToString()) == true ? 1 : 0  %>, SEG_SV: <%# bool.Parse(Eval("SEG_SV").ToString()) == true ? 1 : 0  %>, EG_ST: <%# bool.Parse(Eval("EG_ST").ToString()) == true ? 1 : 0  %>, FM: <%# bool.Parse(Eval("FM").ToString()) == true ? 1 : 0  %>, LD_SEP_EP: <%# bool.Parse(Eval("LD_SEP_EP").ToString()) == true ? 1 : 0  %>, OP: <%# bool.Parse(Eval("OP").ToString()) == true ? 1 : 0  %>, PLAN_DATE: '<%# Eval("PLAN_DATE") %>', ACTUAL_DATE: '<%# Eval("ACTUAL_DATE") %>', TRAINER: '<%# Eval("TRAINER") %>' })">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-danger" onclick="handleDelete(<%# Eval("ID") %>, '<%# Eval("PLAN_NAME") %>')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <!-- /.content -->
</asp:Content>
<asp:Content ID="ModalContent" ContentPlaceHolderID="modal" runat="server">
    <%-- Modal --%>
    <div class="modal fade" id="addModal" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered modal-xl" style="box-shadow: none !important;">
            <div class="modal-content">
                <div class="modal-header bg-danger">
                    <h5 class="modal-title text-light">Create an annual training plan</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-8">
                            <label>Training plan name</label>
                            <input runat="server" id="planName" class="form-control" />
                        </div>
                        <div class="form-group col-4">
                            <label>Document reference number</label>
                            <input runat="server" id="refDocument" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Department</label>
                        <select class="form-control" id="department" runat="server">
                            <option selected>-</option>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-10">
                            <label>Frequency</label>
                            <input runat="server" id="frequency" class="form-control" />
                        </div>
                        <div class="form-group col-2">
                            <label>Total hours</label>
                            <input runat="server" id="hours" class="form-control" />
                        </div>
                    </div>
                    <div class="row justify-content-between mt-1" style="margin: auto 0;">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="SM_MG" value="SM_MG" runat="server">
                            <label class="form-check-label" for="<%= SM_MG.ClientID %>">SM_MG</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="SAM_AM" value="SAM_AM" runat="server">
                            <label class="form-check-label" for="<%= SAM_AM.ClientID %>">SAM_AM</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="SEG_SV" value="SEG_SV" runat="server">
                            <label class="form-check-label" for="<%= SEG_SV.ClientID %>">SEG_SV</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="EG_ST" value="EG_ST" runat="server">
                            <label class="form-check-label" for="<%= EG_ST.ClientID %>">EG_ST</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="FM" value="FM" runat="server">
                            <label class="form-check-label" for="<%= FM.ClientID %>">FM</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="LD_SEP_EP" value="LD_SEP_EP" runat="server">
                            <label class="form-check-label" for="<%= LD_SEP_EP.ClientID %>">LD_SEP_EP</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="OP" value="OP" runat="server">
                            <label class="form-check-label" for="<%= OP.ClientID %>">OP</label>
                        </div>
                    </div>
                    <div class="form-row mt-3">
                        <div class="form-group col-8">
                            <label>Trainer</label>
                            <input runat="server" id="trainer" class="form-control" />
                        </div>
                        <div class="form-group col-4">
                            <label>Training plan date</label>
                            <input type="tel" id="date" runat="server" class="form-control" maxlength="10" placeholder="dd/mm/yyyy" oninput="this.value = DDMMYYYY(this.value, event)" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="hidden" runat="server" id="hiddenIdAddModal" />
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-primary" Text="Update" OnClick="btnEdit_Click" />
                    <asp:Button ID="btnInserted" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnInserted_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ScriptContent" ContentPlaceHolderID="script" runat="server">
    <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        (function () {
            $("#trainingPlanTable").DataTable({
                responsive: true,
                scrollX: 500,
                scrollCollapse: true,
                scroller: true
            });
        })();

        function handleShowAddModal(action, data) {
            try {
                var addModal = new bootstrap.Modal(document.getElementById("addModal"), {});
                var insertButton = $('#<%= btnInserted.ClientID %>')
                var editButton = $('#<%= btnEdit.ClientID %>')
                var inputHiddenId = $('#<%= hiddenIdAddModal.ClientID %>')

                insertButton.hide()
                editButton.hide()
                clearInput()

                if (!action) throw new Error('Action is undefined')
                switch (action) {
                    case "add":
                        insertButton.show()
                        addModal.show()
                        break

                    case "edit":
                        inputHiddenId.val(data.ID)
                        $('#<%= planName.ClientID %>').val(data.PLAN_NAME)
                        $('#<%= refDocument.ClientID %>').val(data.REF_DOCUMENT)
                        $('#<%= department.ClientID %>').val(data.DEPARTMENT_ID)
                        $('#<%= frequency.ClientID %>').val(data.FREQUENCY)
                        $('#<%= hours.ClientID %>').val(data.HOURS)
                        $('#<%= SM_MG.ClientID %>').prop('checked', data.SM_MG)
                        $('#<%= SAM_AM.ClientID %>').prop('checked', data.SAM_AM)
                        $('#<%= SEG_SV.ClientID %>').prop('checked', data.SEG_SV)
                        $('#<%= EG_ST.ClientID %>').prop('checked', data.EG_ST)
                        $('#<%= FM.ClientID %>').prop('checked', data.FM)
                        $('#<%= LD_SEP_EP.ClientID %>').prop('checked', data.LD_SEP_EP)
                        $('#<%= OP.ClientID %>').prop('checked', data.OP)
                        $('#<%= trainer.ClientID %>').val(data.TRAINER)
                        $('#<%= date.ClientID %>').val(data.PLAN_DATE.split(' ')[0])

                        editButton.show()
                        addModal.show()
                        break

                    default: throw new Error("Action not found.")
                }
            } catch (err) {
                console.log(err)
                sweetAlert('error', 'Failed!', 'Network connection encountered a problem. Please try again later.')
            }
        }
        function handleDelete(id, planName) {
            Swal.fire({
                title: 'Do you want to delete?',
                showConfirmButton: false,
                showCancelButton: true,
                showDenyButton: true,
                confirmButtonText: 'Save',
                denyButtonText: `Delete`,
                cancelButtonText: `Cancel`
            }).then((result) => {
                /* Read more about isConfirmed, isDenied below */
                if (result.isDenied) {
                    $.ajax({
                        type: "POST",
                        url: "/Pages/Management/Training-plans.aspx/DeletePlan",
                        data: "{'planId': " + id + "}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (results) {
                            console.log(results.d)
                            switch (results.d) {
                                case "USED":
                                    Swal.fire('Failed!', 'Cannot be deleted, data is already in use.', 'error')
                                    break

                                case "SUCCESS":
                                    window.location.href = window.location.href;
                                    break

                                case "ERROR":
                                    Swal.fire('Error!', 'Network connection encountered a problem. Please try again later.', 'error')
                                    break
                            }
                        },
                        error: function (err) {
                            console.log(err)
                        }
                    });
                }
            })
        }
        function clearInput() {
            $('#<%= hiddenIdAddModal.ClientID %>').val()
            $('#<%= planName.ClientID %>').val()
            $('#<%= refDocument.ClientID %>').val()
            $('#<%= department.ClientID %>').val()
            $('#<%= frequency.ClientID %>').val()
            $('#<%= hours.ClientID %>').val()
            $('#<%= SM_MG.ClientID %>').prop('checked', 0)
            $('#<%= SAM_AM.ClientID %>').prop('checked', 0)
            $('#<%= SEG_SV.ClientID %>').prop('checked', 0)
            $('#<%= EG_ST.ClientID %>').prop('checked', 0)
            $('#<%= FM.ClientID %>').prop('checked', 0)
            $('#<%= LD_SEP_EP.ClientID %>').prop('checked', 0)
            $('#<%= OP.ClientID %>').prop('checked', 0)
            $('#<%= trainer.ClientID %>').val()
            $('#<%= date.ClientID %>').val()
        }
    </script>
</asp:Content>