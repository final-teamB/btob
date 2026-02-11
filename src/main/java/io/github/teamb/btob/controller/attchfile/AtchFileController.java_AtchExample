package io.github.teamb.btob.jprtest.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

import io.github.teamb.btob.jprtest.dto.AtchFileDto;
import io.github.teamb.btob.jprtest.service.impl.FileService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
// @RequestMapping("/common/file")
@RequestMapping("/jjjtest")
public class AtchFileController {


    private final FileService fileService;

    @GetMapping("/hometest")
    public String jjjtestt() {
    	
    	return "jjjtest/home";
    }
    
    
    // 테스트 페이지 열기
    //WEB-INF/jsp/fileUploadTest.jsp 호출
    // 파일 업로드 테스트
    @GetMapping("/page")
    public String testPage() {
    	
        return "jjjtest/fileUploadTest"; 
    }
    
    // 파일 다운로드 테스트
    @GetMapping("/filedownload-test")
    public String downloadTestPage() {
        
    	return "jjjtest/fileDownloadTest"; // fileDownloadTest.jsp 호출
    }
    
    // 여기까지가 테스트 전용
    ///////////////////////////////////////////////////////////////////////////
    
    
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
    public String uploadTest(@RequestParam("files") List<MultipartFile> files,
                             @RequestParam("refTypeCd") String refTypeCd,
                             @RequestParam("refId") int refId) throws Exception {
        
        log.info("업로드 시작 - 파일 개수: " + files.size());
        
        // 파일업로드
        fileService.uploadFiles(files, refTypeCd, refId);
        
        log.info("업로드 완료");
        return "redirect:/jjjtest/page"; // 다시 테스트 페이지로
    }
    

    /**
     * 
     * 파일 다운로드 및 미리보기 (이미지 포함)
     * @author GD
     * @since 2026. 1. 26.
     * @param fileId
     * @param response
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @GetMapping("/filedownload/{fileId}")
    public void downloadFile(@PathVariable int fileId, HttpServletResponse response) throws Exception {
    	
        AtchFileDto fileDto = fileService.getFile(fileId);
        
        if (fileDto == null || fileDto.getFilePath() == null) {
        	
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일 정보가 없습니다.");
            return;
        }

        File file = new File(fileDto.getFilePath());
        if (!file.exists()) {
        	
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "물리 파일이 존재하지 않습니다.");
            return;
        }

        // 파일명 인코딩 (공백이 +로 변하는 것을 방지하기 위해 .replace("+", "%20") 추가 가능)
        String encodedNm = UriUtils.encode(fileDto.getOrgFileNm(), StandardCharsets.UTF_8).replace("+", "%20");

        // 파일 확장자에 따라 Content-Type을 동적으로 설정하면 더 좋습니다.
        response.setContentType("application/octet-stream");
        
        // 다운로드 창이 뜨게 하려면 attachment, 브라우저에서 바로 열려면 inline
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedNm + "\"");
        response.setContentLength((int) file.length());

        try (FileInputStream fis = new FileInputStream(file)) {
        	
            FileCopyUtils.copy(fis, response.getOutputStream());
            response.getOutputStream().flush();
        }
    }
    
    
    /**
     * 
     * 파일 목록 조회 ( 참조 대상별 )
     * @author GD
     * @since 2026. 1. 26.
     * @param refTypeCd
     * @param refId
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @GetMapping("/filelist")
    @ResponseBody // JSON 반환을 위해 필수
    public List<AtchFileDto> getFileList(@RequestParam String refTypeCd, @RequestParam int refId) throws Exception {

        return fileService.getFilesByRef(refTypeCd, refId);
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
