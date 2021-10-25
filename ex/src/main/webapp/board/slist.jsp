<%@ page contentType = "text/html; charset=euc-kr" %>
<%@ page import = "test.board.Dao" %>
<%@ page import = "test.board.Dto" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ include file="/view/color.jsp"%>

<%!
    int pageSize = 10; // 한 페이지에 보여질 개시물 갯수
    SimpleDateFormat sdf = 
        new SimpleDateFormat("yyyy-MM-dd HH:mm"); // 작성날짜를 년/월/일 시:분 으로 표시
%>

<%
	request.setCharacterEncoding("euc-kr");

	String id = (String)session.getAttribute("memId");

	String colum = request.getParameter("colum");
	String search = request.getParameter("search");

	String my = request.getParameter("my");
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null) {
        pageNum = "1";
    }

    // 게시글이 10개가 넘어갈 경우 페이지를 늘림
    int currentPage = Integer.parseInt(pageNum);
    int startRow = (currentPage - 1) * pageSize + 1;
    int endRow = currentPage * pageSize;
    int count = 0;
    int number=0;

    Dao dbPro = Dao.getInstance();
    List<Dto> articleList = null;
    if(my == null){
    	count = dbPro.getSearchArticleCount(colum, search);
	    if (count > 0) {
	        articleList = dbPro.getSearchArticles(colum, search, startRow, endRow);
	        /* 
	        	수정 전 코드 (NullPointException 발생)
	        	articleList = dbPro.getArticles(startRow, pageSize);
	        	
	        	pageSize를 endRow로 바꿔 오류 해결
	        */
	    }
    }
	    

	number=count-(currentPage-1)*pageSize;
%>
<html>
<head>
<title>게시판</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="<%=bodyback_c%>">
<center><b>글목록(전체 글:<%=count%>)</b>
<table width="700">
		<tr>
		<td align="right" bgcolor="<%=value_c%>" style="height:20px;">
		<% if(id != null){ %>
		   		<a href="list.jsp?my=1">나의 작성글</a>
		    </td>
		    <td align="right" bgcolor="<%=value_c%>" style="height:20px;">
		   		<a href="writeForm.jsp">글쓰기</a>
		    </td>
		     
	<%} %>
</table>

<%
    if (count == 0) {
%>
<table width="700" border="1" cellpadding="0" cellspacing="0">
<tr>
    <td align="center">
    게시판에 저장된 글이 없습니다.
    </td>
</table>

<%  } else {    %>
<table border="1" width="700" cellpadding="0" cellspacing="0" align="center"> 
    <tr height="30" bgcolor="<%=value_c%>"> 
      <td align="center"  width="50"  >번 호</td> 
      <td align="center"  width="250" >제   목</td> 
      <td align="center"  width="100" >작성자</td>
      <td align="center"  width="150" >작성일</td> 
      <td align="center"  width="50" >조 회</td> 
      <td align="center"  width="100" >IP</td>    
    </tr>
<%  
		// 페이지 이동시 오류 발생
        for (int i = 0 ; i < articleList.size() ; i++) {
          Dto article = (Dto)articleList.get(i);
%>
   <tr height="30">
    <td align="center"  width="50" > <%=number--%></td>
    <td  width="250" >
	<%
	      int wid=25; 
	      if(article.getRe_level()>0){
	        wid=25*(article.getRe_level());
	%>
	  <img src="images/level.gif" width="<%=wid%>" height="16">
	  <img src="images/re.gif">
	<%}else{%>
	  <img src="images/level.gif" width="<%=wid%>" height="16">
	<%}%>
           
      <a href="content.jsp?num=<%=article.getNum()%>&pageNum=<%=currentPage%>">
           <%=article.getSubject()%></a> 
           
          <% if(article.getReadcount()>=20){%>
         <img src="images/hot.gif" border="0"  height="16"><%}%> </td>
         
    <td align="center"  width="100"> 
       <a href="mailto:<%=article.getEmail()%>"><%=article.getWriter()%></a></td>
    <td align="center"  width="150"><%= sdf.format(article.getReg_date())%></td>
    <td align="center"  width="50"><%=article.getReadcount()%></td>
    <td align="center" width="100" ><%=article.getIp()%></td>
  </tr>
     <%}%>
   <tr>  
   		<td colspan="6">
		     <form action="slist.jsp" method="post">
			    <select name="colum">
			    	<option value="writer"> 작성자 </option>
			    	<option value="subject"> 제목 </option>
			    	<option value="content"> 내용 </option>
			    </select>
			    <input type="text" name="search" />
			    <input type="submit" value="검색" />
			</form>
		</td>
     </tr>
</table>
<%}%>

<%
    if (count > 0) {
        int pageCount = count / pageSize + ( count % pageSize == 0 ? 0 : 1);
		 
        int startPage = (int)(currentPage/10)*10+1;
		int pageBlock=10;
        int endPage = startPage + pageBlock-1;
        if (endPage > pageCount) endPage = pageCount;
        
        if (startPage > 10) {    %>
        <a href="list.jsp?pageNum=<%= startPage - 10 %>">[이전]</a>
<%      }
        for (int i = startPage ; i <= endPage ; i++) {  %>
        <a href="list.jsp?pageNum=<%= i %>">[<%= i %>]</a>
<%
        }
        if (endPage < pageCount) {  %>
        <a href="list.jsp?pageNum=<%= startPage + 10 %>">[다음]</a>
<%
        }
    }
%>
</center>
</body>
</html>