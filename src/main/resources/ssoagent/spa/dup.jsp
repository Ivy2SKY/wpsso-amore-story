<%@ page import="nets.sso.agent.web.common.exception.SSOException" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
try {
    response.getWriter().println(SSOAuthn.get(request, response).getDup().toJson());
}
catch (SSOException e) {
    response.getWriter().println(e.toJson());
}
%>
