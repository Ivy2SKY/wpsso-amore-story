<%@ page import="java.util.Date" %>
<%@ page import="nets.sso.agent.web.v9.SSOAuthn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String time = String.valueOf(new Date().getTime());
    String essoUri = SSOAuthn.get(request, response).getUrl().getEssoUrl();
%>
<!DOCTYPE html>
<html>
<head>
    <title>NETS*SSO</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript">
        var supportESSO = false;
        var supportLive = false;
        var essoPath = "<%=essoUri%>";
    </script>
    <script type="text/javascript" src="./ssoagent/js/spa/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="<%=essoUri%>ESSOStatus?time=<%=time%>"></script>
    <script type="text/javascript">
        function runApp() {
            if (!supportESSO || !supportLive) {
                alert('ESSO가 실행 중인지 확인해주세요.');
                return;
            }

            var postValue = "op=EE";
            postValue += "&appid=" + document.getElementById("appid").value;
            postValue += "&param=" + document.getElementById("param").value;

            var requestValue = getRequestValue(postValue);

            document.getElementById("essorequest").value = $.trim(requestValue);
            document.getElementById("frmESSO").action = essoPath + "WEBTOAPP/RUNSVCAPP";
            document.getElementById("frmESSO").target = "ifrmESSO";
            document.forms['frmESSO'].submit();
        }

        function getRequestValue(postValue) {
            var url = "./ssoagent/esso.jsp";
            var returnData = null;
            $.ajax({
                url: url,
                type: 'GET',
                async: false,
                data: postValue,
                dataType: "text",
                timeout: 10000,
                contentType: "application/x-www-form-urlencoded",
                success: function (data) {
                    returnData = data;
                },
                error: function (request, status, error) {
                },
                fail: function () {
                    alert("인터넷 연결 상태를 확인해주세요.");
                }
            });
            return returnData;
        }

        function runBrowser() {
            if (!supportESSO || !supportLive) {
                alert('ESSO가 실행 중인지 확인해주세요.');
                return;
            }

            var browsertype = document.getElementById("browsertype").value;
            var url = document.getElementById("browserurl").value;
            if (url == "") {
                alert("url을 입력해 주세요.");
                return;
            }

            document.getElementById("returnurl").value = url;
            document.getElementById("frmESSOWeb").action = essoPath + "RUNBROWSER/" + browsertype;
            document.getElementById("frmESSOWeb").target = "ifrmESSO";
            document.forms["frmESSOWeb"].submit();
        }
    </script>
</head>
<body>
<form id="frmApp" name="frmApp">
    appid <input type="text" id="appid" name="appid" value="notepad"><br/>
    param <input type="text" id="param" name="param"><br/>
    <input type="button" value="C/S 실행" onclick="runApp()">
</form>
<hr/>
<form id="frmWeb" name="frmWeb">
    browser type
    <input type="text" id="browsertype" name="browsertype" value="Chrome"/><br/>
    url <input type="text" id="browserurl" name="browserurl" style="width:300px;"/><br/>
    <input type="button" value="Browser 실행" onclick="runBrowser()"/>
</form>
<form id="frmESSO" method="post">
    <input type="hidden" id="essorequest" name="essorequest"/>
</form>
<form id="frmESSOWeb" method="post">
    <input type="hidden" id="returnurl" name="returnurl"/>
</form>
<iframe style="display: none;" id="ifrmESSO" name="ifrmESSO" width="0" height="0"/>
</body>
</html>