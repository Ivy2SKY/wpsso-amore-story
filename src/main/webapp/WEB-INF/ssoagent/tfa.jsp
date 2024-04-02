<%@ page import="nets.sso.agent.web.common.constant.SSOConst" %>
<%@ page import="nets.sso.agent.web.common.util.WebUtil" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSOMfa" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    SSOMfa mfa = SSOAuthn.get(request, response).getMfa();
    if (mfa == null)
        return;
%>
<%-- MFA receive success --%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>NETS*SSO TFA</title>
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
            if (document.getElementById("txtCode").value == "") {
                alert("보안 코드를 입력해주세요.");
                return;
            }
            document.forms["form1"].target = "_top";
            document.forms["form1"].submit();
        }

        function OnInit() {
            document.getElementById("txtCode").focus();
            var minutes = 60 * <%=mfa.getMfaTimeoutMin()%>;
            var display = document.querySelector('#time');
            startTimer(minutes, display);
        }
    </script>
</head>
<body onLoad="OnInit();">
<form id="form1" method="post" action="<%=mfa.getLoginFullUrl()%>">
    <input type="hidden" name="<%=SSOConst.USER_ID%>" value="<%=WebUtil.stripTag(mfa.getMfaUserID())%>"/>
    <input type="hidden" name="<%=SSOConst.MFA_ID%>" value="<%=WebUtil.stripTag(mfa.getMfaID())%>"/>
    <input type="hidden" name="<%=SSOConst.RETURN_URL%>" value="<%=WebUtil.stripTag(mfa.getReturnURL())%>"/>
    <input type="hidden" name="<%=SSOConst.DEVICE%>" value="<%=WebUtil.stripTag(mfa.getMfaDevice())%>"/>
    <input type="hidden" name="<%=SSOConst.CRED_TYPE%>" value="NTFA"/>
    <table>
        <tr>
            <td colspan="2">Two factor authentication</td>
        </tr>
        <tr>
            <td>User ID :</td>
            <td><%=WebUtil.stripTag(mfa.getMfaUserID())%>
            </td>
        </tr>
        <tr>
            <td>Secret Code :</td>
            <td><input type="text" id="txtCode" name="<%=SSOConst.CODE%>"/> left: <span id="time"></span></td>
        </tr>
        <tr>
            <td colspan="2"><input type="button" value="Logon" onclick="OnLogon();"/></td>
        </tr>
    </table>
</form>
</body>
</html>