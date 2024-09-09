<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<meta charset="UTF-8">
 <%@ include file="../common/header.jsp" %>
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <!-- Mobile Metas -->
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <!-- Site Metas -->
  <meta name="keywords" content="" />
  <meta name="description" content="" />
  <meta name="author" content="" />
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/images/favicon.png" type="image/x-icon">


  <!-- slider stylesheet -->
  <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" />

  <!-- bootstrap core css -->
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/bootstrap.css" />

  <!-- Custom styles for this template -->
  <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" />
  <!-- responsive style -->
  <link href="${pageContext.request.contextPath}/resources/css/responsive.css" rel="stylesheet" />
  
 <style type="text/css">
 input {
  width: 800px;
  height: 100px;
  font-size: 15px;
  border: 0;
  border-radius: 15px;
  outline: none;
  padding-left: 10px;
  background-color: rgb(233, 233, 233);
}
 </style>


<div class="container-fluid">
	<div class="row">
		<div class="col-md-8">
			<div class="tabbable" id="tabs-542194">
				<ul class="nav nav-tabs">
					<li class="nav-item">
						<a class="nav-link active show" href="#tab1" data-toggle="tab">후기</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="#tab2" data-toggle="tab">매너 칭찬</a>
					</li>
				</ul><br><br>
				
				    <table width="100%">
				        <tr>
				            <td>
				                <input type="text" name="content" id="content" style="width: 90%;" placeholder="댓글은 최대 1000자까지 입력가능합니다." />
				            </td>
				        </tr>
				        <tr>
				            <td colspan="2" align="right">
				                <button type="submit" id ="replySubmit" class="btn btn-sm btn-primary">작성 완료</button>
				            </td>
				        </tr>
				    </table>
				
				<div class="tab-content">
					<div class="tab-pane active" id="panel-734299">
						<div class="panel-body">
						<br><br>
			      			<ul class="chat">
			      				<!-- reply(댓글) 시작 -->
			      				<!-- <li class="left clearfix" data-rno='12'> -->
			      					<!-- <div>
			      						<div class="header">
			      							<strong class="primary-font">user00</strong>
			      							<small class="pull-right text-muted">2018-01-01 13:13</small>
			      						</div>
			      						<p>Good job!</p>
			      					</div> -->
			      				<!-- </li> -->
			      			</ul>
      					</div>
					</div>
					<div class="tab-pane" id="tab2">
						<p>
							Howdy, I'm in Section 2.
						</p>
					</div>
				</div>
			</div>
			
		</div>
	</div>
</div>




<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
$(document).ready(function(){
	
	//var idValue = '<c:out value="${reply.id}"/>';
	var idValue = 'kwh';
	var replyUL = $(".chat");
	
		showList(1);
		
		function showList(page){
			
			console.log("show list " + page);
			
			replyService.getList({id:idValue, page:page||1}, function(list){
				
				console.log("list : " + list);
				console.log(list);
				
				/* if(page == -1){ // 페이지 번호가 -1로 전달되면 마지막페이지를 호출
					pageNum = Math.ceil(replyCnt/10.0); // 댓글 개수를 10으로 나눠서 올림을 함
					showList(pageNum);
					return;
				} */
				
				var str = "";
				if(list == null || list.length == 0){
					replyUL.html("");
					
					return;
				}
				for (var i = 0, len = list.length || 0; i < len; i++){
					str +="<li class='left clearfix' data-reply_number='"+list[i].reply_number+"'>";
					str +="	<div><div class='header'><strong class='primary-font'>"+list[i].writer+"</strong>";
					str +="		<small class='pull-right text-muted'>"+replyService.displayTime(list[i].regidate)+"</small></div>";
					str +="		<p>"+list[i].content+"</p></div></li>";
				} // for 종료
				replyUL.html(str);
				
				//showReplyPage(replyCnt);
			}); // replyService.getList 종료
		} // function showList 종료
		
		// 댓글 입력
		$('#replySubmit').on("click", function(e) {
		    
			var content = $('#content').val();
			
		    //var id = $('#id').val();
		    var reply = {
		    	id:'kwh',
		    	content:$('#content').val(),
		    	writer:'김우혁'
		    };
		    
		   	if(content =='' || content == null) {
		       alert("내용을 입력하세요");
		       return;
		    }
		    
		    replyService.add(reply, function(result){
		    			alert("결과 : " + result);
		    });
		    $('#content').val("");
		    
		});
		
		
		
		
});

<%@ include file="../common/footer.jsp" %>
