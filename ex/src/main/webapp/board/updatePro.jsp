<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import = "test.board.Dao" %>
<%@ page import = "test.board.Dto" %>
<%@ page import = "java.sql.Timestamp" %>

<% request.setCharacterEncoding("euc-kr");%>

<jsp:useBean id="article" scope="page" class="test.board.Dto">
   <jsp:setProperty name="article" property="*"/>
</jsp:useBean>
<%
	
    String pageNum = request.getParameter("pageNum");

	Dao dbPro = Dao.getInstance();
    int check = dbPro.updateArticle(article);

    if(check==1){
%>
	  <meta http-equiv="Refresh" content="0;url=list.jsp?pageNum=<%=pageNum%>" >
<% }else{%>
      <script language="JavaScript">      
      <!--      
        alert("비밀번호가 맞지 않습니다");
        history.go(-1);
      -->
     </script>
<%
    }
 %>  

 