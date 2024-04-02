<%@ page import="nets.sso.agent.web.common.constant.SSOConst" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSODup" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SSODup dup = SSOAuthn.get(request, response).getDup();
%>
<!DOCTYPE html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>NETS*SSO Duplication</title>
    <script type="text/javascript">
        function startTimer(duration, display) {
            if (0 == duration) {
                display.textContent = "limitless";
            } else {
                var timer = duration, minutes, seconds;
                setInterval(function () {
                    minutes = parseInt(timer / 60, 10);
                    seconds = parseInt(timer % 60, 10);
                    minutes = minutes < 10 ? "0" + minutes : minutes;
                    seconds = seconds < 10 ? "0" + seconds : seconds;
                    display.textContent = minutes + ":" + seconds;
                    if (--timer < 0) {
                        timer = duration;
                    }
                }, 1000);
            }
        }

        function OnLogon() {
            document.forms["form1"].target = "_top";
            document.forms["form1"].submit();
        }

        function OnCancel() {
            document.forms["form1"].target = "_top";
            document.forms["form1"].action = "<%=dup.getDupReturnURL()%>";
            document.forms["form1"].submit();
        }

        function OnInit() {
            var minutes = 60 * <%=dup.getDupTimeoutMin()%>;
            var display = document.querySelector('#time');
            startTimer(minutes, display);
        }
    </script>
</head>
<body onLoad="OnInit();">
<form id="form1" method="post" action="<%=dup.getLoginUrl()%>">
    <input type="hidden" name="<%=SSOConst.CRED_TYPE%>" value="DUPCHOICE"/>
    <input type="hidden" name="credential" value="<%=dup.getDupCredential()%>"/>
    <input type="hidden" name="<%=SSOConst.RETURN_URL%>" value="<%=dup.getDupReturnURL()%>"/>
    <input type="hidden" name="<%=SSOConst.SITE_ID%>" value="<%=dup.getAppID()%>"/>
    <table>
        <tr>
            <td colspan="2">Duplication</td>
        </tr>
        <tr>
            <td>ID:</td>
            <td><%=dup.getDupUserID()%>
            </td>
        </tr>
        <tr>
            <td>IP:</td>
            <td><%=dup.getDupIP()%>
            </td>
        </tr>
        <tr>
            <td>Time:</td>
            <td><%=dup.getDupTime()%>
            </td>
        </tr>
        <tr>
            <td>Select Choice</td>
            <td>
                <input type="button" value="Yes, let me logon" onclick="OnLogon()">
                <input type="button" value="No, Let him logon" onclick="OnCancel()">
                left: <span id="time"></span>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
