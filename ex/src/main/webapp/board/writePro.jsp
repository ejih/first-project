<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import = "test.board.Dao" %>
<%@ page import = "java.sql.Timestamp" %>

<% 
	request.setCharacterEncoding("euc-kr");
%>

<%-- dto °´Ã¼»ý¼º --%>
<jsp:useBean id="article" scope="page" class="test.board.Dto">
   <jsp:setProperty name="article" property="*"/>
</jsp:useBean>
 
<%
	String writer = request.getParameter("writer");
	
	article.setWriter(writer);	

    article.setReg_date(new Timestamp(System.currentTimeMillis()) );
	article.setIp(request.getRemoteAddr());

    Dao dbPro = Dao.getInstance();
    dbPro.insertArticle(article);

    response.sendRedirect("list.jsp");
%>
