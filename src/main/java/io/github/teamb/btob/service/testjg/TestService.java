package io.github.teamb.btob.service.testjg;

import java.io.FileOutputStream;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

@Service
public class TestService {

	    public void createPdfFromGrid(List<Map<String, Object>> rows, String filePath) throws Exception {
	        StringBuilder html = new StringBuilder("<html><body>");
	        html.append("<h1>선택 상품 PDF</h1><table border='1'><tr><th>ID</th><th>상품명</th><th>수량</th><th>단가</th><th>총액</th></tr>");
	        for (Map<String, Object> row : rows) {
	            html.append("<tr>")
	                .append("<td>").append(row.get("id")).append("</td>")
	                .append("<td>").append(row.get("name")).append("</td>")
	                .append("<td>").append(row.get("qty")).append("</td>")
	                .append("<td>").append(row.get("price")).append("</td>")
	                .append("<td>").append((Integer)row.get("qty")*(Integer)row.get("price")).append("</td>")
	                .append("</tr>");
	        }
	        html.append("</table></body></html>");

	        try (FileOutputStream os = new FileOutputStream(filePath)) {
	            PdfRendererBuilder builder = new PdfRendererBuilder();
	            builder.withHtmlContent(html.toString(), null);
	            builder.toStream(os);
	            builder.run();
	        }
	    }

		public int importUsersFromExcel(MultipartFile file) {
			// TODO Auto-generated method stub
			return 0;
		}

}
