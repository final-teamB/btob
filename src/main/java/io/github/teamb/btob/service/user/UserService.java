package io.github.teamb.btob.service.user;

import java.util.List;
import java.util.Optional;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.common.ExcelUploadResult;
import io.github.teamb.btob.dto.user.UserDTO;
import io.github.teamb.btob.dto.user.UserListDTO;
import io.github.teamb.btob.dto.user.UserPendingActionDTO;
import io.github.teamb.btob.dto.user.UserPendingDTO;
import io.github.teamb.btob.dto.user.UserStatusDTO;
import io.github.teamb.btob.mapper.user.UserMapper;

@Service
@Transactional
public class UserService {
	private final UserMapper userMapper;

	public UserService(UserMapper userMapper) {
		this.userMapper = userMapper;
	}
	
	// 사원 회원가입 인증
	public void processPendingUser(UserPendingActionDTO upa) {
		userMapper.processPendingUser(upa);
	}
	
	// 사원 회원가입 인증 대기 목록
	public List<UserPendingDTO> getPendingUsers() {
		return userMapper.getPendingUsers();
	}

	
	// 사원 상태 수정
	public void modifyUserStatus(UserStatusDTO userStatus) {
		//Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        //CustomUserDetails loginUser = (CustomUserDetails) auth.getPrincipal();

		String updId = null; //loginUser.getUserId();
		
		String useYn = "Y";
		if ("STOP".equals(userStatus.getAccStatus())) {
		    useYn = "N";
		}
		userStatus.setUpdId(updId);
		userStatus.setUseYn(useYn);
		
	    userMapper.modifyUserStatus(userStatus);
	}
	
	// 사원리스트
	public List<UserListDTO> getUserList(String accStatus, String keyword) {
		return userMapper.getUserList(accStatus, keyword);			
	}
	
	
	// 신규 회사 회원가입 후 사원 엑셀 등록
	public ExcelUploadResult<UserDTO> readExcel(MultipartFile file) throws Exception {
        ExcelUploadResult<UserDTO> result = new ExcelUploadResult<>();

        try (Workbook workbook = new XSSFWorkbook(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            for (int r = 1; r <= sheet.getLastRowNum(); r++) { // 0번 행은 헤더
                Row row = sheet.getRow(r);
                if (row == null) continue;

                UserDTO user = buildUserDTO(row);
                ExcelUploadResult.FailItem fail = validateUserDTO(r, user);

                if (fail != null) {
                    result.getFailList().add(fail);
                } else {
                    result.getSuccessList().add(user);
                }
            }
        }

        int total = result.getSuccessList().size() + result.getFailList().size();
        result.setTotalCount(total);
        result.setSuccessCount(result.getSuccessList().size());
        result.setFailCount(result.getFailList().size());
        return result;
    }


    public int commitExcel(List<UserDTO> userList) {
        if (userList == null || userList.isEmpty()) return 0;
        return userMapper.insertUsers(userList); // Mapper에서 foreach 처리
    }


    private UserDTO buildUserDTO(Row row) {
    	//Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        //CustomUserDetails loginUser = (CustomUserDetails) auth.getPrincipal();
    	BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    	
		String regId = null; //loginUser.getUserId();
    	
        return UserDTO.builder()
                .userId(getCellValue(row.getCell(0)))
                .userName(getCellValue(row.getCell(1)))
                .phone(getCellValue(row.getCell(2)))
                .email(getCellValue(row.getCell(3)))
                .companyCd(Optional.ofNullable(getCellValue(row.getCell(4)))
                                   .filter(s -> !s.isBlank())
                                   .orElse(null))
                .password(passwordEncoder.encode("1234"))       // 초기 비밀번호
                .userType("USER")
                .appStatus("APPROVED")
                .accStatus("ACTIVE")
                .regId(regId)
                .build();
    }

    private ExcelUploadResult.FailItem validateUserDTO(int row, UserDTO user) {
        if (user.getUserId() == null || user.getUserName() == null) {
            return createFail(row, user.getUserId(), "필수 항목 누락");
        }
        if (userMapper.checkUserId(user.getUserId()) > 0) {
            return createFail(row, user.getUserId(), "중복된 ID");
        }
        if (user.getCompanyCd() != null && userMapper.checkCompanyCd(user.getCompanyCd()) == 0) {
            return createFail(row, user.getUserId(), "존재하지 않는 회사코드");
        }
        
        return null;
    }

    private ExcelUploadResult.FailItem createFail(int rowNum, String userId, String reason) {
        return ExcelUploadResult.FailItem.builder()
                .rowNum(rowNum + 1)
                .userId(userId)
                .reason(reason)
                .build();
    }

    private String getCellValue(Cell cell) {
        if (cell == null) return null;
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue().trim();
            case NUMERIC -> String.valueOf((int) cell.getNumericCellValue());
            default -> null;
        };
    }
	
}
