import java.util.*;   
import java.util.Date;
import java.text.*;   
import java.util.Calendar; 
import java.nio.charset.Charset;
import java.sql.*;
import com.jack.util.Base64;
import com.jack.util.LogScreen;
import java.io.*;
import empp.*;

public class Mes {

  public static void main(String[] args) throws IOException, SQLException, IllegalAccessException {
  	String mes_id="";
  	String contents="";
  	if (args.length>0){
  	  mes_id=args[0];
  	}
  	else{
  	  mes_id="26";
  	}
  	if (sql_check_3(mes_id)==false){
  		System.out.println("调用传入非法参数");
  		return;
  	}
  	PrintStream out = null;
	PrintStream err = null;
  	out = new PrintStream(new FileOutputStream("./out.log"), true);
	err = new PrintStream(new FileOutputStream("./err.log"), true);
	System.setOut(out);
	System.setErr(err);
	System.out.println("start");
  	java.io.File   f   =   new   java.io.File("./conf.properties");   
  	java.util.Properties   pro=new   java.util.Properties();  
    java.io.FileInputStream   fis;
	try {
		fis = new   java.io.FileInputStream(f);	
		pro.load(fis);
		fis.close(); 
	} catch (FileNotFoundException e) {
		e.printStackTrace();
	}
    String mes_username=pro.getProperty("mes_username");   
    String mes_password=pro.getProperty("mes_password");  
    String database_username=pro.getProperty("database_username");   
    String database_password=pro.getProperty("database_password");   
    
    PreparedStatement pstmt = null;
    PreparedStatement pstmt_2 = null;
    ResultSet rst=null ;
    
	String url="jdbc:mysql://localhost:3306/zc";
	String uid=database_username;
	String pwd=database_password; 
    
	Connection con = null;
	empp.EmppClient empp=null;
    try {
	  Class.forName("org.gjt.mm.mysql.Driver").newInstance();
	  con = DriverManager.getConnection(url,uid,pwd);
	  pstmt=con.prepareStatement("select * from tb_sms_alerts where send_state<>900 and  id in("+mes_id+") order by id");
	  rst= pstmt.executeQuery();
	  try {
	    empp = new EmppClient();
	    if (empp.connect("61.144.225.60", 8900)){
	    	if (empp.login(mes_username, mes_password)){//mes_password
	    	  //System.out.println(mes_username);
	    	  //System.out.println(mes_password);
	    	  while (rst.next()){
	    	    //发送短信内容
	    	  	  contents=rst.getString("contents");
	    	      contents=contents.replaceAll("\n\r","");
	    	      contents=contents.replaceAll("\n","");
	    	      contents=contents.replaceAll("\r","");
	    	      System.out.println(rst.getString("mobiletel")); 
	    	      System.out.println(contents); 
	    	      if (empp.sendSms(rst.getString("mobiletel"), contents)){
	    	        pstmt=con.prepareStatement("update tb_sms_alerts set send_state=900 where id=?");
	    	        pstmt.setInt(1,rst.getInt("id")); 
	    	        pstmt.execute();
	    	      }
	    	      else{
	    	        pstmt=con.prepareStatement("update tb_sms_alerts set send_state=200 where id=?");
	    	        pstmt.setInt(1,rst.getInt("id")); 
	    	       pstmt.execute();
	    	       System.out.println("id:"+ String.valueOf(rst.getInt("id")) +  ",信息发送失败");
	    	      }
 
	    	  }
	    	}
	    	else{
	    		System.out.println("login失败");
	    	}
	    }
	    else{
	    	System.out.println("connect失败");
	    }
	  } catch (Exception e1) {
	  	e1.printStackTrace();
	  }
	  finally{
	  	if (empp != null) {
	  	  empp.quit();
	  	}
	  }
	}
	catch (Exception e1) {
	  e1.printStackTrace();
	}
    finally {
		if (pstmt != null) {
            try { pstmt.close(); } catch (SQLException e) { ; }
            pstmt = null;
         }
		if (pstmt_2 != null) {
            try { pstmt_2.close(); } catch (SQLException e) { ; }
            pstmt_2 = null;
         }
        if (con != null) {
            try { con.close(); } catch (SQLException e) { ; }
            con = null;
         }
		 if (rst != null) {
            try { rst.close(); } catch (SQLException e) { ; }
            rst = null;
         }
	}
    
    
  }
  
  
  
  public static String getStringDate() {   
    Date currentTime = new Date();   
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");   
    String dateString = formatter.format(currentTime);   
    return dateString;   
   }
  
  public static boolean sql_check_3(String sq){
    sq=sq.toLowerCase();
    String ss[];
    ss=new String[7];
    ss[0]="exec";
    ss[1]="insert";
    ss[2]="delete";
    ss[3]="update";
    ss[4]="master";
    ss[5]="truncate";
    ss[6]="declare";
    int ii;
    for (ii=0;ii<7;ii++){ 
      if (sq.indexOf(ss[ii])!=-1){
        return false;
      }
    }
    return true;
  }
}