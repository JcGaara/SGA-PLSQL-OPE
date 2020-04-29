create or replace and compile java source named OPERACION.com_creo_operacion_opth as
package com.creo.operacion;

import java.io.IOException;
import java.sql.*;
import oracle.jdbc.driver.*;


class grupoHilo extends Thread {
  String username;
  String password;
  String url;
  String nsp;
  long idproceso;
  int nroHilo;
  public grupoHilo(String username, String password, String url, String nsp, long idproceso, int nroHilo){
      this.username = username;
      this.password = password;
      this.url = url;
      this.nsp = nsp;
      this.idproceso = idproceso;
      this.nroHilo = nroHilo;
  }
  public void run() {
      Connection conn = null;
      CallableStatement cstmt = null;
      ResultSet rs = null;

      try{
        //Carga del JDBC driver
        String driverName = "oracle.jdbc.driver.OracleDriver";
        Class.forName(driverName);

        //Creando la Conección a BD
        conn = DriverManager.getConnection(url, username, password);

        cstmt = conn.prepareCall("{call " + nsp + "(?,?)}");
        cstmt.setLong(1, idproceso);
        cstmt.setInt(2, nroHilo);
        rs = cstmt.executeQuery();
      } catch (Exception e) {System.out.println(e.getMessage());}
      finally{
        try{
          if (rs != null) rs.close();
          if (cstmt != null) cstmt.close();
          if (conn != null) conn.close();
        } catch(Exception e1){System.out.println(e1.getMessage());}
      }
  }
}


public class ProcesaGrupoHilo
{
  public static void procesa(String username, String password, String url, String nsp, long idproceso, int nroHilos)
  {
    try{
       Thread[] procesaHilos = new grupoHilo[nroHilos];

       for (int i=1; i<=nroHilos; i++){
          procesaHilos[i-1] = new grupoHilo(username, password, url, nsp, idproceso, i);
       }

       for (int i=1; i<=nroHilos; i++){
          procesaHilos[i-1].start();
       }

       boolean procesa = true;
       int count;

       while(procesa){
           count = 0;
           for (int i=1; i<=nroHilos; i++){
               if (!procesaHilos[i-1].isAlive()){
                  count++;
               }
           }

           if (count == nroHilos){
              break;
           }

           Thread.sleep(3000);
       }
       
       cierra(username, password, url, idproceso);
       
    }catch(Exception e){
       System.out.println(e.getMessage());
    }
  }
  
   public static void cierra(String username, String password, String url, long idproceso)
  {
      Connection conn = null;
      CallableStatement cstmt = null;
      ResultSet rs = null;
    try{
         //Carga del JDBC driver
        String driverName = "oracle.jdbc.driver.OracleDriver";
        Class.forName(driverName);

        //Creando la Conección a BD
        conn = DriverManager.getConnection(url, username, password);

        cstmt = conn.prepareCall("{call operacion.pq_sga_th.p_sndMail (?)}");
        cstmt.setLong(1, idproceso);
        rs = cstmt.executeQuery();
  
    }catch(Exception e){System.out.println(e.getMessage());}    
    finally{
        try{
          if (rs != null) rs.close();
          if (cstmt != null) cstmt.close();
          if (conn != null) conn.close();
        } catch(Exception e1){System.out.println(e1.getMessage());}
   }       
  }

};
/