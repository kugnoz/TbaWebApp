<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.rabbitmq.client.Channel" %>
<%@ page import="com.rabbitmq.client.Connection" %>
<%@ page import="com.rabbitmq.client.ConnectionFactory" %>
<%@ page import="kr.ac.ajou.dv.tbalib.authtoken.AuthToken" %>
<%@ page import="kr.ac.ajou.dv.tbalib.authtoken.SignUpInterface" %>
<%@ page import="kr.ac.ajou.dv.tbalib.messagequeue.MqConstants" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.HostInfo" %>
<%@ page import="kr.ac.ajou.dv.tbawebapp.KeyBank" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.security.interfaces.RSAPrivateKey" %>

<%@ page contentType="application/json;charset=UTF-8" language="java" %>

<%
    Gson gson = new Gson();
    RSAPrivateKey privateKey = KeyBank.getInstance().getPrivKey();
    ConnectionFactory factory = new ConnectionFactory();
    SignUpInterface rf = new SignUpInterface();

    // set up RabbitMQ
    factory.setHost(HostInfo.MESSAGE_QUEUE_HOSTNAME);
    Connection connection = factory.newConnection();
    Channel channel = connection.createChannel();
    channel.exchangeDeclare(MqConstants.EXCHANGE_NAME, "topic", true);

    String base64CipherText = request.getParameter("ciphertext");
    byte[] ciphertext = Base64.decodeBase64(base64CipherText);
    rf.decryptedWell = false;
    rf.rightSignature = false;
    rf.registered = false;
    try {
        // decrypt and verify the auth token from the client
        AuthToken token = AuthToken.decrypt(ciphertext, privateKey);
        rf.decryptedWell = true;
        rf.rightSignature = token.verify();

        // publish to web interface
        channel.basicPublish(
                MqConstants.EXCHANGE_NAME,
                MqConstants.ROUTING_CREATE + token.getNonceString(),
                null,
                token.getPublicKey());

        rf.registered = true;
        rf.message = null;
    } catch (Exception e) {
        rf.message = e.toString();
    } finally {
        channel.close();
        connection.close();
    }
    out.print(gson.toJson(rf));
%>
