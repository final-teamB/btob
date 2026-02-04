package io.github.teamb.btob.controller.document;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.github.teamb.btob.service.document.DocumentPdfService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/document")
public class DocumentPdfController {

    private final DocumentPdfService documentPdfService;

    public DocumentPdfController(DocumentPdfService documentPdfService) {
        this.documentPdfService = documentPdfService;
    }

    @GetMapping("/exportPdf")
    public void exportPdf(
    		@RequestParam int docId,
            HttpServletRequest request,
            HttpServletResponse response) {

        documentPdfService.exportPdf(docId, request, response);
    }
}
