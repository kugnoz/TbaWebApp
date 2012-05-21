<%@ page import="kr.ac.ajou.dv.tbalib.messagequeue.MqConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Creating a new account for token-based authentication</title>
    <jsp:include page="env.jsp"/>
</head>

<body>
<jsp:include page="header.jsp"/>

<h2 class="info">
    Your request has been arrived and we are about to register your account.
</h2>

<h2 class="info good">
    Your nickname was <%= request.getParameter("nickname") %>
</h2>

<h3 class="info">
    <span id="waitingSign">Waiting for your final acknowledgement...</span>
    <br/>
    <span id='timer'>Loading...</span> <span id='sec'></span>
</h3>

<script type="text/javascript">
    var nonce = "<%= request.getParameter("nonce") %>";
    var timer = <%= MqConstants.CREATE_ACK_TIMEOUT %> +1;
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
        $('#waitingSign').hide();
        if (n < 0) {
            $('#timer').text("Your authentication token did not give us the final acknowledgement!").css('color', 'red');
            $('#sec').text("Sorry. Fail to create a new account.");
        } else {
            $('#timer').text("TIME OUT!").css('color', 'red');
            $('#sec').text("Sorry. Fail to create a new account.");
        }
    }

    $(function () {
        clearTimeCallbacks();
        for (var i = 1; i < timer; i++) {
            timeCallbacks[timeCallbacks.length] = setTimeout(function () {
                eachSecond()
            }, i * 1000);
        }
        timeCallbacks[timeCallbacks.length] = setTimeout(function () {
            finish(0)
        }, timer * 1000);

        $.ajax({
            type:'POST',
            url:'tbaCreateAckWaiting.jsp',
            data:{"nonce":nonce},
            success:function (ret) {
                if (ret.success) {
                    clearTimeCallbacks();
                    window.location.replace("tbaCreateResult.jsp?nickname=" + "<%= request.getParameter("nickname") %>");
                }
                else {
                    finish(-1);
                }
            },
            error:function () {
                finish(-1);
            }
        });
    });
</script>

</body>
</html>
