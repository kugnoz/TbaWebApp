<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.DbHelper" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head><title>The Prototype of "Token-based authentication for web applications"</title>
    <jsp:include page="env.jsp"/>
</head>

<body>
<jsp:include page="header.jsp">
    <jsp:param name="login" value="true"/>
    <jsp:param name="menu" value="true"/>
</jsp:include>
<%
    // clean old token-based authentication sessions
    DbHelper db = DbHelper.getInstance();
    DBCollection c = db.getCollection(DbHelper.COLL_TBA_SESSION);

    BasicDBObject query = new BasicDBObject();
    query.put("made", new BasicDBObject().append("$lt", new Date(new Date().getTime() - (180 * 1000))));
    c.remove(query);
%>
</body>
</html>
