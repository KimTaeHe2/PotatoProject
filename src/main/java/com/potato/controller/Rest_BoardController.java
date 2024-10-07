package com.potato.controller;


import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.potato.domain.BoardVO;
import com.potato.domain.CartVO;
import com.potato.domain.Criteria;
import com.potato.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@RestController
@RequestMapping("/shop/*")
@Log4j2
@AllArgsConstructor
public class Rest_BoardController {

	private BoardService service;
	
	@GetMapping(value="/rank", produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<Map<String, Object>>> searchRank() {
	    try {
	        List<Map<String, Object>> ranks = new ArrayList<>();
	        
	        // 검색 순위를 가져오는 로직
	        List<BoardVO> searchRanks  = service.searchRank();
	        
	        // 검색 순위를 리스트에 추가
	        for (BoardVO rank : searchRanks) {
	            Map<String, Object> rankMap = new HashMap<>();
	            rankMap.put("title", rank.getTitle()); // 검색어
	            ranks.add(rankMap);
	        }
	        
	        return ResponseEntity.ok(ranks); // 성공적으로 응답
	    } catch (Exception e) {
	        // 에러가 발생한 경우
	        // 에러를 나타내는 Map을 List로 감싸서 반환
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body(Collections.singletonList(Collections.singletonMap("error", "Internal Server Error")));
	    }
	}
	
	
	
	@GetMapping(value="/RecentListMore",consumes="application/json", 
		  	   	produces=MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Map<String, Object>> getMoreRecentList(@RequestParam(defaultValue = "1") int pageNum,
            							   @RequestParam(defaultValue = "12") int amount) {
		 // Criteria 객체 생성
        Criteria cri = new Criteria(pageNum, amount);

        // 서비스에서 전체 개수와 게시물 리스트 가져오기
        int total = service.getTotal(cri);
        List<BoardVO> list = service.getRecent(cri);

        // 응답 데이터 맵 생성
        Map<String, Object> response = new HashMap<>();
        response.put("list", list != null ? list : new ArrayList<>());

        // 더 많은 데이터가 있는지 확인
        boolean hasMore = (pageNum * amount) < total;
        response.put("hasMore", hasMore); // 더 많은 데이터가 있는지 여부 추가

        // ResponseEntity로 JSON 형식의 데이터를 반환
        return ResponseEntity.ok(response);
	}
	
	@GetMapping(value="/listMore",consumes="application/json", 
	  	   	produces=MediaType.APPLICATION_JSON_VALUE)
public ResponseEntity<Map<String, Object>> getMoreList(@RequestParam(defaultValue = "1") int pageNum,
        							   @RequestParam(defaultValue = "12") int amount) {
	 // Criteria 객체 생성
    Criteria cri = new Criteria(pageNum, amount);

    // 서비스에서 전체 개수와 게시물 리스트 가져오기
    int total = service.getTotal(cri);
    List<BoardVO> list = service.getMoreList(cri);

    // 응답 데이터 맵 생성
    Map<String, Object> response = new HashMap<>();
    response.put("list", list != null ? list : new ArrayList<>());

    // 더 많은 데이터가 있는지 확인
    boolean hasMore = (pageNum * amount) < total;
    response.put("hasMore", hasMore); // 더 많은 데이터가 있는지 여부 추가

    // ResponseEntity로 JSON 형식의 데이터를 반환
    return ResponseEntity.ok(response);
}
	
	  @PostMapping(value ="/update_like",consumes="application/json")
	  public ResponseEntity<?>update_like(@RequestBody CartVO cart) {
		  CartVO cart2 = new CartVO();
		  String board_number = cart.getLikes_board_number();
		  try {
		  cart2 = service.get_cart(cart);
		  	 if(cart2==null) {
		  	 service.insertLike(cart);
		  	 }
		
		  	 else if(cart2.getInterest()==1) {
		  	 service.insert_both(cart);
		  	 }
		  } catch (Exception e) {
			} 
		  service.updateLikes(board_number);
		  service.cancelViews(board_number);
		  return ResponseEntity.ok(cart);
	  }
	 
	  @PostMapping(value ="/update_interest",consumes="application/json", 
		  	   produces=MediaType.APPLICATION_JSON_VALUE) 
public ResponseEntity<?> update_interest(@RequestBody CartVO cart) {
	  CartVO cart2 = new CartVO();	 
	  cart2 = service.get_cart(cart);
	  String board_number = cart.getLikes_board_number();
	  	 if(cart2==null) {
	  	 service.insertInterest(cart);
	  	 }
	  	 else if(cart2.getLikes()==1) {
	  	 service.insert_both(cart);	
	  	 }
	  	service.updateInterest(board_number);
	  	service.cancelViews(board_number);
return ResponseEntity.ok(cart);
}
	  @PostMapping(value ="/cancel_like",consumes="application/json", 
		  	   produces=MediaType.APPLICATION_JSON_VALUE) 
	  public ResponseEntity<?> cancel_like(@RequestBody CartVO cart){
		  CartVO cart2 = new CartVO();	 
		  cart2 = service.get_cart(cart);
		  if(cart2.getInterest()==1) {
			  service.cancelLike(cart);
		  }
		  else {service.cancel_both(cart);
		  }
		  String board_number = cart.getLikes_board_number();
		  service.cancelLikes(board_number);
		  service.cancelViews(board_number);
		  return ResponseEntity.ok(cart2);
	  }
	  
	  @PostMapping(value ="/cancel_interest",consumes="application/json", 
	   produces=MediaType.APPLICATION_JSON_VALUE)
	  public ResponseEntity<?> cancel_interest(@RequestBody CartVO cart){
		  CartVO cart2 = new CartVO();	 
		  cart2 = service.get_cart(cart);
		  if(cart2.getLikes()==1) {
			  service.cancelInterest2(cart2);
		  }
		  else {
			  service.cancel_both(cart2);
		  }
		  String board_number = cart.getLikes_board_number();
		  service.cancelInterest(board_number);
		  service.cancelViews(board_number);
		  return ResponseEntity.ok(cart2);
	  }
	  
}

