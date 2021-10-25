<%@ page contentType="text/html; charset=euc-kr" %>
<%@ include file="/view/color.jsp"%>
<html>
<head>
<title>게시판</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="script.js"></script>
</head>

<% 
	String id = (String)session.getAttribute("memId");

  int num=0,ref=1,re_step=0,re_level=0; // 게시글, 답글, 다답글에 각각의 번호를 넣어줄 int 변수
  try{  
    if(request.getParameter("num")!=null){
	num=Integer.parseInt(request.getParameter("num"));
	ref=Integer.parseInt(request.getParameter("ref"));
	re_step=Integer.parseInt(request.getParameter("re_step"));
	re_level=Integer.parseInt(request.getParameter("re_level"));
	}
%>
<% if(id == null){ %>
	<script>
    	alert("로그인 후 사용 가능합니다.");
    	window.location='/ex/member/main.jsp';
    </script>
<%}else{%>

<body bgcolor="<%=bodyback_c%>">  
<center><b>글쓰기</b>
<br>
<form method="post" name="writeform" action="writePro.jsp" onsubmit="return writeSave()">
<input type="hidden" name="num" value="<%=num%>">
<input type="hidden" name="ref" value="<%=ref%>">
<input type="hidden" name="re_step" value="<%=re_step%>">
<input type="hidden" name="re_level" value="<%=re_level%>">

<table width="400" border="1" cellspacing="0" cellpadding="0"  bgcolor="<%=bodyback_c%>" align="center">
   <tr>
    <td align="right" colspan="2" bgcolor="<%=value_c%>">
	    <a href="list.jsp"> 글목록</a> 
   </td>
   </tr>
   <tr>
    <td  width="70"  bgcolor="<%=value_c%>" align="center">이 름</td>
    <td  width="330">
       <%= id %> <input type="hidden" name="writer" value="<%= id %>" /> </td>
  </tr>
  <tr>
    <td  width="70"  bgcolor="<%=value_c%>" align="center" >제 목</td>
    <td  width="330">
    
    <%-- num(개시글 번호)이 null일 시 (처음 작성하는 글일 시) --%>
    <%if(request.getParameter("num")==null){%>
       <input type="text" size="40" maxlength="50" name="subject"></td>
       
    <%-- num(개시글 번호)이 null이 아닐 시 (이미 작성 된 글에 답글을 달 시) --%>
	<%}else{%>
	   <input type="text" size="40" maxlength="50" name="subject" value="[답변]">
	<%}%>
  </tr>
  <tr>
    <td  width="70"  bgcolor="<%=value_c%>" align="center">Email</td>
    <td  width="330">
       <input type="text" size="40" maxlength="30" name="email" ></td>
  </tr>
  <tr>
    <td  width="70"  bgcolor="<%=value_c%>" align="center" >내 용</td>
    <td  width="330" >
     <textarea name="content" rows="13" cols="40"></textarea> </td>
  </tr>
<tr>      
 <td colspan=2 bgcolor="<%=value_c%>" align="center"> 
  <input type="submit" value="글쓰기" >  
  <input type="reset" value="다시작성">
  <input type="button" value="목록보기" OnClick="window.location='list.jsp'">
</td></tr></table>
<%} %> 
<%
  }catch(Exception e){}
%>     
</form>      
</body>
</html>      
