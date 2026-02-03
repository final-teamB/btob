package io.github.teamb.btob.controller.attchfile;

import java.io.File;
import java.io.FileInputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import io.github.teamb.btob.service.attachfile.FileService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AtchFileController {
	
	private final FileService fileService;
	
	
	/**
     * 
     * 파일 업로드 실행
     * @author GD
     * @since 2026. 1. 26.
     * @param files
     * @param refTypeCd
     * @param refId
     * @return 업로드 후 이동할 페이지
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @PostMapping("/fileupload")
    public String fileupload(@RequestParam("files") List<MultipartFile> files
                             ,@RequestParam("systemId") String systemId
                             ,@RequestParam("refId") int refId
                             ,@RequestParam(value = "redirectUrl", required = false) String redirectUrl) 
                  throws Exception {
        
        log.info("업로드 시작 - 파일 개수: " + files.size());
        
        // 파일업로드
        fileService.uploadFiles(files, systemId, refId);
        
        log.info("업로드 완료");
        
        // 리다이렉트 처리
        // redirectUrl이 없으면 기본 페이지로 설정
        if (redirectUrl == null || redirectUrl.isEmpty()) {
            redirectUrl = "/default/page"; 
        }
        
        //성공 후 상세 페이지 등으로 돌아가길 권장하면 밑에 주석 풀기
        //return "redirect:" + redirectUrl + "?systemId=" + systemId + "&refId=" + refId;
        return("redirect:" + redirectUrl);
    }
	
	/**
	 * 
	 * 파일 다운로드
	 * @author GD
	 * @since 2026. 2. 3.
	 * @param fileId
	 * @param systemId
	 * @param refId
	 * @param response
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 3.  GD       최초 생성
	 */
	@GetMapping("/filedownload/{fileId}")
	public void downloadFile(@PathVariable Integer fileId 
			,@PathVariable Integer systemId
			,@PathVariable Integer refId
			,HttpServletResponse response) throws Exception {
		
	    try {

	    	// 서비스에서 검증된 파일 정보 호출
	        AtchFileDto fileDto = fileService.getFileForDownload(fileId, systemId, refId);
	        File file = new File(fileDto.getFilePath());

	        // 파일명 인코딩
	        // (공백이 +로 변하는 것을 방지하기 위해 .replace("+", "%20") 추가 가능)
	        String encodedNm = UriUtils.encode(fileDto.getOrgFileNm(), StandardCharsets.UTF_8)
	        							.replace("+", "%20");

	        // 응답 헤더 설정
	        // 파일 확장자에 따라 Content-Type을 동적으로 설정
	        response.setContentType("application/octet-stream");
	        
	        // 다운로드 창이 뜨게 하려면 attachment, 브라우저에서 바로 열려면 inline
	        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedNm + "\"");
	        response.setContentLength((int) file.length());

	        // 파일 복사 (Stream 처리)
	        try (FileInputStream fis = new FileInputStream(file)) {
	        	
	            FileCopyUtils.copy(fis, response.getOutputStream());
	            response.getOutputStream().flush();
	        }
	    } catch (Exception e) {
	    	
	        // 서비스에서 던진 예외 메시지에 따라 에러 응답
	        response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
	    }
	}
	 /**
     * 
     * 파일 정보 삭제 처리 ( 미사용으로 미표출 처리함 )
     * @author GD
     * @since 2026. 1. 26.
     * @param fileId
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @DeleteMapping("/file/{fileId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteFile(@PathVariable int fileId) {
    	
        Map<String, Object> result = new HashMap<>();
        try {
        	
            fileService.deleteFile(fileId);
            result.put("status", "success");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
        	
            result.put("status", "error");
            result.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }

}
