<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Profiles.aspx.cs" Inherits="MHI_OJT2.Pages.Profiles" %>

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
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-6 col-12">
                   <div class="card card-primary card-outline">
                <div class="card-body box-profile">
                    <div class="text-center my-4">
                        <i class="fa fa-user fa-4x"></i>
                    </div>
                    <h3 class="profile-username text-center">
                        <%= Session["firstName"] + " " + Session["lastName"] %>
                    </h3>
                    <p class="text-muted text-center">
                        <%= Session["positionName"] %>
                    </p>
                    <ul class="list-group list-group-unbordered mb-3">
                        <li class="list-group-item">
                            <b>USERNAME </b> <span class="float-right"><%= Session["username"] %></span>
                        </li>
                        <li class="list-group-item">
                            <b>FULL NAME</b> <span class="float-right"><%= Session["firstName"] + " " + Session["lastName"] %></span>
                        </li>
                        <li class="list-group-item">
                            <b>POSITION</b> <span class="float-right"><%= Session["positionName"] %></span>
                        </li>
                         <li class="list-group-item">
                            <b>PERMISSION</b> 
                             <span class="float-right" style="text-transform: uppercase;">
                                <%= Session["roles"] %>                       
                             </span>
                        </li>
                    </ul>
                    <%--<a href="#" class="btn btn-primary btn-block"><b>Follow</b></a>--%>
                </div>

            </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="script" runat="server">
</asp:Content>
