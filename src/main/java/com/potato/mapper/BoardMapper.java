package com.potato.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.potato.domain.BoardVO;

@Mapper
public interface BoardMapper {

	public List<BoardVO> getList();

	public void insert(BoardVO board);

	public BoardVO read(String board_number);

	public int update(BoardVO vo);

	public int delete(String board_number);

	// 추후 아이디당 1회성으로 코드 변경

	public void updateLikes(BoardVO board);

	public void updateInterest(BoardVO board);

	public void updateViews(BoardVO board);

}
