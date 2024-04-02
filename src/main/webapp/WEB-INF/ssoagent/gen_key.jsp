<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%=SSOAuthn.get(request, response).getPublicKey()%>