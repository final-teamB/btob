package io.github.teamb.btob.service.attachfile.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StreamUtils;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import io.github.teamb.btob.mapper.attachfile.AtchFileMapper;
import io.github.teamb.btob.service.attachfile.FileService;
import io.github.teamb.btob.service.common.CommonService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class FileServiceImpl implements FileService {

	// properti path chk
    //@Value("${file.upload-dir2}")
    //private String uploadDir;
    
    // 루트 경로 (공통)
    @Value("${file.upload.root}")
    private String rootPath;
    
    // 파일 이미지 미리보기 임시저장폴더
    @Value("${file.upload.path.temp}")
    private String imgTempPath;

    @Autowired
    private Environment env; // 설정값을 동적으로 가져오기 위함

    private final CommonService commonService;
    private final AtchFileMapper fileMapper;

    /**
     * 
     * 다중 파일 업로드
     * @author GD
     * @since 2026. 1. 26.
     * @param files
     * @param systmeId
     * @param refId
     * @return 다중 파일 업로드 정보 리스트
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public List<AtchFileDto> uploadFiles(List<MultipartFile> files, 
    										String systmeId, 
    										Integer refId) throws Exception {
    	
        List<AtchFileDto> resultList = new ArrayList<>();
        
        if (files == null || files.isEmpty()) {
        	return resultList;
        }

        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                resultList.add(this.uploadFile(file, systmeId, refId));
            }
        }
        
        return resultList;
    }

    
    /**
     * 
     * 단일 파일 업로드
     * @author GD
     * @since 2026. 1. 26.
     * @param file
     * @param systmeId
     * @param refId
     * @return 파일 업로드 정보
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public AtchFileDto uploadFile(MultipartFile file, 
    								String systmeId, 
    								Integer refId) throws Exception {
    	// 원본파일명
        String orgFileNm = file.getOriginalFilename();
        // 확장자
        String ext = orgFileNm.substring(orgFileNm.lastIndexOf(".") + 1);
        // 변경파일명
        String strFileNm = UUID.randomUUID().toString() + "." + ext;
        
        String subPath = env.getProperty("file.upload.path." + systmeId, ""); // 없으면 빈값
        
        // 디렉토리가 없다면 디렉토리 생성
        File dir = new File(rootPath, subPath);
        if (!dir.exists()) {
            boolean created = dir.mkdirs(); // 디렉토리 생성 시도
            if (!created) {
                // 디렉토리 생성 실패 시(권한 문제 등)에 대한 예외 처리
                throw new IOException("업로드 경로를 생성할 수 없습니다: " + rootPath + subPath);
            }
        }

        // 디렉토리에 파일 저장 처리
        // rootPath 대신 객체 dir 사용 권장
        File target = new File(dir, strFileNm); 
        file.transferTo(target);

        AtchFileDto dto = new AtchFileDto();
        dto.setOrgFileNm(orgFileNm);
        dto.setStrFileNm(strFileNm);
        dto.setFilePath(target.getAbsolutePath());
        dto.setFileExt(ext);
        dto.setFileSize(file.getSize());
        dto.setSystemId(systmeId);
        dto.setRefId(refId);

        fileMapper.insertFile(dto);
        return dto;
    }
    
    
    /**
     * 
     * 파일 다운로드
     * @author GD
     * @since 2026. 2. 3.
     * @param fileId
     * @param systemId
     * @param refId
     * @return fileDto
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 3.  GD       최초 생성
     */
    @Override
	public AtchFileDto getFileForDownload(Integer fileId, 
								Integer systemId, 
								Integer refId) throws Exception {
		
    	Map<String, Integer> params = new HashMap<>();
    	params.put("fileId", fileId);
    	params.put("systemId", systemId);
    	params.put("Integer", refId);
    	
    	if ( !(commonService.nullEmptyChkValidate(params)) ) {
    		throw new Exception("잘못된 파라미터 입니다.");
    	}
    	
    	// 1. DB에서 파일 정보 조회
        AtchFileDto fileDto = fileMapper.selectFileById(params);
        
        // 2. 파일 정보 검증
        if (fileDto == null || fileDto.getFilePath() == null) {
            throw new Exception("파일 정보가 없습니다.");
        }
    	
        // 3. 물리적 파일 존재 확인
        File file = new File(fileDto.getFilePath());
        if (!file.exists()) {
            throw new Exception("서버에 실제 파일이 존재하지 않습니다.");
        }
    	
		return fileDto;
	}
    
    /**
     * 
     * 첨부 파일 수정 시 삭제 처리 ( 미사용으로 변경 처리 )
     * @author GD
     * @since 2026. 2. 4.
     * @param systemId
     * @param refId
     * @param remainingFileNames	첨부 파일 리스트에 있는 파일명 리스트
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 4.  GD       최초 생성
     */
    @Override
    public void updateUnusedFiles(String systemId, 
    						Integer refId, 
    						List<String> remainingFileNames) throws Exception {
    	
        Map<String, Object> params = new HashMap<>();
        params.put("systemId", systemId);
        params.put("refId", refId);
        params.put("remainingFileNames", remainingFileNames);

        // 매퍼 호출 (결과값인 수정된 행의 수는 필요에 따라 로깅)
        fileMapper.updateUnusedFilesExceptRemaining(params);
    }
    
    /**
     * 
     * 이미지 표출
     * @author GD
     * @since 2026. 2. 4.
     * @param systemId
     * @param fileName
     * @param response
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 4.  GD       최초 생성
     */
    @Override
    public void displayImage(String systemId, String fileName, HttpServletResponse response) throws Exception {
        
    	File file;

        // 1. 경로 결정
        if ("TEMP".equals(systemId)) {
            // 임시 폴더에서 찾기
            file = new File(imgTempPath, fileName);
        } else {
            // 정식 폴더(PRODUCT_M, PRODUCT_D 등)에서 찾기
            String subPath = env.getProperty("file.upload.path." + systemId);
            if (subPath == null) {
                throw new Exception("정의되지 않은 시스템 경로입니다: " + systemId);
            }
            file = new File(rootPath + subPath, fileName);
        }
        
        // 2. 파일 존재 여부 확인
        if (!file.exists()) {
            log.error("파일을 찾을 수 없습니다. 경로: {}", file.getAbsolutePath());
            throw new Exception("파일을 찾을 수 없습니다.");
        }

        // 3. 파일의 MIME 타입 파악
        String contentType = Files.probeContentType(file.toPath());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        // 4. 응답 헤더 설정
        response.setContentType(contentType);
        
        // 5. 파일 복사 (스트림 전송)
        try (InputStream is = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            StreamUtils.copy(is, os);
            os.flush();
        }
    }

    /**
     * 
     * 일반 미사용 처리
     * @author GD
     * @since 2026. 2. 4.
     * @param refIds
     * @param userNo
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 4.  GD       최초 생성
     */
	@Override
	public Integer updateUnuseAtchFile(List<Integer> refIds, Integer userNo) throws Exception {
		
		Map<String, Object> params = new HashMap<>();
	    params.put("refIds", refIds);
	    params.put("userNo", userNo);
		
		if ( !(commonService.nullEmptyChkValidate(params)) ) {
    		throw new Exception("잘못된 파라미터 입니다.");
    	}
	    
	    return fileMapper.unUseAtchFile(params);
	}
	
	/**
	 * 
	 * 첨부파일 등록시 이미지 임시파일 저장
	 * @author GD
	 * @since 2026. 2. 6.
	 * @param file
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 6.  GD       최초 생성
	 */
	@Override
	public AtchFileDto uploadImgTempFile(MultipartFile file) throws Exception {
	    
		// 1. 임시 디렉토리 생성
	    File tempDir = new File(imgTempPath);
	    if (!tempDir.exists()) tempDir.mkdirs();

	    // 2. 파일명 생성 (원본명 유지 혹은 UUID)
	    String orgNm = file.getOriginalFilename();
	    String ext = orgNm.substring(orgNm.lastIndexOf(".") + 1);
	    String strFileNm = UUID.randomUUID().toString() + "." + ext;

	    // 3. 물리적 저장
	    File targetFile = new File(tempDir, strFileNm);
	    file.transferTo(targetFile);

	    // 4. 정보 반환 (DB 저장은 하지 않음)
	    AtchFileDto dto = new AtchFileDto();
	    dto.setOrgFileNm(strFileNm); // 저장된 파일명
	    dto.setStrFileNm(strFileNm);
	    return dto;
	}
	
	
	/**
	 * 
	 * 서버 내 특정 임시 경로의 이미지 파일을 시스템 저장소로 이동 및 등록
	 * @author GD
	 * @since 2026. 2. 4.
	 * @param orgFileNm
	 * @param systemId
	 * @param refId
	 * @param tempPath
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 4.  GD       최초 생성
	 */
	@Override
	public AtchFileDto registerInternalImgFile(AtchFileDto fileDto) throws Exception {
	    
	    // 1. 시스템별 정식 저장 경로 확인 (기존 uploadFile 로직과 동일하게 env에서 가져옴)
	    String subPath = env.getProperty("file.upload.path." + fileDto.getSystemId(), "");
	    File dir = new File(rootPath, subPath);
	    if (!dir.exists()) {
	        if (!dir.mkdirs()) {
	            throw new IOException("업로드 경로를 생성할 수 없습니다: " + dir.getPath());
	        }
	    }

	    // 2. 임시 경로에서 파일 확인 (D:\temp\img 등)
	    File tempFile = new File(imgTempPath, fileDto.getOrgFileNm());
	    if (!tempFile.exists()) {
	        log.warn("파일이 임시 경로에 없습니다: {}", fileDto.getOrgFileNm());
	        return null;
	    }

	    // 3. 파일명 변환 및 확장자 추출 (기존 uploadFile과 동일한 UUID 방식)
	    String orgFileNm = fileDto.getOrgFileNm();
	    String ext = orgFileNm.substring(orgFileNm.lastIndexOf(".") + 1);
	    String strFileNm = UUID.randomUUID().toString() + "." + ext;
	    
	    File targetFile = new File(dir, strFileNm);
	    
	    try {
	        // [파일 이동] MultipartFile.transferTo 대신 Files.move 사용
	        Files.move(tempFile.toPath(), targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
	        log.info("임시 파일 정식 저장소 이동 완료: {}", targetFile.getAbsolutePath());
	    } catch (IOException e) {
	        log.error("파일 이동 중 오류 발생: {}", e.getMessage());
	        throw new Exception("파일 저장소 이동 실패");
	    }

	    // 4. DTO 정보 세팅 (기존 uploadFile의 필드 세팅과 동일하게 맞춤)
	    AtchFileDto resultDto = new AtchFileDto();
	    resultDto.setOrgFileNm(orgFileNm);           // 원본파일명
	    resultDto.setStrFileNm(strFileNm);           // 변경파일명(UUID)
	    resultDto.setFilePath(targetFile.getAbsolutePath()); // 절대경로 (기존 로직이 absolutePath를 쓰므로 동일하게 유지)
	    resultDto.setFileExt(ext);                   // 확장자
	    resultDto.setFileSize(targetFile.length());  // 파일크기
	    resultDto.setSystemId(fileDto.getSystemId());// 시스템ID (PRODUCT_M 등)
	    resultDto.setRefId(fileDto.getRefId());       // 참조ID (fuelId)

	    // 5. DB 등록 (기존 uploadFile과 동일한 매퍼 호출)
	    fileMapper.insertFile(resultDto);
	    
	    return resultDto;
	}
}
