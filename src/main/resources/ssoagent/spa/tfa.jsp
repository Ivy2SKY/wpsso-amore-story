<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSOMfa" %><%@ page import="nets.sso.agent.web.v9.SSOStatus"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
StringBuilder sb = new StringBuilder();
SSOAuthn ssoAuthn = SSOAuthn.get(request, response);
SSOMfa mfa = ssoAuthn.getMfa();
if (mfa!=null)
{
    sb.append("{")
        .append("\"result\": true,")
        .append("\"errorCode\": 0,")
        .append("\"tfaID\": \"").append(mfa.getMfaID()).append("\",")
        .append("\"targetYN\": true,")
        .append("\"device\": \"").append(mfa.getMfaDevice()).append("\",")
        .append("\"code\": \"\",")
        .append("\"method\": \"").append(mfa.getMfaMethod()).append("\",")
        .append("\"timeoutMinutes\": ").append(mfa.getMfaTimeoutMin())
        .append("}");
} else {
    SSOStatus status =   ssoAuthn.getLastStatus();
    sb.append("{")
        .append("\"result\": false,")
        .append("\"errorCode\": ").append(status.getCode()).append(",")
        .append("\"errorMessage\": \"").append(status.getMessage()).append("\",")
        .append("}");
}
%><%=sb.toString()%>