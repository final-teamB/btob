package io.github.teamb.btob.mapper.document;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.document.DocumentListDTO;
import io.github.teamb.btob.dto.document.DocumentMemoActionDTO;
import io.github.teamb.btob.dto.document.DocumentPreviewDTO;

@Mapper
public interface TradeDocMapper {

	// 메모 수정
	void modifyMemo(DocumentMemoActionDTO dma);
	
	// 견적서, 계약서, 결제내역서 목록
	List<DocumentListDTO> getDocumentList(String docType, String keyword);
	
	// 문서 미리보기(PDF변환)
	DocumentPreviewDTO getDocumentById(int docId);


}
