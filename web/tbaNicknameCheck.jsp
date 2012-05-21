<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="com.mongodb.DBCursor" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.DbHelper" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>

<%!
    class Result {
        Boolean available;
    }

%>

<%
    String nick = request.getParameter("wantedname");
    Gson gson = new Gson();
    Result rf = new Result();
    DbHelper db = DbHelper.getInstance();

    DBCollection c = db.getCollection(DbHelper.COLL_TBA_ID);
    BasicDBObject query = new BasicDBObject();
    query.put("nickname", nick);
    DBCursor cur = c.find(query);
    rf.available = (cur.hasNext()) ? false : true;
    out.print(gson.toJson(rf));
    cur.close();
%>
