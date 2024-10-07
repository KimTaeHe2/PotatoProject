<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/admin_header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>관리자게시판 - 상세보기</title>
    <link rel="stylesheet" href="/resources/css/notiview.css">
</head>
<body>
      
        <div class="container">
            <h1>관리자 공지</h1> <a href="../admin/notiWrite?member_number=${sessionScope.member_number}">우수회원</a>
            <h1>관리자 공지</h1> <a href="../admin/notiWrite?member_number=${sessionScope.member_number}">일반회원</a>
            <h1>관리자 공지</h1> <a href="../admin/notiWrite?member_number=${sessionScope.member_number}">신고회원</a>
            <h1>관리자 공지</h1> <a href="../admin/notiWrite?member_number=${sessionScope.member_number}">블랙리스트 회원</a>
        <table class="member-table">
        
            <thead>
            
                <tr>
                    <th>ID</th>
                    <th>회원가입일</th>
                    <th>최근로그인</th>
                </tr>
            </thead>
            <tbody>
                <%-- <c:forEach var="memberVO" items="${notice}" varStatus="status">
                        <tr>
                            <td>
                               <a href="../admin/notice?notice_number=${memberVO.notice_number}">
                                    <c:out value="${memberVO.title}"/>
                                </a>
                            </td>
                            <td><c:out value="${memberVO.writer}"/></td>
                            <td><fmt:formatDate value="${memberVO.regidate}" pattern="yyyy년 MM월 dd일 (E) HH:mm:ss" /></td>
                        </tr>
                </c:forEach> --%>
            </tbody>
        </table>     
   </div>
</body>
</html>