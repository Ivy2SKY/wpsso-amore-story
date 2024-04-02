<%@ page import="nets.sso.agent.web.common.constant.SSOConst" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSOUrl" %>
<%@ page import="nets.sso.agent.web.v9.SSOUser" %>
<%@ page import="nets.sso.agent.web.v9.core.AuthnStatus" %>
<%@ page import="nets.sso.agent.web.v9.SSOStatus" %>
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
    <script type="text/javascript" src="ssoagent/js/ajax.js"></script>
    <script type="text/javascript" src="ssoagent/js/rsa/rsa.js"></script>
    <script type="text/javascript" src="ssoagent/js/rsa/jsbn.js"></script>
    <script type="text/javascript" src="ssoagent/js/rsa/prng4.js"></script>
    <script type="text/javascript" src="ssoagent/js/rsa/rng.js"></script>
    <%--    <script type="text/javascript" src="ssoagent/js/json2.js"></script> <!--IE 호환성 보기를 사용하여, JSON오류가 발생할때만, 사용하세요.-->--%>
    <script type="text/javascript">
        function encryptCredential() {
            var response = getKeyJson();
            var keyBox = JSON.parse(response);
            document.forms["form1"].keyID.value = keyBox.id;

            var rsa = new RSAKey();
            rsa.setPublic(keyBox.modulus, keyBox.exponent);

            var txtUserID = document.getElementById("txtUserID");
            var txtPwd = document.getElementById("txtPwd");
            document.getElementById("userID").value = rsa.encrypt(txtUserID.value);
            document.getElementById("userPW").value = rsa.encrypt(txtPwd.value);
            txtUserID.value = "";
            txtPwd.value = "";
        }

        function encrypt(rsa, obj) {
            obj.value = aesUtil.encrypt(keyBox.salt, keyBox.iv, decKey, obj.value);
        }

        function getKeyJson() {
            var value = "op=PK&ssoRequest=" + new Date().getTime();
            var req = new Ajax("ssoagent/gen_key.jsp", value, "", "POST");
            req.async = false;
            req.tmpData = value;
            var message = req.send();
            return message;
        }

        //로그온
        function OnLogon() {
            if (document.forms["form1"].txtUserID.value === "") {
                alert("사용자 ID를 입력하세요");
                return;
            }
            if (document.forms["form1"].txtPwd.value === "") {
                alert("사용자의 로그온 비밀번호를 입력하세요");
                return;
            }
            try {
                encryptCredential();
                document.forms["form1"].submit();
            } catch (e) {
                alert(e);
            }
        }

        function OnInit() {
            document.getElementById("txtPwd").addEventListener("keyup", (e) => {
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
    <input type="hidden" id="userID" name="<%=SSOConst.USER_ID%>" value=""/>
    <input type="hidden" id="userPW" name="<%=SSOConst.USER_PW%>" value=""/>
    <input type="hidden" id="keyID" name="<%=SSOConst.KEY_ID%>" value=""/>
    <input type="hidden" id="credType" name="<%=SSOConst.CRED_TYPE%>" value="ENCRYPTEDBASIC"/>
    <table>
        <tr>
            <td>사용자 ID :</td>
            <td><input type="text" id="txtUserID"/></td>
        </tr>
        <tr>
            <td>비밀번호 :</td>
            <td><input type="password" id="txtPwd"/></td>
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
<a href="login.jsp">일반 로그온</a>
</body>
</html>
