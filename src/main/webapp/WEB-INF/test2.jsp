<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
 response.setHeader("Cache-Control", "no-store");
 response.setHeader("Pragma", "no-cache");
 response.setDateHeader("Expires", 0);
 if (request.getProtocol().equals("HTTP/1.1"))
 response.setHeader("Cache-Control", "no-cache");
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/
html4/loose.dtd">
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <title>NSSO</title>
</head>
<body>
userID: <c:out value="${ssoUser.userID}"></c:out>
<hr/>
attrs: <br/>
<c:out value="${ssoUser.userID}"></c:out>
<c:forEach var="i" items="${ssoUser.attrs}">
 ${i.key}=${i.value}
 <br/>
</c:forEach>
<hr/>
<a href='<c:out value="${ssoUrl.logoutFullUrl}"/>'>Logout</a>
</body>
</html>