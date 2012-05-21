<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>ID/Password Result page</title>
    <jsp:include page="env.jsp"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<%
    session.removeAttribute("userId");
%>
<h2 class='info good'>Logged out.
</h2>

</body>
</html>