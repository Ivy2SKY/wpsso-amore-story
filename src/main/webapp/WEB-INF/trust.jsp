<%@ page import="nets.sso.agent.web.common.util.StrUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String audienceID = "sso.other.com";
    // audienceID: 연계할 다른 SSO 시스템의 식별자(식별자에 제한은 없으나, 주로 FQDN을 사용)
    String trustURL = "https://sso.nets.co.kr:9443/sso/trust/sendsso.do";
    // trustURL: TRUST 정보를 얻어올 현재 SSO 서버의 URL 정보를 입력합니다.
    String returnURL = "https://sso.nets.co.kr:7443/webapp/default.jsp";
    // returnURL: 다른 SSO 인증 후, 이동할 URL

    // 해당 변수 값이 정의되어 있지 않은 경우, 전달된 파라미터에서 값을 조회
    if (StrUtil.isNullOrEmpty(audienceID)) audienceID = request.getParameter("audienceID");
    if (StrUtil.isNullOrEmpty(audienceID)) throw new Exception("'audienceID' not set.");
    if (StrUtil.isNullOrEmpty(trustURL)) trustURL = request.getParameter("trustURL");
    if (StrUtil.isNullOrEmpty(trustURL)) throw new Exception("'trustURL' not set.");
    if (StrUtil.isNullOrEmpty(returnURL)) returnURL = request.getParameter("returnURL");
    if (StrUtil.isNullOrEmpty(returnURL)) throw new Exception("'returnURL' not set.");
%>
<!DOCTYPE html>
<html>
<head>
    <title>NETS*SSO TRUST</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript" src="./ssoagent/js/spa/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        // TRUST 연계 함수
        function sendSSO(isBlank) {
            // AJAX 연계
            $.ajax({
                type: "POST"
                , url: '<%=trustURL%>'
                , data: {
                    AudienceID: '<%=audienceID%>'
                    , returnURL: '<%=returnURL%>'
                }
                , headers: {'X-Requested-With': 'XMLHttpRequest'}
                , dataType: 'json'
                , timeout: 5000
                , xhrFields: {withCredentials: true}
            }).done(function (data) {
                if (data.errorCode != 0) {
                    // 서버 오류 응답
                    alert(data.errorMessage);
                } else {
                    // 서버 정상 응답
                    if (isBlank) {
                        // 새창으로 연계 시
                        var url = data.trust.Url
                            + "?TrustID=" + data.trust.TrustID
                            + "&AudienceID=" + data.trust.AudienceID
                            + "&TrustResponse=" + data.trust.TrustResponse
                            + "&Signature=" + data.trust.Signature;
                        window.open(url); // 새창
                    } else {
                        // 페이지 이동 시, Form 태그 이용
                        $('#TrustID').val(data.trust.TrustID);
                        $('#AudienceID').val(data.trust.AudienceID);
                        $('#TrustResponse').val(data.trust.TrustResponse);
                        $('#Signature').val(data.trust.Signature);
                        var frm = $('#form');
                        frm.attr('action', data.trust.Url);
                        frm.submit();
                    }
                }
            }).fail(function (jqXhr, textStatus, err) {
                // AJAX 호출 실패
                alert(textStatus + err)
            });
        }
    </script>
</head>
<body>
<!-- 페이지 이동 시킬 Form 태그 -->
<form id="form" method="post">
    <input type="hidden" id="TrustID" name="TrustID"/>
    <input type="hidden" id="AudienceID" name="AudienceID"/>
    <input type="hidden" id="TrustResponse" name="TrustResponse"/>
    <input type="hidden" id="Signature" name="Signature"/>
</form>
<!-- 인증 연계 버튼 -->
<input type="button" value="<%=audienceID%> 이동" onclick="sendSSO(false)">
<input type="button" value="<%=audienceID%> 새창" onclick="sendSSO(true)"/>
<hr/>
<a href="default.jsp">back</a>
</body>
</html>