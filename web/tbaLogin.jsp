<%@ page import="kr.ac.ajou.dv.tbalib.messagequeue.MqConstants" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>TBA Login</title>
    <jsp:include page="env.jsp"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<form>
    <fieldset>
        <legend>Read this QR Code with the Token-based authentication (tbaClient) app to log in</legend>

        <div id='qrcode'></div>

        <p style='font-size: 18px'><span id='timer'></span> <span id='sec'></span></p>
    </fieldset>
</form>

<script type="text/javascript">
    var timer = <%= MqConstants.LOGIN_TIMEOUT %> + 1;
    var timeCallbacks = [];

    function clearTimeCallbacks() {
        for (var i = 0; i < timeCallbacks.length; i++) {
            clearTimeout(timeCallbacks[i]);
        }
    }

    function eachSecond() {
        timer--;
        $('#timer').text(timer);
        var sec = (timer == 1) ? 'second left' : 'seconds left';
        $('#sec').text(sec);
    }

    function waitToLogin(nonce) {
        $.ajax({
            type: 'POST',
            url: 'tbaLoginSuccFail.jsp',
            data: {"nonce": nonce},
            success: function(ret) {
                if (ret.success) {
                    clearTimeCallbacks();
                    window.location.replace("index.jsp");
                }
                else {
                    $('#qrcode').hide();
                    $('#timer').text("ERROR!").css('color', 'red');
                    $('#sec').text(ret.message);
                }
            },
            error: function() {
                finish();
            }
        });
    }

    function finish() {
        clearTimeCallbacks();
        $('#qrcode').hide();
        $('#timer').text("TIME OUT!").css('color', 'red');
        $('#sec').text("Fail to log in!");
    }

    $(function() {
        $('#timer').text("Loading...");
        $.ajax({
            type: "GET",
            url: "tbaGetNewNonce.jsp",
            success: function(ret) {
                var imgCode = "<img src='qrencode?mode=signin&n=" + ret.nonce + "' alt='QR Code for logging in' />";
                $("#qrcode").append(imgCode);
                for (var i = 1; i < timer; i++) {
                    timeCallbacks[timeCallbacks.length] = setTimeout(function() {
                        eachSecond()
                    }, i * 1000);
                }
                timeCallbacks[timeCallbacks.length] = setTimeout(function() {
                    finish()
                }, timer * 1000);
                waitToLogin(ret.nonce);
            },
            error: function() {
                $("#timer").text("Fail to connect to the authentication server.").css('color', 'red');
            }
        });
    });
</script>
</body>
</html>
