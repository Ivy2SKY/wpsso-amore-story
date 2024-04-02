<%@ page import="nets.sso.agent.web.common.constant.SSOConst" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSOStatus" %>
<%@ page import="nets.sso.agent.web.v9.SSOUrl" %>
<%@ page import="nets.sso.agent.web.v9.core.AuthnStatus" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    SSOAuthn authn = SSOAuthn.get(request, response);
    SSOStatus status = authn.authnLogin();
    SSOUrl url = authn.getUrl();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
    <title>NETS*SSO</title>
    <script type="text/javascript">
        //로그온
        function OnLogon() {
            if (document.getElementById("txtUserID").value === "") {
                alert("사용자 ID를 입력하세요");
                return;
            }
            if (document.getElementById("txtPwd").value === "") {
                alert("사용자의 로그온 비밀번호를 입력하세요");
                return;
            }
            if (document.getElementById("txtCode").value === "") {
                alert("보안코드를 입력해주세요.")
                return;
            }
            document.forms["form1"].submit();
        }

        function OnInit() {
            document.getElementById("txtCode").addEventListener("keyup", (e) => {
                if (e.key == "Enter") {
                    OnLogon();
                }
            });
            document.forms["form1"].txtUserID.focus();
        }
    </script>
</head>
<body onLoad="OnInit();">
<form id="form1" method="post" action="<%=url.getLoginFullUrl()%>">
    <input type="hidden" name="<%=SSOConst.CRED_TYPE%>" value="NTFA"/>
    <table>
        <tr>
            <td>사용자 ID :</td>
            <td><input type="text" id="txtUserID" name="<%=SSOConst.USER_ID%>"/></td>
        </tr>
        <tr>
            <td>비밀번호 :</td>
            <td><input type="password" id="txtPwd" name="<%=SSOConst.USER_PW%>"/></td>
        </tr>
        <tr>
            <td>보안코드 :</td>
            <td><input type="text" id="txtCode" name="<%=SSOConst.CODE%>"/></td>
        </tr>
        <tr>
            <td colspan="2" align="center"><input type="button" value="로그온" onclick="OnLogon();"/></td>
        </tr>
    </table>
</form>
<hr/>
인증 상태:<%=status.getStatus().name()%>(<%=status.getStatus().getValue()%>)
<hr/>
에러 코드:<%=status.getCode()%>
<hr/>
에러 메시지:<%=status.getMessage("ko")%>
<hr/>
<a href="login_enc.jsp">암호화 로그온</a>
</body>
</html>
