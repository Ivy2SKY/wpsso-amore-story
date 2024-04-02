<%@ page import="nets.sso.agent.web.common.exception.SSOException" %>
<%@ page import="nets.sso.agent.web.common.util.StrUtil" %>
<%@ page import="nets.sso.agent.web.common.util.WebUtil" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSOResponseArtifact" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    String val = null;
    try {
        SSOResponseArtifact res = SSOAuthn.get(request, response).responseArtifact();
        //Application 형식
        val = String.format("{ \"status\":\"%s\", \"userID\":\"%s\", \"artifactBody\":\"%s\", \"artifactParam\":\"%s\" }",
                "true",
                res.getUserID(),
                res.getBody(),
                res.getParam()
        );
    } catch (SSOException e) {
        val = String.format("{ \"status\":\"%s\", \"errorCode\":\"%s\", \"errorMessage\":\"%s\" }",
                "false",
                e.getExceptionCode().getValue(),
                e.getMessage()
        );
    }
%><%=WebUtil.stripTag(val)%>