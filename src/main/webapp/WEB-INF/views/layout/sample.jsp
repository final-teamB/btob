<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 
    [팀 공통 가이드]
    1. 디자인: Charcoal & White 기반의 미니멀 무채색 스타일
    2. 주요 특징: 
       - 다크모드 대응 (gray-800, gray-700 활용)
       - 텍스트 링크 형태의 '수정/복구' (underline 스타일)
       - 시원한 페이징 여백 (py-10)
--%>
<div class="mx-4 my-6 space-y-6">

    <%-- [1. 타이틀 영역] 제목 및 우측 액션 버튼 --%>
    <div class="px-5 py-4 pb-0 flex flex-col md:flex-row justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">콘텐츠 관리</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">시스템 데이터를 조회하고 관리하는 공간입니다.</p>
        </div>
        <div class="flex items-center space-x-3 mt-4 md:mt-0">
            <button type="button" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700 transition shadow-sm">
                다운로드
            </button>
            <button type="button" class="px-4 py-2 text-sm font-semibold text-white bg-gray-900 rounded-lg shadow-md hover:bg-gray-800 dark:bg-gray-700 dark:hover:bg-gray-600 dark:border dark:border-gray-500 transition-all active:scale-95">
                + 신규 등록
            </button>
        </div>
    </div>

    <%-- [2. 검색 필터 섹션] 조회 및 초기화 --%>
    <section class="p-4 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
        <form class="flex flex-wrap items-end gap-4">
            <div class="relative w-44">
                <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">대상구분</label>
                <select class="w-full rounded-lg border border-gray-300 bg-white py-2 px-4 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-gray-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white">
                    <option value="">전체</option>
                    <option value="user">일반사용자</option>
                    <option value="admin">관리자</option>
                </select>
            </div>
            <div class="relative w-64">
                <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">검색어</label>
                <input type="text" class="w-full rounded-lg border border-gray-300 bg-white py-2 px-4 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-gray-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white" placeholder="내용을 입력하세요">
            </div>
            <div class="flex space-x-2">
                <button type="submit" class="px-5 py-2 text-sm font-medium text-white bg-gray-900 rounded-lg hover:bg-gray-800 dark:bg-gray-700 dark:hover:bg-gray-600 dark:border dark:border-gray-500 transition-all shadow-sm">
                    조회
                </button>
                <button type="reset" class="px-5 py-2 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-300 transition border dark:border-gray-600">초기화</button>
            </div>
        </form>
    </section>

    <%-- [3. 데이터 리스트 섹션] --%>
    <section class="bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full leading-normal">
                <thead>
                    <tr class="bg-gray-50 dark:bg-gray-700 text-gray-500 dark:text-gray-400 text-xs font-bold uppercase tracking-wider">
                        <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-left">대상</th>
                        <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-left">구분</th>
                        <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-left">날짜</th>
                        <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-left">상태</th>
                        <th class="px-5 py-3 border-b border-gray-100 dark:border-gray-700 text-center">관리</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-gray-700">
                    <tr class="hover:bg-gray-50 dark:hover:bg-gray-700/50 transition">
                        <td class="px-5 py-4 text-sm text-left">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 w-10 h-10">
                                    <img class="w-full h-full rounded-full border border-gray-200 dark:border-gray-600" src="https://ui-avatars.com/api/?name=User&background=f3f4f6&color=6b7280" alt="">
                                </div>
                                <div class="ml-3 text-left">
                                    <p class="text-gray-900 dark:text-white font-medium">홍길동</p>
                                    <p class="text-[11px] text-gray-400 font-normal">gildong@test.com</p>
                                </div>
                            </div>
                        </td>
                        <td class="px-5 py-4 text-sm text-gray-600 dark:text-gray-400 font-medium text-left">일반사용자</td>
                        <td class="px-5 py-4 text-sm text-gray-600 dark:text-gray-400 text-left">2024-01-29</td>
                        <td class="px-5 py-4 text-left">
                            <span class="relative inline-block px-3 py-1 font-bold leading-tight text-green-900 text-xs">
                                <span aria-hidden="true" class="absolute inset-0 bg-green-200 rounded-full opacity-50"></span>
                                <span class="relative">Active</span>
                            </span>
                        </td>
                        <td class="px-5 py-4 text-sm text-center font-bold">
                            <%-- 수정 버튼: 텍스트 언더라인 형태 --%>
                            <a href="#" class="text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition underline underline-offset-4">수정</a>
                        </td>
                    </tr>
                    <tr class="hover:bg-gray-50 dark:hover:bg-gray-700/50 transition">
                        <td class="px-5 py-4 text-sm text-left">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 w-10 h-10">
                                    <img class="w-full h-full rounded-full border border-gray-200 dark:border-gray-600" src="https://ui-avatars.com/api/?name=User&background=f3f4f6&color=6b7280" alt="">
                                </div>
                                <div class="ml-3 text-left">
                                    <p class="text-gray-900 dark:text-white font-medium">김철수</p>
                                    <p class="text-[11px] text-gray-400 font-normal">chulsoo@test.com</p>
                                </div>
                            </div>
                        </td>
                        <td class="px-5 py-4 text-sm text-gray-600 dark:text-gray-400 font-medium text-left">관리자</td>
                        <td class="px-5 py-4 text-sm text-gray-600 dark:text-gray-400 text-left">2024-01-28</td>
                        <td class="px-5 py-4 text-left">
                            <span class="relative inline-block px-3 py-1 font-bold leading-tight text-red-900 text-xs">
                                <span aria-hidden="true" class="absolute inset-0 bg-red-200 rounded-full opacity-50"></span>
                                <span class="relative">Inactive</span>
                            </span>
                        </td>
                        <td class="px-5 py-4 text-sm text-center font-bold">
                            <%-- 복구 버튼: 텍스트 언더라인 형태 --%>
                            <a href="#" class="text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition underline underline-offset-4">복구</a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <%-- [4. 페이징 영역] --%>
        <div class="px-5 py-10 flex justify-center bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
            <div class="inline-flex items-center -space-x-px shadow-sm">
                <button type="button" class="p-4 text-base text-gray-600 bg-white border border-gray-300 rounded-l-xl hover:bg-gray-100 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700 transition">
                    <svg width="9" height="8" fill="currentColor" viewBox="0 0 1792 1792"><path d="M1427 301l-531 531 531 531q19 19 19 45t-19 45l-166 166q-19 19-45 19t-45-19l-742-742q-19-19-19-45t19-45l742-742q19-19 45-19t45 19l166 166q19 19 19 45t-19 45z"></path></svg>
                </button>
                <button type="button" class="px-4 py-2 text-base text-gray-900 bg-gray-100 border border-gray-300 font-bold dark:bg-gray-700 dark:text-white dark:border-gray-600">
                    1
                </button>
                <button type="button" class="px-4 py-2 text-base text-gray-600 bg-white border border-gray-300 hover:bg-gray-100 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700 transition">
                    2
                </button>
                <button type="button" class="p-4 text-base text-gray-600 bg-white border border-gray-300 rounded-r-xl hover:bg-gray-100 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700 transition">
                    <svg width="9" height="8" fill="currentColor" viewBox="0 0 1792 1792"><path d="M1363 877l-742 742q-19 19-45 19t-45-19l-166-166q-19-19-19-45t19-45l531-531-531-531q-19-19-19-45t19-45l166-166q19-19 45-19t45 19l742 742q19 19 19 45t-19 45z"></path></svg>
                </button>
            </div>
        </div>
    </section>
</div>