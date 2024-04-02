<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page import="nets.sso.agent.web.v9.SSOUrl" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% SSOAuthn authn = SSOAuthn.get(request, response);
    SSOUrl url = authn.getUrl();
    String result = authn.getAppCode();
%>
<!DOCTYPE html>
<html>
<head>
    <title>NETS*SSO</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript" src="./ssoagent/js/spa/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        function runAPP() {
            var appCode = document.getElementById("appCode").value;
            var appParam = document.getElementById("appParam").value;
            if (appCode === "")
                return;

            requestArtifact(appCode, appParam, execAPP);
        }

        function execAPP(json) {
            if (json.status == "false") {
                alert('인증 연계에 실패 했습니다.(' + json.code + ')');
                return;
            }
            if (json.uriScheme != "") {
                location.href = decodeURIComponent(json.uriScheme) + json.code;
            } else {
                var appCode = document.getElementById("appCode").value;
                var url = "<%=url.getLoginUrl()%>?artifactID=" + json.code + "&targetID=" + appCode;
                document.getElementById("weblink").setAttribute("href", url);

                resolveInit("", "");
            }
        }

        function runWEB() {
            var webCode = document.getElementById("webCode").value;
            var webParam = document.getElementById("webParam").value;
            if (webCode === "")
                return;

            requestArtifact(webCode, webParam, execWEB);
        }

        function execWEB(json) {
            if (json.status == "false") {
                alert('인증 연계에 실패 했습니다.(' + json.code + ')');
                return;
            }

            var webCode = document.getElementById("webCode").value;
            var url = "<%=url.getLoginUrl()%>?artifactID=" + json.code + "&targetID=" + webCode;
            document.getElementById("weblink").setAttribute("href", url);

            resolveInit(json.code, webCode);
        }

        function requestArtifact(appCode, appParam, callbackF) {
            var postData =
                "op=AR" +
                "&targetID=" + appCode +
                "&artifactParam=" + appParam +
                "&time=" + new Date().getTime();
            $.ajax({
                url: "./ssoagent/artifact_req.jsp",
                type: 'POST',
                async: true,
                data: postData,
                dataType: "json",
                timeout: 10000,
                contentType: "application/x-www-form-urlencoded",
                success: function (json) {
                    callbackF(json);
                },
                error: function (request, status, error) {
                },
                fail: function () {
                    alert("인터넷 연결 상태를 확인해주세요.");
                }
            });
        }

        function resolveInit(artifactCode, targetCode) {
            document.getElementById("artifactCode").value = artifactCode;
            document.getElementById("targetCode").value = targetCode;
        }

        function resolve() {
            var artifactCode = document.getElementById("artifactCode").value;
            var targetCode = document.getElementById("targetCode").value;
            if (artifactCode === "" || targetCode === "")
                return;

            resolveArtifact(artifactCode, targetCode, resolveTxt)
        }

        function resolveArtifact(code, target, callbackF) {
            var postData =
                "op=AS" +
                "&artifactID=" + code +
                "&targetID=" + target +
                "&time=" + new Date().getTime();
            $.ajax({
                url: "./ssoagent/artifact_res.jsp",
                type: 'POST',
                async: true,
                data: postData,
                dataType: "json",
                timeout: 10000,
                contentType: "application/x-www-form-urlencoded",
                success: function (json) {
                    callbackF(json);
                },
                error: function (request, status, error) {
                },
                fail: function () {
                    alert("인터넷 연결 상태를 확인해주세요.");
                }
            });
        }

        function resolveTxt(json) {
            $("#resolve-data").text(JSON.stringify(json));
        }
    </script>
</head>
<body>
<hr>
[APP 실행]<br>
app-code: <input id="appCode" type="text" value=""><br>
app-param: <input id="appParam" type="text" value=""><br>
<input type="button" onclick="runAPP();" value="App 실행"><br>
<hr>
[WEB 실행]<br>
web-code: <input id="webCode" type="text" value="<%=result%>"><br>
web-param: <input id="webParam" type="text" value="http://sso.nets.co.kr:9090/login/"><br>
<input type="button" onclick="runWEB();" value="Web 실행"><br>
<a id="weblink" href="">link</a>
<hr>
artifact-code: <input id="artifactCode" type="text"><br>
target-code: <input id="targetCode" type="text"><br>
<input type="button" onclick="resolve();" value="Artifact 조회"><br>
<p id="resolve-data"></p>
<hr>
<a href="default.jsp">기본 페이지</a>
</body>
</html>