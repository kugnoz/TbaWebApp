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

    factory.setHost(HostInfo.MESSAGE_QUEUE_HOSTNAME);
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();
    channel.exchangeDeclare(MqConstants.EXCHANGE_NAME, "topic", true);

    try {
        // waiting the ACK from the the account
        String queueName = channel.queueDeclare().getQueue();
        channel.queueBind(queueName, MqConstants.EXCHANGE_NAME, MqConstants.ROUTING_CREATE_ACK + nonce);

        QueueingConsumer consumer = new QueueingConsumer(channel);
        channel.basicConsume(queueName, true, consumer);

        QueueingConsumer.Delivery delivery = consumer.nextDelivery(MqConstants.CREATE_ACK_TIMEOUT * 1000);
        rf.success = (delivery != null && new String(delivery.getBody()).equals(MqConstants.ACK_STRING));

        if (!rf.success) {
            DbHelper db = DbHelper.getInstance();
            DBCollection idColl = db.getCollection(DbHelper.COLL_TBA_ID);
            BasicDBObject query = new BasicDBObject();
            query.put("nickname", request.getParameter("nickname"));
            idColl.remove(query);
        }
    } catch (Exception e) {
        rf.success = false;
    } finally {
        channel.close();
    }
    out.print(gson.toJson(rf));
%>