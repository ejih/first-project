<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import = "test.member.Dao" %>
<%@ page import = "test.member.Dto" %>
<%@ page import = "java.sql.Timestamp" %>

<% request.setCharacterEncoding("euc-kr");%>

<jsp:useBean id="member" class="test.member.Dto">
    <jsp:setProperty name="member" property="*" />
</jsp:useBean>

<%
    member.setReg_date(new Timestamp(System.currentTimeMillis()) );
	Dao manager = Dao.getInstance();
    manager.insertMember(member);

    response.sendRedirect("loginForm.jsp");
%>