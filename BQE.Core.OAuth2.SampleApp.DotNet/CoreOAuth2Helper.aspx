<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CoreOAuth2Helper.aspx.cs" Inherits="BQE.Core.OAuth2.SampleApp.DotNet.CoreOAuth2Helper" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <% if (HttpContext.Current.Session["accessToken"] != null && HttpContext.Current.Session["callMadeBy"] != null)
        {
            if (HttpContext.Current.Session["callMadeBy"].ToString() != "OpenId")
            {
                Response.Write("<script> window.opener.location.reload();window.close(); </script>");
            }
        }
    %>
    <link href="Contents/normalize.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i,800,800i|Roboto:100,100i,300,300i,400,400i,500,500i,700,700i,900,900i" rel="stylesheet" />
    <link href="Contents/prism.css" rel="stylesheet" />
    <link href="Contents/styles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-wrapper">
            <div class="page-title">
                <img src="Images/core.png" />
                <div class="logo-label">API Demo</div>
            </div>
            <div class="content-wrapper">
                The BQE Core Integration team has written this OAuth 2.0 Sample App in .NET to provide working examples of OAuth 2.0 concepts, and how to integrate with Core endpoints.
                <div class="sub-heading">Getting Started:</div>
                <div class="sub-heading-description">
                    Before beginning, it may be helpful to have a basic understanding of OAuth 2.0 concepts. To get started refer to <a href="https://sandbox-api-explorer.bqecore.com/docs/authentication-authorization" target="_blank">Core API Documentation</a>

                    The purpose of this sample app is to perform three basic functions:
                    <ul>
                        <li>Complete the Authorization process and get tokens for communicating with Core</li>
                        <li>Demonstrate how to implement Sign in with Core using OpenId scope</li>
                        <li>Call Core Public API resources using access token</li>
                        <li>Revoke the Tokens</li>
                    </ul>
                </div>
                <div class="sub-heading">Requirements:</div>
                <div class="sub-heading-description">
                    In order to successfully run this app, you need the following:
                    <ul>
                        <li>A Core <a href="https://sandbox-api-developer.bqecore.com/webapp/Account/Login?ReturnUrl=/webapp/" target="_blank">Developer Portal</a> account</li>
                        <li>An app on <a href="https://sandbox-api-developer.bqecore.com/webapp/Account/Login?ReturnUrl=/webapp/" target="_blank">Developer Portal</a> and the associated Client_id, Client_Secret and Redirect_URI</li>
                        <li>Core sandbox/Production  company </li>
                    </ul>
                </div>

                <div class="sub-heading">Run your app:</div>
                <div class="sub-heading-description">
                    All the configuration of this app is located in <span class="font-bold">web.config</span>.  Your values must match exactly with what is listed in your app settings on <span class="font-bold">Developer Portal</span>
                    To get started the developers need to make the required changes in web.config <span class="font-bold">appsettings</span> section. They can set the preferences like required endpoint urls, client app credentials and desired scopes for authentication. OAuth 2.0 needs core read write scopes for consuming CORE APIs. Additionally offline access scope will provide the refresh token while authenticating the client app. OpenId scope will provide user information like name, family name, email and will not work while connecting with Core.
                </div>

                <div id="connect" class="flex-columnwise" runat="server" visible="false">

                    <!-- Connect To Core Button -->
                    <div class="data-block">
                        <div class="flex-rowwise">
                            <img src="Images/core-mini-logo-white.png" />
                            <label>Connect to Core</label>
                            <asp:Button runat="server" OnClick="ConnectCore_Click" ID="btnCtcCore" CssClass="button" Text="Connect"></asp:Button>
                        </div>
                    </div>

                    <!-- Sign In With BQE Button -->
                    <div class="data-block">
                        <div class="flex-rowwise">
                            <img src="Images/core-mini-logo-white.png" />
                            <label>Sign In with Core</label>
                            <asp:Button runat="server" OnClick="SIWC_Click" ID="btnSIWC" CssClass="button" Text="Sign In" />
                        </div>
                    </div>


                    <!-- Get App Now -->
                    <%--<div class="data-block">
                        <div class="flex-rowwise">
                            <img src="Images/core-mini-logo-white.png" />
                            <label>Get App Now</label>
                            <asp:Button runat="server" OnClick="OpenId_Click" ID="btnOpenId" CssClass="button" Text="Get App"></asp:Button>
                        </div>
                    </div>--%>
                </div>

                <div id="disconnectCore" runat="server" visible="false" class="connected-state">
                    <p class="success-message">
                        <asp:Label runat="server" ID="lblConnected">You are connected!</asp:Label>
                    </p>

                    <asp:Button runat="server" OnClick="CoreAPICall_Click" ID="btnCheckCoreAPICall" CssClass="button margin-right-10" Text="Check Connection"></asp:Button>
                    <asp:Button runat="server" OnClick="CoreAPIPOST_Click" ID="btnPOSTAPI" CssClass="button margin-right-10" Text="Add New Account"></asp:Button>
                    <asp:Button runat="server" OnClick="Disconnect_Click" ID="btnRevoke" CssClass="button button-secondary" Text="Disconnect"></asp:Button>

                    <div id="coreResponse" runat="server" visible="false" class="server-response">
                        <div class="heading flex-columnwise">
                            <img src="Images/success.png" class="margin-right-10" />
                            Communication with Core OK.
                        </div>

                        <div class="connection-details-heading">Connection Details</div>
                        <div class="code-toolbar">
                            <pre class="language-json">
                               <code class="language-json">
                                     <asp:Label runat="server" ID="lblCoreCall"></asp:Label>
                               </code>
                            </pre>
                        </div>
                    </div>

                </div>


                <div id="signInwithBQE" runat="server" visible="false" class="connected-state">
                    <p class="success-message">
                        <asp:Label runat="server" ID="Label1">You are connected!</asp:Label>
                    </p>

                    <asp:Button runat="server" OnClick="UserInfoAPICall_Click" ID="btnUserInfo" CssClass="button margin-right-10" Text="User Details"></asp:Button>
                    <asp:Button runat="server" OnClick="Disconnect_Click" ID="signInDisconnect" CssClass="button button-secondary" Text="Disconnect"></asp:Button>

                    <div id="userInfoResponse" runat="server" visible="false" class="server-response">
                        <div class="heading flex-columnwise">
                            <img src="Images/success.png" class="margin-right-10" />
                            Communication with Core OK.
                        </div>

                        <div class="connection-details-heading">User Info</div>
                        <div class="code-toolbar">
                            <pre class="language-json">
                               <code class="language-json">
                                     <asp:Label runat="server" ID="lblUserInfo"></asp:Label>
                               </code>
                            </pre>
                        </div>
                    </div>
                </div>



            </div>
        </div>
    </form>

    <script src="js/prism.js"></script>
</body>
</html>
