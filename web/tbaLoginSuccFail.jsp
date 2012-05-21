<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="com.mongodb.DBCursor" %>
<%@ page import="com.mongodb.DBObject" %>
<%@ page import="com.rabbitmq.client.Channel" %>
<%@ page import="com.rabbitmq.client.Connection" %>
<%@ page import="com.rabbitmq.client.ConnectionFactory" %>
<%@ page import="com.rabbitmq.client.QueueingConsumer" %>
<%@ page import="kr.ac.ajou.dv.tbalib.crypto.CryptoConstants" %>
<%@ page import="kr.ac.ajou.dv.tbalib.messagequeue.MqConstants" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.DbHelper" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.HostInfo" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.security.MessageDigest" %>

<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%!
    class Result {
        boolean success;
        String message;
    }
%>

<%
    Gson gson = new Gson();
    Result rf = new Result();

    ConnectionFactory factory = new ConnectionFactory();
    String nonce = request.getParameter("nonce");

    factory.setHost(HostInfo.MESSAGE_QUEUE_HOSTNAME);
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();
    channel.exchangeDeclare(MqConstants.EXCHANGE_NAME, "topic", true);

    rf.success = false;
    rf.message = "";
    try {
        String queueName = channel.queueDeclare().getQueue();
        channel.queueBind(queueName, MqConstants.EXCHANGE_NAME, MqConstants.ROUTING_LOGIN + nonce);

        QueueingConsumer consumer = new QueueingConsumer(channel);
        channel.basicConsume(queueName, true, consumer);

        QueueingConsumer.Delivery delivery = consumer.nextDelivery(MqConstants.LOGIN_TIMEOUT * 1000);
        byte[] pubKey = (delivery != null) ? delivery.getBody() : null;

        if (pubKey == null) throw new Exception("The public key from a token-based authentication client did not transfer properly.");

        MessageDigest sha = MessageDigest.getInstance(CryptoConstants.DIGEST_ALGORITHM);
        sha.update(pubKey);
        byte[] digest = sha.digest();

        DbHelper db = DbHelper.getInstance();
        DBCollection c = db.getCollection(DbHelper.COLL_TBA_ID);
        BasicDBObject query = new BasicDBObject();

        query.put("digest", Base64.encodeBase64URLSafeString(digest));
        DBCursor check = c.find(query);

        while (check.hasNext()) {
            DBObject r = check.next();
            if (!r.get("pubKey").equals(Base64.encodeBase64URLSafeString(pubKey))) continue;
            session.setAttribute("userId", r.get("nickname"));
            rf.success = true;
        }
        check.close();
    } catch (Exception e) {
        rf.message = e.toString();
        rf.success = false;
    } finally {
        channel.close();
        connection.close();
    }
    out.print(gson.toJson(rf));
%>