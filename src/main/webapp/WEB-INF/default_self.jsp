<%@ page import="nets.sso.agent.web.common.util.StrUtil" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSOUser" %>
<%@ page import="nets.sso.agent.web.v9.SSOStatus" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userID = "";
    String userAttr = "";
    String logoutUrl = "";
    int errorCode = 0;
    String errorMsg = "";

    SSOUser user = SSOAuthn.authn(request, response);
    if (user != null)
    {
        userID = user.getUserID();
        userAttr = StrUtil.join(user.getAttrs(), "<br>", "=");
        logoutUrl = SSOAuthn.getUrl(request, response).getLogoutFullUrl();
    }
    else
    {
        if (request.getAttribute("NSSO-MOVE-URL") != null)
            return;
        SSOAuthn ssoAuthn = SSOAuthn.get(request, response);
        SSOStatus status = ssoAuthn.getLastStatus();
        errorCode = status.getCode();
        errorMsg = status.getMessage();
        logoutUrl = ssoAuthn.getUrl().getLogoutFullUrl();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>NETS*SSO</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
</head>
<body>
사용자 명: <%= userID %>
<hr/>
사용자 속성<br/>
<%= userAttr %>
<hr/>
오류 코드: <%= errorCode %>
<hr/>
오류 내용: <%= errorMsg %>
<hr/>
<a href="<%=logoutUrl%>">Logout</a>
<hr/>
</body>
</html>