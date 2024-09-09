<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- jstl 코어 태그용 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- jstl 포메팅 태그용 -->
<%@ include file="../common/header.jsp"%>

<!-- shop section -->

<section class="shop_section layout_padding">
	<div class="container">
		<div class="heading_container heading_center">
			<h2>🥔 인기매물</h2>
			<button id="regBtn" type="button" class="btn btn-outline-warning">내
				물건 등록</button>
		</div>
	</div>
	<div class="row">
		<c:forEach items="${ list }" var="boardlist">
			<div class="col-sm-6 col-md-4 col-lg-3">
				<div class="box">
					<a href="/shop/get?board_number=<c:out value="${boardlist.board_number}"/>">
						<div class="img-box">
							<img src="../resources/images/${boardlist.photo_name}" alt="">
						</div>
						<div class="detail-box">
							<h6>
								<c:out value="${ boardlist.title}" />
							</h6>
						</div>
						<div class="card_preice">
							가격<c:out value="${ boardlist.price}" />
						</div>
						<div class="card_adress">회원주소</div>
						<div class="card_status">
							<c:out value="${ boardlist.status}" />
						</div>
						<div class="card_count">
							<span>좋아요<c:out value="${ boardlist.likes}" /></span>
							<span>관심<c:out value="${ boardlist.interest}" /></span>
							<span>조회수 <c:out value="${ boardlist.views}" /></span>
						</div>
					</a>
				</div>
			</div>
		</c:forEach>
</section>

<%@ include file="../common/footer.jsp"%>
<script type="text/javascript">
	//상품등록 페이지 이동
	document.getElementById('regBtn').addEventListener('click', function() {
		window.location.href = '/shop/register';
	});

	document.addEventListener('DOMContentLoaded', function() {
		// 상품 리스트의 모든 링크에 클릭 이벤트를 추가
		document.querySelectorAll('.box a').forEach(function(link) {
			link.addEventListener('click', function(event) {
				event.preventDefault();

				// 상품 번호를 URL에서 추출
				var href = this.getAttribute('href');
				var boardNumber = href.split('board_number=')[1];
				// 조회수 증가를 위한 AJAX 요청
					$.ajax({
						url : "/shop/update",
						type : "POST",
						contentType : "application/json",
						data : JSON.stringify({"type":"views","board_number":boardNumber}),
						success : function() {
							window.location.href = href;
						},
						error : function() {
							alert("업데이트 실패");
						}
					});
				// 링크 기본 동작 방지
		        event.preventDefault();
			});
		});
	});
</script>