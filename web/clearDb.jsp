<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.DbHelper" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Clear Database</title>
    <jsp:include page="env.jsp"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<%
    DbHelper db = DbHelper.getInstance();
    DBCollection c = db.getCollection(DbHelper.COLL_PASSWORD_ID);
    BasicDBObject query = new BasicDBObject();
    c.remove(query);
    c = db.getCollection(DbHelper.COLL_TBA_ID);
    c.remove(query);
    c = db.getCollection(DbHelper.COLL_TBA_SESSION);
    c.remove(query);
%>
<h2 class='info good'>Database has been initialized.
</h2>

</body>
</html>