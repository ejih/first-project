<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
		*{
			text-align:center;
		 }
</style>
<h1>마이페이지</h1><br /><br />
<% 	String id = (String)session.getAttribute("id");%>
	<h2> [<%=id %>] 님.</h2>										
	<input type="button" value="로그아웃"  /> 
	<input type="button" value="정보수정" />
	<input type="button" value="탈퇴" 	/>

