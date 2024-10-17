<%@ page import="java.sql.Connection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="org.apache.tomcat.dbcp.dbcp2.BasicDataSource" %>
<%@ page import="org.apache.tomcat.dbcp.dbcp2.PoolableConnection" %>
<%@ page import="org.apache.tomcat.dbcp.pool2.impl.GenericObjectPool" %>
<html>
  <head>
    <title>Connect 1 min</title>
  </head>
  <body>
<h3>DataSource class</h3>
<%
  Logger logger = Logger.getLogger("index.jsp");
  Context initialContext = new InitialContext();
  Context envContext = (Context)initialContext.lookup("java:comp/env");
  DataSource dataSource = (DataSource)envContext.lookup("jdbc/TestDB");
  out.println(dataSource.getClass().getName());
  Connection connection = dataSource.getConnection();
  Thread.sleep(60*1000);
  connection.close();
%>
</body>
</html>