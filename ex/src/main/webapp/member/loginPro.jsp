<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import = "test.member.Dao" %>
<%@ page import = "test.member.Dto" %>

<% request.setCharacterEncoding("euc-kr");%>

<%
    String id = request.getParameter("id");
	String passwd  = request.getParameter("passwd");
	
	Dao manager = Dao.getInstance();
	
    int check= manager.userCheck(id,passwd);

	if(check==1){
		session.setAttribute("memId",id);
		response.sendRedirect("main.jsp");
	}else if(check==0){%>
	<script> 
	  alert("��й�ȣ�� ���� �ʽ��ϴ�.");
      history.go(-1);
	</script>
<%	}else{ %>
	<script>
	  alert("���̵� ���� �ʽ��ϴ�..");
	  history.go(-1);
	</script>
<%}	%>	