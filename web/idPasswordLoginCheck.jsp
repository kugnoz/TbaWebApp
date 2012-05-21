<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="com.mongodb.DBCursor" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.DbHelper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>ID/Password Login Result Page</title>
    <jsp:include page="env.jsp"/>
</head>

<body>
<jsp:include page="header.jsp"/>

<%
    DbHelper db = DbHelper.getInstance();

    String userId = request.getParameter("userId");
    String password = request.getParameter("pw");

    DBCollection c = db.getCollection(DbHelper.COLL_PASSWORD_ID);
    BasicDBObject query = new BasicDBObject();
    query.put("id", userId);
    query.put("pw", password);
    DBCursor cur = c.find(query);

    String retText;
    String cs;
    boolean exist = cur.hasNext();
    cur.close();
    if (exist) {
        cs = "info good";
        retText = "Succeeded to log in: " + userId;
        session.setAttribute("userId", userId);
    } else {
        cs = "info bad";
        retText = "Failed to log in: " + userId;
    }


%>
<h2 class="<%= cs %>"><%= retText %>
</h2>
</body>
</html>