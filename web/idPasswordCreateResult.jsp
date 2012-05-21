<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.DbHelper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>ID/Password Result page</title>
    <jsp:include page="env.jsp"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<%
    DbHelper db = DbHelper.getInstance();

    String userId = request.getParameter("userId");
    String password = request.getParameter("pw");

    DBCollection c = db.getCollection(DbHelper.COLL_PASSWORD_ID);
    BasicDBObject doc = new BasicDBObject();
    doc.put("id", userId);
    doc.put("pw", password);
    String retText;
    boolean sf = c.insert(doc).getLastError().ok();
    String cs;
    if (sf) {
        cs = "info good";
        retText = "Success to create a new ID: " + userId;
    } else {
        cs = "info bad";
        retText = "Fail to create a new ID: " + userId;
    }
%>
<h1 class="<%= cs %>"><%= retText %>
</h1>

</body>
</html>