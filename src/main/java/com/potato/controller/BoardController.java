package com.potato.controller;

import java.io.File;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.potato.domain.BoardVO;
import com.potato.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@RequestMapping("/shop/*")
@Controller
@Log4j2
@AllArgsConstructor		// 모든 필드값으로 생성자 만듬
public class BoardController {

	// 필드
	private BoardService service;
	private static final String UPLOAD_DIR = "uploads/";
	@GetMapping("/list")
	public void list(Model model) {
		
		log.info("컨트롤러 리스트 메서드 실행");
		model.addAttribute("list", service.getList());
		
	}
	
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("board_number") String board_number, Model model) {
		log.info("컨트롤러 get메서드 실행");
		
		model.addAttribute("board", service.get(board_number));
	}
	
	
	@GetMapping("/register")
	public void register() {
		log.info("컨트롤러 레지스터 겟 메서드 실행");
	}
	
	@PostMapping("/register") //  http://localhost:80/shop/register
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("BoardController.register post메서드 실행");

	    MultipartFile file = board.getPhoto_name(); // BoardVO에 MultipartFile 타입의 필드가 있어야 함
	    if (file != null && !file.isEmpty()) {
	        File uploadDir = new File(UPLOAD_DIR);
	        if (!uploadDir.exists()) {
	            if (!uploadDir.mkdirs()) { // mkdirs()를 사용하여 중간 디렉토리도 생성
	                log.error("업로드 디렉토리 생성 실패");
	                rttr.addFlashAttribute("message", "업로드 디렉토리 생성 실패");
	                return "redirect:/shop/register";
	            }
	        }

	        try {
	            File destinationFile = new File(uploadDir, file.getOriginalFilename()); // 경로 구분자를 명시적으로 추가
	            file.transferTo(destinationFile);
	            log.info("파일 업로드 성공: " + file.getOriginalFilename());
	        } catch (Exception e) {
	            log.error("파일 업로드 실패: " + e.getMessage(), e);
	            rttr.addFlashAttribute("message", "파일 업로드 실패: " + e.getMessage());
	            return "redirect:/shop/register";
	        }
	    }

	    service.register(board); // 프론트에서 form 값이 객체로 넘어옴

	    return "redirect:/shop/list";
	}
	
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr) {
		
		log.info("보드컨트롤러 modify 메서드 실행");
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/shop/list";
	}
	
	@PostMapping("/remove") 	// 번호를 받아 delete 쿼리를 실행
	public String remove(@RequestParam("board_number") String board_number, RedirectAttributes rttr){
		
		log.info("BoardController.remove메서드 실행");
		if (service.remove(board_number)) { // service.remove의 리턴 타입이 boolean
			rttr.addFlashAttribute("result", "success"); // 수정 성공시 success 메시지를 보냄
		}
		
		return "redirect:/shop/list";  // 결론 http://localhost:80/shop/list
	}
}
