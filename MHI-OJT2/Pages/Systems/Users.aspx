<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="MHI_OJT2.Pages.Systems.Users" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
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
                    <h1 class="m-0">จัดการผู้ใช้ระบบ</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <div class="float-sm-right">
                        <button type="button" class="btn btn-primary" onclick="handleShowModal('add', {})">เพิ่มผู้ใช้งาน</button>
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
                                <th class="text-center">ลำดับ</th>
                                <th>ชื่อผู้ใช้งาน</th>
                                <th>ชื่อ-สกุล</th>
                                <th>ตำแหน่ง</th>
                                <th class="text-center">สิทธิ์การใช้งาน</th>
                                <th class="text-center">สถานะใช้งาน</th>
                                <th class="text-center">สร้างเมื่อ</th>
                                <th class="text-center">เครื่องมือ</th>
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
                                        <td><%# Eval("POSITION_NAME") %></td>
                                        <td class="text-center"><%# Eval("ROLES").ToString().ToUpper() %></td>
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
                                                <button type="button" class="btn btn-warning" onclick="handleShowModal('edit', { ID:<%# Eval("ID") %>,USERNAME: '<%# Eval("USERNAME") %>', INITIAL_NAME: '<%# Eval("INITIAL_NAME") %>', FIRST_NAME : '<%# Eval("FIRST_NAME") %>', LAST_NAME : '<%# Eval("LAST_NAME") %>', POSITION_NAME : '<%# Eval("POSITION_NAME") %>', ROLES : '<%# Eval("ROLES") %>', IS_EDIT_MASTER : <%# (Boolean)Eval("IS_EDIT_MASTER") == true ? 1 : 0 %> })">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button type="button" class="btn btn-danger" onclick="handleShowModal('delete', { ID:<%# Eval("ID") %>,USERNAME: '<%# Eval("USERNAME") %>', INITIAL_NAME: '<%# Eval("INITIAL_NAME") %>', FIRST_NAME : '<%# Eval("FIRST_NAME") %>', LAST_NAME : '<%# Eval("LAST_NAME") %>', POSITION_NAME : '<%# Eval("POSITION_NAME") %>', ROLES : '<%# Eval("ROLES") %>', IS_EDIT_MASTER : <%# (Boolean)Eval("IS_EDIT_MASTER") == true ? 1 : 0 %>  })">
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
        <div class="modal-dialog modal-dialog-scrollable modal-lg modal-dialog-centered" style="box-shadow: none !important;">
            <div class="modal-content dark-mode">
                <div class="modal-header">
                    <h5 class="modal-title text-light" id="titleModal"></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: white;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="crud-container">
                        <div class="form-group">
                            <label>ชื่อผู้ใช้งาน</label>
                            <input type="text" class="form-control" id="username" runat="server" autocomplete="off">
                        </div>
                        <div class="add-password row">
                            <div class="col-6">
                                <div class="form-group">
                                    <label>รหัสผ่าน</label>
                                    <input type="password" class="form-control" id="addPassword" runat="server" autocomplete="off">
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="form-group">
                                    <label>ยืนยันรหัสผ่าน</label>
                                    <input type="password" class="form-control" id="addConfirmPassword" runat="server" autocomplete="off">
                                </div>
                            </div>
                        </div>
                        <hr style="border-top: 1px solid rgba(255,255,255,0.3)" />
                        <div class="row">
                            <div class="col-2">
                                <div class="form-group">
                                    <label>คำนำหน้าชื่อ</label>
                                    <input type="text" class="form-control" id="initialName" runat="server" autocomplete="off">
                                </div>
                            </div>
                            <div class="col-5">
                                <div class="form-group">
                                    <label>ชื่อ</label>
                                    <input type="text" class="form-control" id="firstName" runat="server" autocomplete="off">
                                </div>
                            </div>
                            <div class="col-5">
                                <div class="form-group">
                                    <label>นามสกุล</label>
                                    <input type="text" class="form-control" id="lastName" runat="server" autocomplete="off">
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>ตำแหน่ง</label>
                            <input type="text" class="form-control" id="positionName" runat="server" autocomplete="off">
                        </div>
                        <hr style="border-top: 1px solid rgba(255,255,255,0.3); margin-top: 2rem;" />
                        <div class="row">
                            <div class="col-6">
                                <div class="form-group">
                                    <label>สิทธ์การใช้งาน</label>
                                    <select class="form-control" id="roleName" runat="server">
                                        <option value="CLERK">CLERK</option>
                                        <option value="ADMIN">ADMIN</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="form-group">
                                    <label>สิทธิ์ในการ เพิ่ม/ลบ/แก้ไข ข้อมูล Master</label>
                                    <select class="form-control" id="editMaster" runat="server">
                                        <option value="1">อนุญาต</option>
                                        <option value="0">ไม่อนุญาต</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="change-password-container">
                        <div class="form-group">
                            <label>รหัสผ่านเก่า</label>
                            <input type="password" class="form-control" id="oldPassword" runat="server" autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label>รหัสผ่านใหม่</label>
                            <input type="password" class="form-control" id="password" runat="server" autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label>ยืนยันรหัสผ่าน</label>
                            <input type="password" class="form-control" id="confirmPassword" runat="server" autocomplete="off">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="justify-content: end !important;">
                    <input type="hidden" id="oldUsername" runat="server">
                    <input type="hidden" id="hiddenId" runat="server" />
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด</button>
                    <button type="button" class="btn btn-success" id="btnChangePassword" runat="server" onserverclick="ChangePassword">เปลี่ยนรหัสผ่าน</button>
                    <button type="button" class="btn btn-danger" id="btnDelete" runat="server" onserverclick="Delete">ลบ</button>
                    <button type="button" class="btn btn-success" id="btnEdit" runat="server" onserverclick="Update">บันทึก</button>
                    <button type="button" class="btn btn-primary" id="btnAdd" runat="server" onserverclick="Create">บันทึก</button>
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
                scroller: true,
                "oLanguage": {
                    "sSearch": "ค้นหา :",
                    "sLengthMenu": "แสดง _MENU_ รายการ"
                },
                "language": {
                    "info": "แสดง _START_-_END_ รายการ ทั้งหมด _TOTAL_ รายการ",
                    "paginate": {
                        "previous": "ย้อนกลับ",
                        "next": "หน้าถัดไป"
                    }
                }
            });

            $('.dataTables_filter label input').attr('autocomplete', 'off');

            setTimeout(function () {
                $('.dataTables_filter label input').val('');
            }, 2000)
        })();



        // modal title
        var modalTitle = $('#titleModal')

        // input variable
        var username = $('#<%= username.ClientID %>')
        var addPassword = $('#<%= addPassword.ClientID %>')
        var addConfirmPassword = $('#<%= addConfirmPassword.ClientID %>')
        var password = $('#<%= password.ClientID %>')
        var confirmPassword = $('#<%= confirmPassword.ClientID %>')
        var initialName = $('#<%= initialName.ClientID %>')
        var firstName = $('#<%= firstName.ClientID %>')
        var lastName = $('#<%= lastName.ClientID %>')
        var positionName = $('#<%= positionName.ClientID %>')
        var roleName = $('#<%= roleName.ClientID %>')
        var editMaster = $('#<%= editMaster.ClientID %>')

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
                    modalTitle.text('เพิ่มผู้ใช้งาน')
                    btnAdd.show()
                    crudModal.modal('show')
                    password.val('')
                    confirmPassword.val('')
                    $('.add-password').show()
                    break

                case "edit":
                    $('#crud-container').show()
                    modalTitle.text('แก้ไขข้อมูล')
                    btnEdit.show()

                    username.val(data.USERNAME)
                    initialName.val(data.INITIAL_NAME)
                    firstName.val(data.FIRST_NAME)
                    lastName.val(data.LAST_NAME)
                    positionName.val(data.POSITION_NAME)
                    roleName.val(data.ROLES.toUpperCase())
                    editMaster.val(data.IS_EDIT_MASTER)

                    oldUsername.val(data.USERNAME)
                    hiddenId.val(data.ID)

                    crudModal.modal('show')
                    $('.add-password').hide()
                    break

                case "delete":
                    $('#crud-container').show()
                    modalTitle.text('ลบข้อมูล?')
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

                    editMaster.val(data.IS_EDIT_MASTER)
                    editMaster.prop("disabled", "disabled")

                    oldUsername.val(data.USERNAME)
                    hiddenId.val(data.ID)

                    crudModal.modal('show')
                    break

                case "change-password":
                    modalTitle.text('เปลี่ยนรหัสผ่าน')
                    $('#change-password-container').show()
                    hiddenId.val(data.ID)
                    crudModal.modal('show')
                    btnChangePassword.show()
                    $('.add-password').hide()
                    break
            }
        }
        function setDefaultValue() {
            $('#crud-container').hide()
            $('#change-password-container').hide()
            $('.add-password').hide()

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
            roleName.val("CLERK")
            editMaster.val(1)
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
