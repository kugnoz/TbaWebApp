<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBCollection" %>
<%@ page import="com.rabbitmq.client.Channel" %>
<%@ page import="com.rabbitmq.client.Connection" %>
<%@ page import="com.rabbitmq.client.ConnectionFactory" %>
<%@ page import="com.rabbitmq.client.QueueingConsumer" %>
<%@ page import="kr.ac.ajou.dv.tbalib.messagequeue.MqConstants" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.DbHelper" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.HostInfo" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="kr.ac.ajou.dv.tbalib.crypto.CryptoConstants" %>

<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%!
    class Result {
        boolean success;
    }
%>

<%
    ConnectionFactory factory = new ConnectionFactory();
    Gson gson = new Gson();
    String nonce = request.getParameter("nonce");

    Result rf = new Result();
    boolean flag = false;

    factory.setHost(HostInfo.MESSAGE_QUEUE_HOSTNAME);
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();
    channel.exchangeDeclare(MqConstants.EXCHANGE_NAME, "topic", true);

    byte[] pubKey = null;
    try {
        String queueName = channel.queueDeclare().getQueue();
        channel.queueBind(queueName, MqConstants.EXCHANGE_NAME, MqConstants.ROUTING_CREATE + nonce);

        QueueingConsumer consumer = new QueueingConsumer(channel);
        channel.basicConsume(queueName, true, consumer);

        QueueingConsumer.Delivery delivery = consumer.nextDelivery(MqConstants.CREATE_TIMEOUT * 1000);
        pubKey = (delivery != null) ? delivery.getBody() : null;

        DbHelper db = DbHelper.getInstance();
        DBCollection idColl = db.getCollection(DbHelper.COLL_TBA_ID);
        BasicDBObject query = new BasicDBObject();
        query.put("nickname", request.getParameter("nickname"));
        query.put("pubKey", Base64.encodeBase64URLSafeString(pubKey));
        MessageDigest sha = MessageDigest.getInstance(CryptoConstants.DIGEST_ALGORITHM);
        sha.update(pubKey);
        byte[] digest = sha.digest();
        query.put("digest", Base64.encodeBase64URLSafeString(digest));
        idColl.insert(query);
    } catch (Exception e) {
        flag = true;
    } finally {
        channel.close();
        connection.close();
    }
    rf.success = (!flag && pubKey != null);
    out.print(gson.toJson(rf));
%>
