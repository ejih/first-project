<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/view/color.jsp"%>
<html>
<head>
<title>회원가입</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
    
    function checkIt() {
        var userinput = eval("document.userinput");
        if(!userinput.id.value) {
            alert("ID를 입력하세요");
            return false;
        }
        
        if(!userinput.passwd.value ) {
            alert("비밀번호를 입력하세요");
            return false;
        }
        if(userinput.passwd.value != userinput.passwd2.value)
        {
            alert("비밀번호를 동일하게 입력하세요");
            return false;
        }
       
        if(!userinput.username.value) {
            alert("사용자 이름을 입력하세요");
            return false;
        }
        if(!userinput.jumin1.value  || !userinput.jumin2.value )
        {
            alert("주민등록번호를 입력하세요");
            return false;
        }
    }

    // 아이디 중복 여부를 판단
    function openConfirmid(userinput) {
        // 아이디를 입력했는지 검사
        if (userinput.id.value == "") {
            alert("아이디를 입력하세요");
            return;
        }
        // url과 사용자 입력 id를 조합합니다.
        url = "confirmId.jsp?id="+userinput.id.value ;
        
        // 새로운 윈도우를 엽니다.
        open(url, "confirm",  "toolbar=no, location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=300, height=200");
    }
</script>


<body bgcolor="<%=bodyback_c%>">

<form method="post" action="inputPro.jsp" name="userinput" onSubmit="return checkIt()">
  <table width="600" border="1" cellspacing="0" cellpadding="3" align="center" >
    <tr> 
    <td colspan="2" height="39" align="center" bgcolor="<%=value_c%>" >
       <font size="+1" ><b>회원가입</b></font></td>
    </tr>
    <tr> 
      <td width="200" bgcolor="<%=value_c%>"><b>아이디 입력</b></td>
      <td width="400" bgcolor="<%=value_c%>">&nbsp;</td>
    </tr>  

    <tr> 
      <td width="200"> 사용자 ID</td>
      <td width="400"> 
        <input type="text" name="id" size="10" maxlength="12">
        <input type="button" name="confirm_id" value="ID중복확인" 
        							OnClick="openConfirmid(this.form)">
      </td>
    </tr>
    <tr> 
      <td width="200"> 비밀번호</td>
      <td width="400" > 
        <input type="password" name="passwd" size="15" maxlength="12">
      </td>
    <tr>  
      <td width="200">비밀번호 확인</td>
      <td width="400"> 
        <input type="password" name="passwd2" size="15" maxlength="12">
      </td>
    </tr>
    
    <tr> 
      <td width="200" bgcolor="<%=value_c%>"><b>개인정보 입력</b></td>
      <td width="400" bgcolor="<%=value_c%>">&nbsp;</td>
    <tr>  
    <tr> 
      <td width="200">사용자 이름</td>
      <td width="400"> 
        <input type="text" name="name" size="15" maxlength="10">
      </td>
    </tr>
    <tr> 
      <td width="200">주민등록번호</td>
      <td width="400"> 
        <input type="text" name="jumin1" size="7" maxlength="6">
        -<input type="text" name="jumin2" size="7" maxlength="7">
      </td>
    </tr>
    <tr> 
      <td width="200">E-Mail</td>
      <td width="400"> 
        <input type="text" name="email" size="40" maxlength="30">
      </td>
    </tr>
    <tr> 
      <td width="200"> Blog</td>
      <td width="400"> 
        <input type="text" name="blog" size="60" maxlength="50">
      </td>
    </tr>
    <tr> 
      <td colspan="2" align="center" bgcolor="<%=value_c%>"> 
          <input type="submit" name="confirm" value="등   록" >
          <input type="reset" name="reset" value="다시입력">
          <input type="button" value="가입안함" onclick="javascript:window.location='main.jsp'">
      </td>
    </tr>
  </table>
</form>
</body>
</html>
