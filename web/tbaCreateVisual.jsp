<%@ page import="kr.ac.ajou.dv.tbalib.messagequeue.MqConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>ID/Password Login Result Page</title>
    <jsp:include page="env.jsp"/>
</head>

<body>
<jsp:include page="header.jsp"/>
<form>
    <fieldset>
        <legend>Read this QR Code with the Token-based authentication (tbaClient) app</legend>
        <p style='font-size: 24px'>Selected nickname: <span
                style='color: blue'><%= request.getParameter("nickname") %></span>
        </p>

        <div id='qrcode'></div>

        <p style='font-size: 18px'><span id='timer'></span> <span id='sec'></span></p>
    </fieldset>
</form>

<script type="text/javascript">
    var wantedNickname = "<%= request.getParameter("nickname") %>";
    var timer = <%= MqConstants.CREATE_TIMEOUT %> +1;
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

    function finish(n) {
        clearTimeCallbacks();
        $('#qrcode').hide();
        if (n < 0) {
            $('#timer').text("ERROR!").css('color', 'red');
        } else {
            $('#timer').text("TIME OUT!").css('color', 'red');
        }
        $('#sec').text("Sorry. Fail to create a new account.");
    }

    function waitToRegister(nonce) {
        $.ajax({
            type:'POST',
            url:'tbaCreateSuccFail.jsp',
            data:{"nonce":nonce, "nickname":wantedNickname},
            success:function (ret) {
                if (ret.success) {
                    clearTimeCallbacks();
                    window.location.replace("tbaCreateAck.jsp?nonce=" + nonce + "&nickname=" + wantedNickname);
                } else {
                    finish(-1);
                }
            },
            error:function () {
                finish(-1);
            }
        });
    }

    $(function () {
        clearTimeCallbacks();
        $('#timer').text("Loading...");
        $.ajax({
            type:"GET",
            url:"tbaGetNewNonce.jsp",
            success:function (ret) {
                var imgCode = "<img src='qrencode?mode=signup&n=" + ret.nonce + "' alt='QR Code for creating a new account' />";
                $('#qrcode').append(imgCode);
                for (var i = 1; i < timer; i++) {
                    timeCallbacks[timeCallbacks.length] = setTimeout(function () {
                        eachSecond()
                    }, i * 1000);
                }
                timeCallbacks[timeCallbacks.length] = setTimeout(function () {
                    finish(0)
                }, timer * 1000);
                waitToRegister(ret.nonce);
            },
            error:function () {
                $("#timer").text("Fail to connect to the authentication server.").css('color', 'red');
                finish(-1);
            }
        });
    });
</script>

</body>
</html>
