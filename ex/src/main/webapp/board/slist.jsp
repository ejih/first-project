<%@ page contentType = "text/html; charset=euc-kr" %>
<%@ page import = "test.board.Dao" %>
<%@ page import = "test.board.Dto" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ include file="/view/color.jsp"%>

<%!
    int pageSize = 10; // �� �������� ������ ���ù� ����
    SimpleDateFormat sdf = 
        new SimpleDateFormat("yyyy-MM-dd HH:mm"); // �ۼ���¥�� ��/��/�� ��:�� ���� ǥ��
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

    // �Խñ��� 10���� �Ѿ ��� �������� �ø�
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
	        	���� �� �ڵ� (NullPointException �߻�)
	        	articleList = dbPro.getArticles(startRow, pageSize);
	        	
	        	pageSize�� endRow�� �ٲ� ���� �ذ�
	        */
	    }
    }
	    

	number=count-(currentPage-1)*pageSize;
%>
<html>
<head>
<title>�Խ���</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="<%=bodyback_c%>">
<center><b>�۸��(��ü ��:<%=count%>)</b>
<table width="700">
		<tr>
		<td align="right" bgcolor="<%=value_c%>" style="height:20px;">
		<% if(id != null){ %>
		   		<a href="list.jsp?my=1">���� �ۼ���</a>
		    </td>
		    <td align="right" bgcolor="<%=value_c%>" style="height:20px;">
		   		<a href="writeForm.jsp">�۾���</a>
		    </td>
		     
	<%} %>
</table>

<%
    if (count == 0) {
%>
<table width="700" border="1" cellpadding="0" cellspacing="0">
<tr>
    <td align="center">
    �Խ��ǿ� ����� ���� �����ϴ�.
    </td>
</table>

<%  } else {    %>
<table border="1" width="700" cellpadding="0" cellspacing="0" align="center"> 
    <tr height="30" bgcolor="<%=value_c%>"> 
      <td align="center"  width="50"  >�� ȣ</td> 
      <td align="center"  width="250" >��   ��</td> 
      <td align="center"  width="100" >�ۼ���</td>
      <td align="center"  width="150" >�ۼ���</td> 
      <td align="center"  width="50" >�� ȸ</td> 
      <td align="center"  width="100" >IP</td>    
    </tr>
<%  
		// ������ �̵��� ���� �߻�
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
			    	<option value="writer"> �ۼ��� </option>
			    	<option value="subject"> ���� </option>
			    	<option value="content"> ���� </option>
			    </select>
			    <input type="text" name="search" />
			    <input type="submit" value="�˻�" />
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
        <a href="list.jsp?pageNum=<%= startPage - 10 %>">[����]</a>
<%      }
        for (int i = startPage ; i <= endPage ; i++) {  %>
        <a href="list.jsp?pageNum=<%= i %>">[<%= i %>]</a>
<%
        }
        if (endPage < pageCount) {  %>
        <a href="list.jsp?pageNum=<%= startPage + 10 %>">[����]</a>
<%
        }
    }
%>
</center>
</body>
</html>