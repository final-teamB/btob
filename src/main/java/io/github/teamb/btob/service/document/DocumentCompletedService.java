package io.github.teamb.btob.service.document;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.document.DocumentListDTO;
import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import io.github.teamb.btob.mapper.document.DocumentCompletedMapper;
import jakarta.servlet.http.HttpServletResponse;

@Service
@Transactional
public class DocumentCompletedService {
	private final DocumentCompletedMapper documentCompletedMapper;

	public DocumentCompletedService(DocumentCompletedMapper documentCompletedMapper) {
		this.documentCompletedMapper = documentCompletedMapper;
	}
	
	public DocumentPreviewDTO getDocumentById(int docId) {
		return documentCompletedMapper.getDocumentById(docId);
	}

	public List<DocumentListDTO> getDocumentList() {
		return documentCompletedMapper.getDocumentList();
	}

}
