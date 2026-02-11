package io.github.teamb.btob.controller.mgmtAdm.est;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class EstController {
	
	@GetMapping("/document/preview-est")
    public String previewEst() {
        // 실제 파일 위치:
        // src/main/webapp/WEB-INF/views/document/previewEst.jsp
        // prefix: /WEB-INF/views/
        // suffix: .jsp
        // ==>  /WEB-INF/views/document/previewEst.jsp
        return "document/previewEst";
    }
}
