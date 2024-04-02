<%@ page import="nets.sso.agent.web.common.exception.SSOException" %>
<%@ page import="nets.sso.agent.web.common.util.StrUtil" %>
<%@ page import="nets.sso.agent.web.common.util.WebUtil" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSOReqeuestArtifact" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    String val = "";
    String format = "{ \"status\":\"%s\", \"code\":\"%s\", \"uriScheme\":\"%s\", \"essoUrl\":\"%s\" }";

    try {
        SSOReqeuestArtifact req = SSOAuthn.get(request, response).requestArtifact();
        if ("03".equals(req.getTargetType()))
        {
            //Application 형식
            val = String.format(format, "true", req.getArtifactID(), req.getUriScheme(), req.getESSOUrl() );
        }
        else
        {
            //Web 형식
            val = String.format(format, "true", req.getArtifactID(), StrUtil.EMPTY_STRING, req.getESSOUrl() );
        }
    } catch (SSOException e) {
        val = String.format(format, "false", e.getExceptionCode().getValue(), StrUtil.EMPTY_STRING, StrUtil.EMPTY_STRING );
    }
%><%=WebUtil.stripTag(val)%>