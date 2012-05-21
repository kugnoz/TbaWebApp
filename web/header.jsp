<%@ page import="kr.ac.ajou.dv.tbawebapp.HostInfo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<header>
    <a href="index.jsp" class="nostyle"><h1 class="title">Token-based Authentication for Web Applications</h1></a>

    <% if (request.getParameter("login") != null) { %>
    <h1 class='info'>
        <% String userId = (String) session.getAttribute("userId");
            if (userId != null) {
                out.print("Hello, " + userId + ".");
        %>
        <a href="logout.jsp">Logout.</a>
        <%
            } else {
                out.println("Not logged in.");
            }
        %>
    </h1>
    <% } %>

    <% if (request.getParameter("menu") != null) { %>
    <nav>
        <ul>
            <li><a href="clearDb.jsp">Initialize the database</a></li>
            <br/>
            <li><a href="idPasswordCreate.jsp">Create a new account with ID/Password</a></li>
            <li><a href="idPasswordLogin.jsp">Login with ID/Password</a></li>
            <li><a href="tbaCreate.jsp">Create a new account for token-based authentication (QRCode)</a></li>
            <li><a href="tbaLogin.jsp">Login with an authentication token (QRCode)</a></li>
        </ul>
    </nav>
    <h2 class='info'><img src="apkqrcode?url=<%= HostInfo.getWebAppName() + "/TBAclient.apk"%>">
        <br/>
        Download the client for Android phones (APK)
    </h2>
    <% } %>
</header>

<% if (request.getParameter("menu") != null) { %>
<script type="text/javascript">
    $(function () {
        $('nav > ul > li').addClass("button");
        $('nav > ul > li > a').addClass("menustyle");
        $('nav > ul').addClass('nobullet');
    });
</script>
<% } %>