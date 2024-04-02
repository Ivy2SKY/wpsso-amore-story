<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%=SSOAuthn.get(request, response).getESSOScript()%>
