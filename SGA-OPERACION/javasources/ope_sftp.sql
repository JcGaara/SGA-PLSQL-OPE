create or replace and compile java source named operacion.ope_sftp as
package ope.sftp;

import java.util.Vector;

import com.jcraft.jsch.Session;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.SftpException;

public class ope_sftp
{
    /*Metodo que permite cerrar la conexion parametrizada*/
    private static void finalizeConnection(ChannelSftp channel, Session session) {
        channel.exit();
        session.disconnect();
    }

    /*Metodo que permite la conexion con un servidor externo*/
    public static ChannelSftp getChannel(String usuario,String clave,String host,int puerto,String know_hosts) throws JSchException{

        JSch jsch = new JSch();
        jsch.setKnownHosts(know_hosts);
        Session session = jsch.getSession(usuario, host, puerto);
        session.setConfig("StrictHostKeyChecking", "no");
        session.setPassword(clave);
        session.connect();
        Channel channel = session.openChannel("sftp");
        channel.connect();
        return (ChannelSftp) channel;
    }

    /*Metodo que permite realizar el envio de archivo de un Servidor a otro Servidor*/
    public static String enviarArchivo(String usuario, String clave, String host, int puerto, String know_hosts, String rutArchivOrigen, String rutArchivDestino) {
        String response = "";
        ChannelSftp c = null;
        Session s = null;
          try
          {
          c = getChannel(usuario,clave,host,puerto,know_hosts);
          s = c.getSession();
          c.put(rutArchivOrigen,rutArchivDestino);
          response="Ok";
          }catch (JSchException e) {
            response = "Error Jsch: " + e.getMessage().toString() + e.getLocalizedMessage();
          }catch (SftpException e) {
            response = "Error Sftp: " + e.getMessage().toString() + e.getLocalizedMessage();
          }
          catch (Exception e) {
            response = "Error: " + e.getMessage().toString() + e.getLocalizedMessage();
          }

        finalizeConnection(c, s);
        return response;
    }

    /*Metodo que permite realizar el Renombrado de un archivo de un Servidor*/
    public static String renomArchivo(String usuario,String clave,String host,int puerto,String know_hosts,String ArchivoAnt,String ArchivNuev) throws JSchException{
        String response = "";
        ChannelSftp c = null;
        Session s = null;

        try
        {
        c = getChannel(usuario,clave,host,puerto,know_hosts);
        s = c.getSession();
        c.rename(ArchivoAnt,ArchivNuev);
        response="Ok";
        }catch (JSchException e) {
          response = "Error Jsch: " + e.getMessage().toString() + e.getLocalizedMessage();
        }catch (SftpException e) {
          response = "Error Sftp: " + e.getMessage().toString() + e.getLocalizedMessage();
        }
        catch (Exception e) {
          response = "Error: " + e.getMessage().toString() + e.getLocalizedMessage();
        }

        finalizeConnection(c, s);
        return response;
    }

    /*Metodo que permite realizar el Eliminado de un archivo de un Servidor*/
    public static String eliminArchivo(String usuario,String clave,String host,int puerto,String know_hosts,String rutArchivo) throws JSchException{
        String response = "";
        ChannelSftp c = null;
        Session s = null;

        try
        {
        c = getChannel(usuario,clave,host,puerto,know_hosts);
        s = c.getSession();
        c.rm(rutArchivo);
        response="Ok";
        }catch (JSchException e) {
          response = "Error Jsch: " + e.getMessage().toString() + e.getLocalizedMessage();
        }catch (SftpException e) {
          response = "Error Sftp: " + e.getMessage().toString() + e.getLocalizedMessage();
        }
        catch (Exception e) {
          response = "Error: " + e.getMessage().toString() + e.getLocalizedMessage();
        }

        finalizeConnection(c, s);
        return response;
    }
    /*Metodo que permite realizar el Verificado de un archivo de un Servidor*/
    public static String verifArchivo(String usuario,String clave,String host,int puerto,String know_hosts,String rutArchivo) throws JSchException{
        String response = "";
        ChannelSftp c = null;
        Session s = null;
        try
        {
        c = getChannel(usuario,clave,host,puerto,know_hosts);
        s = c.getSession();
        c.ls(rutArchivo);
        response="Ok";
        }catch (JSchException e) {
          response = "Error Jsch: " + e.getMessage().toString() + e.getLocalizedMessage();
        }catch (SftpException e) {
          response = "Error Sftp: " + e.getMessage().toString() + e.getLocalizedMessage();
        }
        catch (Exception e) {
          response = "Error: " + e.getMessage().toString() + e.getLocalizedMessage();
        }

        finalizeConnection(c, s);
        return response;
    }

}
/