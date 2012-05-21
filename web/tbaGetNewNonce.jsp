<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="com.mongodb.DBCursor" %>
<%@ page import="kr.ac.ajou.dv.tbalib.authtoken.AuthToken" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.DbHelper" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.util.Date" %>

<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%!
    class Result {
        String nonce;
    }
%>

<%
    SecureRandom sr = new SecureRandom();
    Gson gson = new Gson();
    Result rf = new Result();

    DbHelper db = DbHelper.getInstance();
    DBCollection c = db.getCollection(DbHelper.COLL_TBA_SESSION);

    BasicDBObject query;

    DBCursor cur;
    do {
        rf.nonce = Base64.encodeBase64URLSafeString(sr.generateSeed(AuthToken.NONCE_SIZE));
        query = new BasicDBObject();
        query.put("nonce", rf.nonce);
        cur = c.find(query);
    } while (cur.hasNext());
    query.put("made", new Date());
    c.insert(query);

    cur.close();
    out.print(gson.toJson(rf));
%>
