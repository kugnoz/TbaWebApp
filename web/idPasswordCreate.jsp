<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Create a ID/Password pair</title>
    <jsp:include page="env.jsp"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<form>
    <fieldset>
        <legend>Create a new account (ID/PW)</legend>
        <ul>
            <li>
                <label for="idForm">ID:</label>
                <input id="idForm" type="text" name="userId" autofocus required/>

                <p id="availableId"></p>
            </li>
            <li>
                <label for='pwForm'>Password:</label>
                <input id="pwForm" type="password" name="pw" required/>
            </li>
            <li>
                <label for='pwformconfirm'>Password Confirm:</label>
                <input id="pwFormConfirm" type="password" name="pwConfirm" required/>

                <p id="pwMatch"></p>
            </li>
        </ul>
    </fieldset>
    <fieldset>
        <button id="submitButton" type="submit" formmethod="post" formaction="idPasswordCreateResult.jsp">Create</button>
    </fieldset>
</form>

<script type="text/javascript">
    function idPwCheck() {
        var idok = $("#idForm").hasClass("ok");
        var pwok = $("#pwForm").hasClass("ok");

        if (idok && pwok) {
            $("#submitButton").removeAttr("disabled");
        }
        else {
            $("#submitButton").attr("disabled", true);
        }
    }

    $(function() {
        $('#availableId').text('Type any ID you want.').css('color', 'orange');
        $('#pwMatch').text('Not Matched!').css('color', 'red');
        idPwCheck();
    });

    $('#idForm').keyup(function() {
        var userId = $('#idForm').val();

        if (userId == '') {
            $('#idForm').removeClass('ok');
            $('availableId').text('Type any ID you want.').css('color', 'orange');
            idPwCheck();
        }
        else {
            $.ajax({
                type: "POST",
                url: "idPasswordIdCheck.jsp",
                data: {"userId": userId},
                datatype: "json",
                success: function(ret) {
                    if (ret.available) {
                        $("#idForm").addClass("ok");
                        $("#availableId").text("Available.").css('color', 'green');
                    }
                    else {
                        $("#idForm").removeClass("ok");
                        $("#availableId").text("Already exist!").css('color', 'red');
                    }
                    idPwCheck();
                },
                error: function() {
                    $("#idForm").removeClass("ok");
                    $("#availableId").text("Sorry. Fail to check ID. Please re-type your ID.").css('color', 'blue');
                    idPwCheck();
                }
            });
        }
    });

    $('input[id^="pwForm"]').keyup(function() {
        var pw = $("#pwForm").val();
        var pwConfirm = $("#pwFormConfirm").val();

        if (pw != '' && pwConfirm != '' && pw == pwConfirm) {
            $("#pwForm").addClass("ok");
            $("#pwMatch").text("Matched.").css('color', 'green');
        }
        else {
            $("#pwForm").removeClass("ok");
            $("#pwMatch").text("Not Matched!").css('color', 'red');
        }
        idPwCheck();
    });
</script>

</body>
</html>