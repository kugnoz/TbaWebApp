<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create a new account for token-based authentication</title>
    <jsp:include page="env.jsp"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<form method="post"
      action="tbaCreateVisual.jsp">
    <fieldset>
        <legend>
            Create a new account
        </legend>
        <ul>
            <li>
                <label for='nicknameForm'>Choose Your Nickname:</label>
                <input id="nicknameForm" type="text" name="nickname" autofocus required/>

                <p id="availableNickname"></p>
            </li>
        </ul>
    </fieldset>
    <fieldset>
        <button id="submitButton" type="submit">Proceed</button>
    </fieldset>
</form>

<script type="text/javascript">
    var strPleaseType = 'Please type a nickname you want.';

    function nicknameCheck() {
        var nickNameOk = $("#nicknameForm").hasClass("ok");

        if (nickNameOk) {
            $("#submitButton").removeAttr("disabled");
        }
        else {
            $("#submitButton").attr("disabled", true);
        }
    }

    $(function () {
        $('#availableNickname').text(strPleaseType).css('color', 'orange');
        nicknameCheck();
    });


    $('#nicknameForm').keyup(function () {
        var nickname = $('#nicknameForm').val();

        if (nickname == '') {
            $('#nicknameForm').removeClass('ok');
            $('#availableNickname').text(strPleaseType).css('color', 'orange');
            nicknameCheck();
        }
        else {
            $.ajax({
                type:"POST",
                url:"tbaNicknameCheck.jsp",
                data:{wantedname:nickname},
                datatype:"json",
                success:function (ret) {
                    if (ret.available) {
                        $("#nicknameForm").addClass("ok");
                        $("#availableNickname").text("Available.").css('color', 'green');
                    }
                    else {
                        $("#nicknameForm").removeClass("ok");
                        $("#availableNickname").text("Already exist!").css('color', 'red');
                    }
                    nicknameCheck();
                },
                error:function () {
                    $("#nicknameForm").removeClass("ok");
                    $("#availableNickname").text("Sorry. Fail to check ID. Please re-type your ID.").css('color', 'blue');
                    nicknameCheck();
                }
            });
        }
    });
</script>

</body>
</html>