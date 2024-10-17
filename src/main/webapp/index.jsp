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
    <title>DataSource Info</title>
  </head>
  <body>
<h3>DataSource class</h3>
<%
  Logger logger = Logger.getLogger("index.jsp");
  Context initialContext = new InitialContext();
  Context envContext = (Context)initialContext.lookup("java:comp/env");
  DataSource dataSource = (DataSource)envContext.lookup("jdbc/TestDB");
  out.println(dataSource.getClass().getName());
%>
<h3>Attributes</h3>
<pre><%
  if (dataSource instanceof org.apache.tomcat.dbcp.dbcp2.BasicDataSource) {
    BasicDataSource basicDataSource = (BasicDataSource)dataSource;
    // https://tomcat.apache.org/tomcat-10.1-doc/api/org/apache/tomcat/dbcp/dbcp2/BasicDataSource.html
    out.println(String.format("defaultAutoCommit = \"%s\"", basicDataSource.getDefaultAutoCommit()));
    out.println(String.format("defaultReadOnly = \"%s\"", basicDataSource.getDefaultReadOnly()));
    out.println(String.format("defaultTransactionIsolation = \"%s\"", basicDataSource.getDefaultTransactionIsolation()));
    out.println(String.format("defaultCatalog = \"%s\"", basicDataSource.getDefaultCatalog()));
    out.println(String.format("cacheState = \"%s\"", basicDataSource.getCacheState()));
    out.println(String.format("defaultQueryTimeout = \"%s\"", basicDataSource.getDefaultQueryTimeout()));
    out.println(String.format("enableAutoCommitOnReturn = \"%s\"", basicDataSource.getAutoCommitOnReturn()));
    out.println(String.format("rollbackOnReturn = \"%s\"", basicDataSource.getRollbackOnReturn()));
    out.println();
    out.println(String.format("initialSize = \"%d\"", basicDataSource.getInitialSize()));
    out.println(String.format("maxTotal = \"%d\"", basicDataSource.getMaxTotal()));
    out.println(String.format("maxIdle = \"%d\"", basicDataSource.getMaxIdle()));
    out.println(String.format("minIdle = \"%d\"", basicDataSource.getMinIdle()));
    out.println(String.format("maxWaitMillis = \"%d\"", basicDataSource.getMaxWaitMillis()));
    out.println();
    out.println(String.format("validationQuery = \"%s\"", basicDataSource.getValidationQuery()));
    out.println(String.format("validationQueryTimeout = \"%d\"", basicDataSource.getValidationQueryTimeout()));
    out.println(String.format("testOnCreate = \"%s\"", basicDataSource.getTestOnCreate()));
    out.println(String.format("testOnBorrow = \"%s\"", basicDataSource.getTestOnBorrow()));
    out.println(String.format("testOnReturn = \"%s\"", basicDataSource.getTestOnReturn()));
    out.println(String.format("testWhileIdle = \"%s\"", basicDataSource.getTestWhileIdle()));
    out.println(String.format("timeBetweenEvictionRunsMillis = \"%s\"", basicDataSource.getTimeBetweenEvictionRunsMillis()));
    out.println();
  }
  else if (dataSource instanceof org.apache.tomcat.jdbc.pool.DataSource) {
    org.apache.tomcat.jdbc.pool.DataSource tomcatJdbcDataSource = (org.apache.tomcat.jdbc.pool.DataSource)dataSource;
    // https://tomcat.apache.org/tomcat-10.1-doc/jdbc-pool.html#Common_Attributes
    out.println(String.format("defaultAutoCommit = \"%s\"", tomcatJdbcDataSource.getDefaultAutoCommit()));
    out.println(String.format("defaultReadOnly = \"%s\"", tomcatJdbcDataSource.getDefaultReadOnly()));
    out.println(String.format("defaultTransactionIsolation = \"%s\"", tomcatJdbcDataSource.getDefaultTransactionIsolation()));
    out.println(String.format("defaultCatalog = \"%s\"", tomcatJdbcDataSource.getDefaultCatalog()));

    out.println(String.format("commitOnReturn (enableAutoCommitOnReturn) = \"%s\"", tomcatJdbcDataSource.getCommitOnReturn()));
    out.println(String.format("rollbackOnReturn = \"%s\"", tomcatJdbcDataSource.getRollbackOnReturn()));
    out.println();
    out.println(String.format("initialSize = \"%d\"", tomcatJdbcDataSource.getInitialSize()));
    out.println(String.format("maxActive (maxTotal) = \"%d\"", tomcatJdbcDataSource.getMaxActive()));
    out.println(String.format("maxIdle = \"%d\"", tomcatJdbcDataSource.getMaxIdle()));
    out.println(String.format("minIdle = \"%d\"", tomcatJdbcDataSource.getMinIdle()));
    out.println(String.format("maxWait (maxWaitMillis) = \"%d\"", tomcatJdbcDataSource.getMaxWait()));
    out.println();
    out.println(String.format("validationQuery = \"%s\"", tomcatJdbcDataSource.getValidationQuery()));
    out.println(String.format("validationQueryTimeout = \"%d\"", tomcatJdbcDataSource.getValidationQueryTimeout()));
    out.println(String.format("testOnConnect (testOnCreate) = \"%s\"", tomcatJdbcDataSource.isTestOnConnect()));
    out.println(String.format("testOnBorrow = \"%s\"", tomcatJdbcDataSource.isTestOnBorrow()));
    out.println(String.format("testOnReturn = \"%s\"", tomcatJdbcDataSource.isTestOnReturn()));
    out.println(String.format("testWhileIdle = \"%s\"", tomcatJdbcDataSource.isTestWhileIdle()));
    out.println();

    out.println(String.format("tomcatJdbcDataSource.getNumActive() = \"%d\"", tomcatJdbcDataSource.getNumActive()));
    out.println(String.format("tomcatJdbcDataSource.getNumIdle() = \"%d\"", tomcatJdbcDataSource.getNumIdle()));
    out.println(String.format("tomcatJdbcDataSource.getWaitCount() = \"%d\"", tomcatJdbcDataSource.getWaitCount()));
}
%></pre>
<h3>Pool Status</h3>
<pre><%
  if (dataSource instanceof org.apache.tomcat.dbcp.dbcp2.BasicDataSource) {
    BasicDataSource basicDataSource = (BasicDataSource)dataSource;
    GenericObjectPool<PoolableConnection> pool = basicDataSource.getConnectionPool();
    if (pool != null) {
      out.println(String.format("pool.getNumActive() = \"%d\"", pool.getNumActive()));
      out.println(String.format("pool.getNumIdle() = \"%d\"", pool.getNumIdle()));
      out.println(String.format("pool.getNumWaiters() = \"%d\"", pool.getNumWaiters()));
    }
  }
  else if (dataSource instanceof org.apache.tomcat.jdbc.pool.DataSource) {
    org.apache.tomcat.jdbc.pool.DataSource tomcatJdbcDataSource = (org.apache.tomcat.jdbc.pool.DataSource)dataSource;
    out.println(String.format("tomcatJdbcDataSource.getNumActive() = \"%d\"", tomcatJdbcDataSource.getNumActive()));
    out.println(String.format("tomcatJdbcDataSource.getNumIdle() = \"%d\"", tomcatJdbcDataSource.getNumIdle()));
    out.println(String.format("tomcatJdbcDataSource.getWaitCount() = \"%d\"", tomcatJdbcDataSource.getWaitCount()));
  }
%></pre>
</body>
</html>