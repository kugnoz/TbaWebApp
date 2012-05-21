<html>
<head>
    <title>ID/Password Result page</title>
    <jsp:include page="env.jsp"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<h1 class="info">
    Welcome, <%= request.getParameter("nickname") %>
</h1>

<h1 class="info good">
    Your new token-based web account has been created.
</h1>

</body>
</html>