<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Login (ID/Password method)</title>
    <jsp:include page="env.jsp"/>
</head>
<body>
<jsp:include page="header.jsp">
    <jsp:param name="login" value="true"/>
</jsp:include>

<form>
    <fieldset>
        <legend>Log-in</legend>
        <ul>
            <li>
                <label>ID:</label>
                <input id="idpwId" type="text" name="userId" autocomplete="on" autofocus required/>
            </li>
            <li>
                <label>Password:</label>
                <input id="idpwPw" type="password" name="pw" required/>
            </li>
        </ul>
    </fieldset>
    <fieldset>
        <button type="submit" formmethod="post" formaction="idPasswordLoginCheck.jsp">Login</button>
    </fieldset>
</form>
</body>
</html>