<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/admin_header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>회원관리</title>
    <link rel="stylesheet" href="/resources/css/notiview.css">
</head>
<body>
        <div class="container">
            <h1>회원관리</h1>
            <a href="../admin/managementList">전체보기&nbsp;</a>
            <a href="../admin/managementList">일반회원&nbsp;</a>
            <a href="../admin/managementList">우수회원&nbsp;</a>
            <a href="../admin/managementList">경고회원&nbsp;</a>
            <a href="../admin/managementList">블랙리스트</a>
        <table class="member-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>닉네임</th>
                    <th>가입일</th>
                    <th>회원등급</th>
                    <th>비고</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="memberVO" items="${notice}" varStatus="status">
                    <c:if test="${memberVO.important == 1}">
                        <tr>
                            <td><span class="important">[중요]</span></td>
                            <td>
                                <a href="../admin/notice?notice_number=${memberVO.notice_number}">
                                    <c:out value="${memberVO.title}"/>
                                </a>
                            </td>
                            <td><c:out value="${memberVO.writer}"/></td>
                            <td><fmt:formatDate value="${memberVO.regidate}" pattern="yyyy년 MM월 dd일 (E) HH:mm:ss" /></td>
                        </tr>
                    </c:if>
                </c:forEach>
            </tbody>
        </table>     
   </div>
</body>
</html>