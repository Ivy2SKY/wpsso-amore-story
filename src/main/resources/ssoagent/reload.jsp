<%@ page import="nets.sso.agent.web.v9.core.SSOConf" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String prev = SSOConf.getVersion();
    SSOConf.reLoad();
    String post = SSOConf.getVersion();
%>
prev:<%=prev%>
<hr>
post:<%=post%>

