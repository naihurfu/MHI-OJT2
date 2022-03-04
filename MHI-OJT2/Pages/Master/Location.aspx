<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Location.aspx.cs" Inherits="MHI_OJT2.Pages.Master.Location" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/jquery.dataTables.min.css">
    <style type="text/css">
        input[type=checkbox], input[type=radio] {
            width: 20px !important;
            height: 20px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Location</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-primary" onclick="handleShowModal('add', {})">Create</button>
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
                        <table class="hover nowrap" style="width:100%">
                            <thead>
                                <tr>
                                    <th class="text-center">NO.</th>
                                    <th>Location Name</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-center">Tools</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="RepeatTable" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <th scope="row" class="text-center">
                                                <%# Container.ItemIndex + 1 %>
                                            </th>
                                            <td><%# Eval("LOCATION_NAME") %></td>
                                            <td class="text-center">
                                                <span class='<%# (Boolean)Eval("IS_ACTIVE") == true ? "badge badge-success" : "badge badge-danger" %>'>
                                                    <%# (Boolean)Eval("IS_ACTIVE") == true ? "ACTIVE" : "INACTIVE" %> 
                                                </span>
                                            </td>
                                            <td class="text-center">
                                            <div class="btn-group" role="group" aria-label="Basic example">
                                                <button type="button" class="btn btn-sm btn-warning" onclick="handleShowModal('edit', { ID:<%# Eval("ID") %>, LOCATION_NAME: '<%# Eval("LOCATION_NAME") %>', IS_ACTIVE: <%# (Boolean)Eval("IS_ACTIVE") == true ? 1 : 0 %>, CREATED_NAME: '<%# Eval("CREATED_NAME") %>'  })">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button type="button" class="btn btn-sm btn-danger" onclick="handleShowModal('delete', { ID:<%# Eval("ID") %>, LOCATION_NAME: '<%# Eval("LOCATION_NAME") %>', IS_ACTIVE: <%# (Boolean)Eval("IS_ACTIVE") == true ? 1 : 0 %>, CREATED_NAME: '<%# Eval("CREATED_NAME") %>'  })">
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
    <div class="modal fade" id="crudModal" tabindex="-1" aria-labelledby="crudModal" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered" style="box-shadow: none !important;">
            <div class="modal-content">
                <div class="modal-header bg-primary">
                    <h5 class="modal-title text-light" id="titleModal"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>ชื่อสถานที่อบรม / Training location name</label>
                        <input type="text" class="form-control" id="locationName" runat="server">
                    </div>
                    <div class="pt-2 check-container">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="set-active" id="active" runat="server">
                            <label class="form-check-label" for="<%= active.ClientID %>">ใช้งาน / active</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="set-active" id="inactive" runat="server">
                            <label class="form-check-label" for="<%= inactive.ClientID %>">ไม่ใช้งาน/ inactive</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="justify-content: end !important;">
                    <input type="hidden" id="hiddenId" runat="server" />
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด/Close</button>
                    <button type="button" class="btn btn-danger" id="btnDelete" runat="server" onserverclick="Delete">ลบ/Delete</button>
                    <button type="button" class="btn btn-success" id="btnEdit" runat="server" onserverclick="Update">บันทึก/Save</button>
                    <button type="button" class="btn btn-primary" id="btnAdd" runat="server" onserverclick="Create">บันทึก/Save</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="script" runat="server">
    <script src="https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        (function () {
            $("table").DataTable({
                responsive: true,
                scrollX: 500,
                scrollCollapse: true,
                scroller: true
            });
        })();

        // modal title
        var modalTitle = $('#titleModal')

        // input variable
        var locationName = $('#<%= locationName.ClientID %>')
        var checkActive = $('#<%= active.ClientID %>')
        var checkInActive = $('#<%= inactive.ClientID %>')
        var hiddenId = $('#<%= hiddenId.ClientID %>')

        // control button 
        var btnAdd = $('#<%= btnAdd.ClientID %>')
        var btnEdit = $('#<%= btnEdit.ClientID %>')
        var btnDelete = $('#<%= btnDelete.ClientID %>')

        function handleShowModal(action, data) {
            setDefaultValue()
            const crudModal = $('#crudModal')
            switch (action) {
                case "add":
                    modalTitle.text('เพิ่มข้อมูล / Add data')
                    btnAdd.show()
                    checkActive.prop('checked', true)
                    crudModal.modal('show')
                    break

                case "edit":
                    modalTitle.text('แก้ไขข้อมูล / Edit data')
                    hiddenId.val(data.ID)
                    checkActive.prop('checked', data.IS_ACTIVE)
                    checkInActive.prop('checked', !data.IS_ACTIVE)
                    $('.check-container').show()
                    btnEdit.show()

                    locationName.val(data.locationName)

                    crudModal.modal('show')
                    break

                case "delete":
                    modalTitle.text('ลบข้อมูล / Delete data ?')
                    hiddenId.val(data.ID)
                    checkActive.prop('checked', data.IS_ACTIVE)
                    checkInActive.prop('checked', !data.IS_ACTIVE)
                    $('.check-container').hide()
                    btnDelete.show()

                    locationName.val(data.INITIAL_NAME)
                    locationName.prop("disabled", "disabled")

                    crudModal.modal('show')
                    break
            }
        }
        function setDefaultValue() {
            locationName.val('')

            btnAdd.hide()
            btnEdit.hide()
            btnDelete.hide()
            $('.check-container').hide()
            checkActive.prop('checked', false)
            checkInActive.prop('checked', false)
            hiddenId.val("")

            locationName.prop("disabled", false)
        }
    </script>
</asp:Content>