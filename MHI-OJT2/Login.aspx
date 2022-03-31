<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MHI_OJT2.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>OJT TRAINING - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Kanit:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet" />
    <style>
        .font-kanit {
            font-family: 'Kanit', sans-serif !important;
        }

        body {
            font-family: 'Kanit', sans-serif;
        }
    </style>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="~/Assets/plugins/fontawesome-free/css/all.min.css" />
    <!-- IonIcons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" />
    <!-- Theme style -->
    <link rel="stylesheet" href="~/Assets/dist/css/adminlte.min.css" />
</head>
<body>
    <form id="formLogin" runat="server" style="min-width: 100%; min-height: 100vh; background-color: #f9fafe">
        <script type="text/javascript">
            function sweetAlert(type, title, message) {
                Swal.fire(title, message, type);
            }
        </script>
        <div class="d-flex align-items-center min-vh-100" style="background-color: #343A40">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-12" align="center">
                        <div class="card card-success" style="max-width: 350px !important;">
                            <div class="card-body">
                                <div class="row mb-3 justify-content-between">
                                    <div class="col">
                                        <h5>MCCT - OJT Training</h5>
                                    </div>
                                </div>

                                <div class="container">
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">
                                                <i class="fa fa-user"></i>
                                            </span>
                                        </div>
                                        <input runat="server" id="username" placeholder="Username" type="text" class="form-control font-kanit" />
                                    </div>
                                    <br />

                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">
                                                <i class="fa fa-lock"></i>
                                            </span>
                                        </div>
                                        <input runat="server" id="password" placeholder="Password" type="password" class="form-control font-kanit" />
                                    </div>
                                    <br />

                                    <button class="btn btn-primary btn-block font-kanit" runat="server" onserverclick="HandleLogin" id="loginButton">เข้าสู่ระบบ</button>
                                    <br />

                                    <div class="footer">
                                        <div class="col font-kanit" style="text-align: center; font-size: 10px; letter-spacing: 1px; opacity: 0.7; color: black;">
                                            MHI - OJT Training © <%= DateTime.Now.Year.ToString() %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <asp:ScriptManager ID="ScriptManager" runat="server">
            <Scripts>
                <asp:ScriptReference Path="~/Assets/js/sweetalert.all.min.js" />
                <asp:ScriptReference Path="~/Assets/plugins/jquery/jquery.min.js" />
            </Scripts>
        </asp:ScriptManager>
    </form>
</body>
</html>
