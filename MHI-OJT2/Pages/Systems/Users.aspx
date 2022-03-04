<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="MHI_OJT2.Pages.Systems.Users" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.4/css/jquery.dataTables.min.css">
    <style type="text/css">
        input[type=checkbox], input[type=radio] {
            width: 20px !important;
            height: 20px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Users</h1>
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
                    <table class="hover nowrap" style="width: 100%">
                        <thead>
                            <tr>
                                <th class="text-center">No.</th>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th class="text-center">Position</th>
                                <th class="text-center">Permission</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Created At</th>
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
                                        <td><%# Eval("USERNAME") %></td>
                                        <td><%# (string)Eval("INITIAL_NAME") + ' ' + (string)Eval("FIRST_NAME") + ' ' + (string)Eval("LAST_NAME") %></td>
                                        <td class="text-center"><%# Eval("POSITION_NAME") %></td>
                                        <td class="text-center"><%# Eval("ROLES") %></td>
                                        <td class="text-center">
                                            <span class='<%# (Boolean)Eval("IS_ACTIVE") == true ? "badge badge-success" : "badge badge-danger" %>'>
                                                <%# (Boolean)Eval("IS_ACTIVE") == true ? "ACTIVE" : "INACTIVE" %> 
                                            </span>
                                        </td>
                                        <td class="text-center"><%# Eval("CREATED_AT", "{0:dd/MM/yyyy}").ToString() %></td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <button type="button" class="btn btn-success" onclick="handleShowModal('change-password', { ID:<%# Eval("ID") %>,USERNAME: '<%# Eval("USERNAME") %>', INITIAL_NAME: '<%# Eval("INITIAL_NAME") %>', FIRST_NAME : '<%# Eval("FIRST_NAME") %>', LAST_NAME : '<%# Eval("LAST_NAME") %>', POSITION_NAME : '<%# Eval("POSITION_NAME") %>', ROLES : '<%# Eval("ROLES") %>' })">
                                                    <i class="fas fa-key"></i>
                                                </button>
                                                <button type="button" class="btn btn-warning" onclick="handleShowModal('edit', { ID:<%# Eval("ID") %>,USERNAME: '<%# Eval("USERNAME") %>', INITIAL_NAME: '<%# Eval("INITIAL_NAME") %>', FIRST_NAME : '<%# Eval("FIRST_NAME") %>', LAST_NAME : '<%# Eval("LAST_NAME") %>', POSITION_NAME : '<%# Eval("POSITION_NAME") %>', ROLES : '<%# Eval("ROLES") %>' })">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button type="button" class="btn btn-danger" onclick="handleShowModal('delete', { ID:<%# Eval("ID") %>,USERNAME: '<%# Eval("USERNAME") %>', INITIAL_NAME: '<%# Eval("INITIAL_NAME") %>', FIRST_NAME : '<%# Eval("FIRST_NAME") %>', LAST_NAME : '<%# Eval("LAST_NAME") %>', POSITION_NAME : '<%# Eval("POSITION_NAME") %>', ROLES : '<%# Eval("ROLES") %>'  })">
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
                    <div id="crud-container">
                        <div class="form-group">
                            <label>ชื่อผู้ใช้งาน / Username</label>
                            <input type="text" class="form-control" id="username" runat="server">
                        </div>
                        <div class="form-group">
                            <label>คำนำหน้าชื่อ / Initial name</label>
                            <input type="text" class="form-control" id="initialName" runat="server">
                        </div>
                        <div class="form-group">
                            <label>ชื่อ / First name</label>
                            <input type="text" class="form-control" id="firstName" runat="server">
                        </div>
                        <div class="form-group">
                            <label>นามสกุล / Last name</label>
                            <input type="text" class="form-control" id="lastName" runat="server">
                        </div>
                        <div class="form-group">
                            <label>ตำแหน่ง / Position name</label>
                            <input type="text" class="form-control" id="positionName" runat="server">
                        </div>
                        <div class="form-group">
                            <label>สิทธ์การใช้งาน / Permission</label>
                            <select class="form-control" id="roleName" runat="server">
                                <option value="CLERK">CLERK</option>
                                <option value="ADMIN">ADMIN</option>
                            </select>
                        </div>
                    </div>
                    <div id="change-password-container">
                        <div class="form-group">
                            <label>รหัสผ่านเก่า / Old Password</label>
                            <input type="password" class="form-control" id="oldPassword" runat="server" autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label>รหัสผ่านใหม่ / New Password</label>
                            <input type="password" class="form-control" id="password" runat="server" autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label>ยืนยันรหัสผ่าน / New Password Confirm</label>
                            <input type="password" class="form-control" id="confirmPassword" runat="server" autocomplete="off">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="justify-content: end !important;">
                    <input type="hidden" id="oldUsername" runat="server">
                    <input type="hidden" id="hiddenId" runat="server" />
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด/Close</button>
                    <button type="button" class="btn btn-success" id="btnChangePassword" runat="server" onserverclick="ChangePassword">เปลี่ยนรหัสผ่าน/Change password</button>
                    <button type="button" class="btn btn-danger" id="btnDelete" runat="server" onserverclick="Delete">ลบ/Delete</button>
                    <button type="button" class="btn btn-success" id="btnEdit" runat="server" onserverclick="Update">บันทึก/Save</button>
                    <button type="button" class="btn btn-primary" id="btnAdd" runat="server" onserverclick="Create">บันทึก/Save</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="ScriptContent" ContentPlaceHolderID="script" runat="server">
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
        var username = $('#<%= username.ClientID %>')
        var password = $('#<%= password.ClientID %>')
        var confirmPassword = $('#<%= confirmPassword.ClientID %>')
        var initialName = $('#<%= initialName.ClientID %>')
        var firstName = $('#<%= firstName.ClientID %>')
        var lastName = $('#<%= lastName.ClientID %>')
        var positionName = $('#<%= positionName.ClientID %>')
        var roleName = $('#<%= roleName.ClientID %>')

        var oldUsername = $('#<%= oldUsername.ClientID %>')
        var hiddenId = $('#<%= hiddenId.ClientID %>')
        var oldPassword = $('#<%= oldPassword.ClientID %>')

        // control button 
        var btnAdd = $('#<%= btnAdd.ClientID %>')
        var btnEdit = $('#<%= btnEdit.ClientID %>')
        var btnDelete = $('#<%= btnDelete.ClientID %>')
        var btnChangePassword = $('#<%= btnChangePassword.ClientID %>')

        function handleShowModal(action, data) {
            setDefaultValue()
            const crudModal = $('#crudModal')
            switch (action) {
                case "add":
                    $('#crud-container').show()
                    modalTitle.text('เพิ่มข้อมูล / Add data')
                    btnAdd.show()
                    crudModal.modal('show')
                    break

                case "edit":
                    $('#crud-container').show()
                    modalTitle.text('แก้ไขข้อมูล / Edit data')
                    btnEdit.show()

                    username.val(data.USERNAME)
                    initialName.val(data.INITIAL_NAME)
                    firstName.val(data.FIRST_NAME)
                    lastName.val(data.LAST_NAME)
                    positionName.val(data.POSITION_NAME)
                    roleName.val(data.ROLES.toUpperCase())

                    oldUsername.val(data.USERNAME)
                    hiddenId.val(data.ID)

                    crudModal.modal('show')
                    break

                case "delete":
                    $('#crud-container').show()
                    modalTitle.text('ลบข้อมูล / Delete data ?')
                    hiddenId.val(data.ID)
                    btnDelete.show()

                    username.val(data.USERNAME)
                    username.prop("disabled", "disabled")

                    initialName.val(data.INITIAL_NAME)
                    initialName.prop("disabled", "disabled")

                    firstName.val(data.FIRST_NAME)
                    firstName.prop("disabled", "disabled")

                    lastName.val(data.LAST_NAME)
                    lastName.prop("disabled", "disabled")

                    positionName.val(data.POSITION_NAME)
                    positionName.prop("disabled", "disabled")

                    roleName.val(data.ROLES.toUpperCase())
                    roleName.prop("disabled", "disabled")

                    oldUsername.val(data.USERNAME)
                    hiddenId.val(data.ID)

                    crudModal.modal('show')
                    break

                case "change-password":
                    modalTitle.text('เปลี่ยนรหัสผ่าน / Change password data')
                    $('#change-password-container').show()
                    hiddenId.val(data.ID)
                    crudModal.modal('show')
                    break
            }
        }
        function setDefaultValue() {
            $('#crud-container').hide()
            $('#change-password-container').hide()

            btnAdd.hide()
            btnEdit.hide()
            btnDelete.hide()
            btnChangePassword.hide()

            hiddenId.val("")
            username.val("")
            initialName.val("")
            firstName.val("")
            lastName.val("")
            positionName.val("")
            roleName.val("")
            oldPassword.val("")
            password.val("")
            confirmPassword.val("")
            oldUsername.val("")

            username.prop("disabled", false)
            initialName.prop("disabled", false)
            firstName.prop("disabled", false)
            lastName.prop("disabled", false)
            positionName.prop("disabled", false)
            roleName.prop("disabled", false)

        }
    </script>
</asp:Content>
