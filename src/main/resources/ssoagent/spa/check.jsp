<%@ page import="nets.sso.agent.web.v9.SSOAuthn"%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%SSOAuthn.authn(request, response);%>
<%=SSOAuthn.get(request, response).getUserJson()%>
