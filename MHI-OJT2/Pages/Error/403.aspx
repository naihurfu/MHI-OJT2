<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="403.aspx.cs" Inherits="MHI_OJT2.Pages.Error._403" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <!-- Content Header (Page header) -->
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0"></h1>
                </div>
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->
    <!-- Main content -->
    <div class="content">
            <div class="d-flex align-items-center" style="min-height: calc(100vh - calc(8rem + 120px));">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-12" align="center">
                            <h3>
                                <i class="fas fa-exclamation-triangle text-danger"></i>
                                สิทธิ์การใช้งานของคุณไม่อนุญาติให้เข้าถึงหน้านี้
                            </h3>
                        </div>
                    </div>
                </div>
            </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modal" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="script" runat="server">
</asp:Content>
