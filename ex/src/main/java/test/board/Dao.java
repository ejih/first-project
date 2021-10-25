package test.board;
import java.sql.*;
import java.util.*; 

public class Dao {

	private static Dao instance = new Dao();
	
	public static Dao getInstance() {
		return instance;
	
	}
	private Dao() {}
	
	private Connection getConnection() throws Exception {
		Class.forName("oracle.jdbc.driver.OracleDriver"); 
		String url = "jdbc:oracle:thin:@masternull.iptime.org:1521:orcl";
		String user ="java18";
		String pw = "java";
		Connection conn = DriverManager.getConnection(url,user,pw);  
		return conn;
	}
	
	// 글 작성
	public void insertArticle(Dto article) throws Exception {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int num=article.getNum();
		int ref=article.getRef();
		int re_step=article.getRe_step();
		int re_level=article.getRe_level();
		int number=0;
		String sql="";
		try {
			conn = getConnection(); 
			
			// DataBase에 등록되어있는 게시글 중 num이 가장 큰 개시글을 검색
			pstmt = conn.prepareStatement("select max(num) from board"); 
			rs = pstmt.executeQuery();
			
			// 게시글이 이미 있다면 그 게시글의 num에 +1을 하고
			if (rs.next()) 
				number=rs.getInt(1)+1;	
			// 게시글이 없다(null)면 1이라는 number를 대입
			else
				number=1; 
			
			// 게시글의 숫자가 0이 아니라면 re_step, re_level(게시글 그룹)에 +1씩 더함
			if (num!=0) 
			{ 
				sql="update board set re_step=re_step+1 where ref= ? and re_step> ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, re_step);
				pstmt.executeUpdate();
				re_step=re_step+1;
				re_level=re_level+1;
			// 게시글의 숫자가 0이라면 re_setp, re_level에 0을 대입
			}else{ 
				ref=number;
				re_step=0;
				re_level=0;
			}
 
			sql = "insert into board(num,writer,email,subject,passwd,reg_date,";
			sql+="ref,re_step,re_level,content,ip) values(board_seq.NEXTVAL,?,?,?,?,?,?,?,?,?,?)";
				pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getWriter());
			pstmt.setString(2, article.getEmail());
			pstmt.setString(3, article.getSubject());
			pstmt.setString(4, article.getPasswd());
			pstmt.setTimestamp(5, article.getReg_date());
			pstmt.setInt(6, ref);
			pstmt.setInt(7, re_step);
			pstmt.setInt(8, re_level);
			pstmt.setString(9, article.getContent());
			pstmt.setString(10, article.getIp());
			pstmt.executeUpdate();
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
	}
	
	// 게시글 갯수를 검색
	public int getArticleCount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int x=0;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select count(*) from board");
			rs = pstmt.executeQuery();
			if (rs.next()) {
				x= rs.getInt(1); 
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
		return x; 
	}

	// 게시글 목록 표시
	public List<Dto> getArticles(int start, int end) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Dto> articleList=null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(
					"select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount,r "+
					"from (select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount,rownum r " +
					"from (select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount " +
					"from board order by ref desc, re_step asc) order by ref desc, re_step asc ) where r >= ? and r <= ? ");
					pstmt.setInt(1, start); 
					pstmt.setInt(2, end); 

					rs = pstmt.executeQuery();
					if (rs.next()) {
						articleList = new ArrayList(end); 
						do{ 
							Dto article= new Dto();
							article.setNum(rs.getInt("num"));
							article.setWriter(rs.getString("writer"));
							article.setEmail(rs.getString("email"));
							article.setSubject(rs.getString("subject"));
							article.setPasswd(rs.getString("passwd"));
							article.setReg_date(rs.getTimestamp("reg_date"));
							article.setReadcount(rs.getInt("readcount"));
							article.setRef(rs.getInt("ref"));
							article.setRe_step(rs.getInt("re_step"));
							article.setRe_level(rs.getInt("re_level"));
							article.setContent(rs.getString("content"));
							article.setIp(rs.getString("ip"));
							articleList.add(article); 
						}while(rs.next());
					}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}

		
		return articleList;
	}
	
	// 작성자의 게시글 갯수
	public int getMyArticleCount(String writer) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int x=0;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(
					"select count(*) from board where writer = ?");
			pstmt.setString(1, writer);
			
			rs = pstmt.executeQuery();
			if (rs.next()) {
				x= rs.getInt(1); 
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
		return x; 
	}
	
	// 작성자의 게시글 목록 표시
	public List<Dto> getMyArticles(String writer, int start, int end) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Dto> articleList=null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(
					"select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount,r "+
					"from (select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount,rownum r " +
					"from (select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount " +
					"from board where writer = ? order by ref desc, re_step asc)) where r >= ? and r <= ? ");
					
			pstmt.setString(1, writer);
			pstmt.setInt(2, start); 
			pstmt.setInt(3, end); 
			
			rs = pstmt.executeQuery();
			if (rs.next()) {
				articleList = new ArrayList(end); 
				do{ 
					Dto article= new Dto();
					article.setNum(rs.getInt("num"));
					article.setWriter(rs.getString("writer"));
					article.setEmail(rs.getString("email"));
					article.setSubject(rs.getString("subject"));
					article.setPasswd(rs.getString("passwd"));
					article.setReg_date(rs.getTimestamp("reg_date"));
					article.setReadcount(rs.getInt("readcount"));
					article.setRef(rs.getInt("ref"));
					article.setRe_step(rs.getInt("re_step"));
					article.setRe_level(rs.getInt("re_level"));
					article.setContent(rs.getString("content"));
					article.setIp(rs.getString("ip"));
					articleList.add(article); 
				}while(rs.next());
			}
						
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
			
		return articleList;
	}
	
	// 게시글 수정
	public Dto getArticle(int num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Dto article=null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(
			"update board set readcount=readcount+1 where num = ?"); 
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			pstmt = conn.prepareStatement(
			"select * from board where num = ?"); 
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				article = new Dto();
				article.setNum(rs.getInt("num"));
				article.setWriter(rs.getString("writer"));
				article.setEmail(rs.getString("email"));
				article.setSubject(rs.getString("subject"));
				article.setPasswd(rs.getString("passwd"));
				article.setReg_date(rs.getTimestamp("reg_date"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getInt("re_level"));
				article.setContent(rs.getString("content"));
				article.setIp(rs.getString("ip"));
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
		
		return article;
	}
	
	// 게시글 수정내용 작성
	public Dto updateGetArticle(int num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Dto article=null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(
			"select * from board where num = ?"); 
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				article = new Dto();
				article.setNum(rs.getInt("num"));
				article.setWriter(rs.getString("writer"));
				article.setEmail(rs.getString("email"));
				article.setSubject(rs.getString("subject"));
				article.setPasswd(rs.getString("passwd"));
				article.setReg_date(rs.getTimestamp("reg_date"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getInt("re_level"));
				article.setContent(rs.getString("content"));
				article.setIp(rs.getString("ip"));
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}

		return article;
	}
	
	// 게시글 수정내용 저장
	public int updateArticle(Dto article) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs= null;
		String dbpasswd="";
		String sql="";
		int x=0;
		try {
			conn = getConnection();
//			pstmt = conn.prepareStatement(
//			"select passwd from board where num = ?");
//			pstmt.setInt(1, article.getNum());
//			rs = pstmt.executeQuery();
//			if(rs.next()){
//				dbpasswd= rs.getString("passwd"); // String으로 입력받은 passwd가 같으면
//				if(dbpasswd.equals(article.getPasswd())){
//					sql="update board set writer=?,email=?,subject=?,passwd=?";
//					sql+=",content=? where num=?";
//					pstmt = conn.prepareStatement(sql);
//					pstmt.setString(1, article.getWriter());
//					pstmt.setString(2, article.getEmail());
//					pstmt.setString(3, article.getSubject());
//					pstmt.setString(4, article.getPasswd());
//					pstmt.setString(5, article.getContent());
//					pstmt.setInt(6, article.getNum());
//					pstmt.executeUpdate();
//					x= 1; // 같으면 int x 에 1 대입
//				}else{
//					x= 0; // 다르면 int x 에 0 대입
//				}
			pstmt = conn.prepareStatement(
					"update board set writer = ?,email = ?,subject = ?, "
					+" content = ? where num = ?");
			
			pstmt.setString(1, article.getWriter());
			pstmt.setString(2, article.getEmail());
			pstmt.setString(3, article.getSubject());
			pstmt.setString(4, article.getContent());
			pstmt.setInt(5, article.getNum());
			
			x = pstmt.executeUpdate();
				
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
		return x;
	}
	
	// 게시글 삭제
	public int deleteArticle(int num) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs= null;
		String dbpasswd="";
		int x=0;
		try {
//			conn = getConnection();
//			pstmt = conn.prepareStatement(
//			"select passwd from board where num = ?"); // num의 게시글의 비밀번호 검색
//			pstmt.setInt(1, num);
//			rs = pstmt.executeQuery();
//			if(rs.next()){
//				dbpasswd= rs.getString("passwd"); 
//				if(dbpasswd.equals(passwd)){ // DataBase에 있는 passwd와 입력받은 passwd가 같을 때
//					pstmt = conn.prepareStatement(
//					"delete from board where num=?");
//					pstmt.setInt(1, num);
//					pstmt.executeUpdate();
//					x= 1; // 같으면 int x 에 1 대입
//				}else
//					x= 0; // 다르면 int x 에 0 대입
//			}
			
			conn = getConnection();
			pstmt = conn.prepareStatement(
					"delete from board where num = ?");
			pstmt.setInt(1, num);
			x = pstmt.executeUpdate();
			
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
		return x;
	}
	
	// 게시글 검색
	public int getSearchArticleCount(String colum, String search) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int x=0;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(
					"select count(*) from board "
							+ "where "+colum+" like '%"+search+"%'");
			rs = pstmt.executeQuery();
			if (rs.next()) {
				x= rs.getInt(1); 
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
		return x; 
	}
	
	// 검색된 게시글 표시
	public List getSearchArticles(String colum, String search, int start, int end) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List articleList=null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(
					"select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount,r "+
					"from (select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount,rownum r " +
					"from (select num,writer,email,subject,passwd,reg_date,ref,re_step,re_level,content,ip,readcount " +
					"from board where "+colum+" like '%"+search+"%' order by ref desc, re_step asc) order by ref desc, re_step asc ) where r >= ? and r <= ? ");
					pstmt.setInt(1, start); 
					pstmt.setInt(2, end); 

					rs = pstmt.executeQuery();
					if (rs.next()) {
						articleList = new ArrayList(end); 
						do{ 
							Dto article= new Dto();
							article.setNum(rs.getInt("num"));
							article.setWriter(rs.getString("writer"));
							article.setEmail(rs.getString("email"));
							article.setSubject(rs.getString("subject"));
							article.setPasswd(rs.getString("passwd"));
							article.setReg_date(rs.getTimestamp("reg_date"));
							article.setReadcount(rs.getInt("readcount"));
							article.setRef(rs.getInt("ref"));
							article.setRe_step(rs.getInt("re_step"));
							article.setRe_level(rs.getInt("re_level"));
							article.setContent(rs.getString("content"));
							article.setIp(rs.getString("ip"));
							articleList.add(article); 
						}while(rs.next());
					}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null) try { rs.close(); } catch(SQLException ex) {}
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}

		
		return articleList;
	}
}