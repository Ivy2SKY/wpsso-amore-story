<%@ page import="nets.sso.agent.web.common.util.WebUtil" %>
<%@ page import="java.util.Enumeration" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<body>
<%
    Enumeration<String> eHeader = request.getHeaderNames();
    while (eHeader.hasMoreElements())
    {
        String hName = (String) eHeader.nextElement();
        String hValue = request.getHeader(hName);
%>   <%=WebUtil.stripTag(hName + ":" + hValue)%><br/>
<% } %>
<br/>
requeset.getServerName():<%=WebUtil.stripTag(request.getServerName())%><br/>
requeset.getRemoteAddr():<%=WebUtil.stripTag(request.getRemoteAddr())%><br/>
</body>
</html>
