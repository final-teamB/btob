package io.github.teamb.btob.service.document;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface DocumentPdfService {
	void exportPdf(int docId, Object detailData, HttpServletRequest request, HttpServletResponse response);
}
