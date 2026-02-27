package io.github.teamb.btob.controller.notice;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

import io.github.teamb.btob.entity.Notice;
import io.github.teamb.btob.entity.NoticeFile;
import io.github.teamb.btob.service.notice.NoticeService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/notice")
@RequiredArgsConstructor
public class NoticeController {

    private final NoticeService noticeService;
    
    @Value("${file.upload.root}${file.upload.path.NOTICE}")
    private String uploadPath;

    // 일반 사용자가 보는 목록 
    @GetMapping("/user/list") 
    public String userList(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Notice> list = noticeService.getNoticeList(keyword);
        model.addAttribute("noticeList", list); 
        model.addAttribute("content", "testKSH/noticeUserList.jsp"); // 사용자용 리스트 JSP
        return "layout/layout";
    }

    // 일반 사용자가 보는 상세 
    @GetMapping("/user/detail/{id}")
    public String userDetail(@PathVariable("id") Integer id, Model model) {
        Notice notice = noticeService.getNoticeDetail(id);
        model.addAttribute("notice", notice);
        model.addAttribute("content", "testKSH/noticeDetail.jsp"); // 사용자용 상세 JSP
        return "layout/layout";
    }
    
    // 목록 조회 (검색 포함)
    @GetMapping
    public String list(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Notice> list = noticeService.getNoticeList(keyword);
        model.addAttribute("noticeList", list); 
        model.addAttribute("content", "testKSH/noticeList.jsp");
        return "layout/layout";
    }

    // 공지사항 등록 처리 (관리자용)
    @PostMapping("/write")
    public String write(Notice notice, 
                        @RequestParam("files") List<MultipartFile> files,
                        @AuthenticationPrincipal UserDetails userDetails) throws IOException {
        
        notice.setRegId(userDetails.getUsername());
        notice.setUpdId(userDetails.getUsername());

        if (files != null && !files.isEmpty()) {
            for (MultipartFile file : files) {
                if (!file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                    
                    System.out.println("파일 저장 경로: " + uploadPath + savedFileName);
                    
                    File dir = new File(uploadPath);
                    if (!dir.exists()) dir.mkdirs();
                    file.transferTo(new File(uploadPath + savedFileName));

                    // NoticeFile 객체 생성 및 연결
                    NoticeFile noticeFile = NoticeFile.builder()
                            .originFileName(originalFileName)
                            .storedFileName(savedFileName)
                            .regId(userDetails.getUsername())
                            .notice(notice) // 부모 객체 연결
                            .build();
                    
                    notice.getNoticeFiles().add(noticeFile);
                }
            }
        }
        noticeService.saveNotice(notice);
        
        return "redirect:/notice";
    }

    // 파일 다운로드 실행
    @GetMapping("/download/{fileName}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName) throws IOException {
    	System.out.println("다운로드 시도 경로: " + uploadPath + fileName);
        File file = new File(uploadPath + fileName);
        
        if (!file.exists()) {
            throw new FileNotFoundException("파일이 존재하지 않습니다: " + uploadPath + fileName);
        }

        Resource resource = new UrlResource(file.toURI()); // file.toURI()를 쓰면 자동으로 file:/ 경로를 만들어줍니다.
        
        String encodedFileName = UriUtils.encode(fileName.substring(fileName.indexOf("_") + 1), StandardCharsets.UTF_8);
        String contentDisposition = "attachment; filename=\"" + encodedFileName + "\"";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition)
                .body(resource);
    }
    
    // 수정 페이지 이동 (모달 대응)
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Integer id, 
                           @RequestParam(value="isModal", defaultValue="N") String isModal, 
                           Model model) {
        Notice notice = (id == null || id == 0) ? new Notice() : noticeService.getNoticeDetail(id);
        model.addAttribute("notice", notice);
        
        // 모달 요청인 경우 레이아웃 없이 JSP만 리턴
        if ("Y".equals(isModal)) {
            return "testKSH/noticeEdit"; 
        }
        
        model.addAttribute("content", "testKSH/noticeEdit.jsp");
        return "layout/layout";
    }

    // 수정 실행
    @PostMapping("/update")
    public String update(Notice notice, 
                         @RequestParam(value = "files", required = false) List<MultipartFile> files, // 이거 추가!
                         @AuthenticationPrincipal UserDetails userDetails) throws IOException {
        
        if (userDetails == null) return "redirect:/home/index";
        notice.setUpdId(userDetails.getUsername());

        // 파일 업데이트 로직 추가
        if (files != null && !files.isEmpty()) {
        	for (MultipartFile file : files) {
                if (!file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                    
                    File dir = new File(uploadPath);
                    if (!dir.exists()) dir.mkdirs();
                    file.transferTo(new File(uploadPath + savedFileName));

                    // 새로운 파일 객체 생성 및 연결
                    NoticeFile noticeFile = NoticeFile.builder()
                            .originFileName(originalFileName)
                            .storedFileName(savedFileName)
                            .regId(userDetails.getUsername())
                            .notice(notice) // 부모 연결
                            .useYn("Y")
                            .build();
                    
                    // 엔티티의 리스트에 추가
                    notice.getNoticeFiles().add(noticeFile);
                }
            }
        }
        noticeService.updateNotice(notice);
        return "redirect:/notice"; // 수정 후 목록으로 이동
    }
    
    // 파일 삭제
    @PostMapping("/file/delete/{fileId}")
    @ResponseBody
    public ResponseEntity<String> deleteFile(@PathVariable Integer fileId) {
        noticeService.deleteNoticeFile(fileId);
        return ResponseEntity.ok("success");
    }

    // 삭제 실행
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        noticeService.deleteNotice(id);
        return "redirect:/notice";
    }
}