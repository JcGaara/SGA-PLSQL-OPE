CREATE OR REPLACE PACKAGE OPERACION.PQ_CONSULTAS_SGA_SIAC IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_CONSULTAS_SGA_SIAC
  PROPOSITO:  DETALLE DE TAREAS

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      15/04/2018  -        -    PROY-
  /************************************************************************************************/
  CN_OPCION            CONSTANT NUMBER := 14;
  CV_INTERNET          CONSTANT CHAR(4) := '0006';
  CV_TELEFONIA         CONSTANT CHAR(4) := '0004';
  CV_CABLE             CONSTANT CHAR(4) := '0062';
  CN_IDINTERFASE_CM    CONSTANT NUMBER := 620;
  CN_IDINTERFASE_MTA   CONSTANT NUMBER := 820;
  CN_IDINTERFASE_EP    CONSTANT NUMBER := 824;
  CN_IDINTERFASE_FAC   CONSTANT NUMBER := 830;
  CN_IDINTERFASE_STB   CONSTANT NUMBER := 2020;
  CN_IDINTERFASE_CANAL CONSTANT NUMBER := 2030;
  CN_IDINTERFASE_VOD   CONSTANT NUMBER := 2050;
  
  PROCEDURE SGASS_DETA_SOLOT(pi_codsolot    number,
                             po_dato        out sys_refcursor,
                             po_cod_error   out int,
                             po_des_error   out varchar2);                             
  
  PROCEDURE SGASS_DETA_TAREA(pi_CODSOLOT    number,
                             po_dato        out sys_refcursor,
                             po_cod_error   out number,
                             po_des_error   out varchar2);
                              
  PROCEDURE SGASS_DETA_ESTADO(pi_codsolot    number,
                              po_dato        out sys_refcursor,
                              po_cod_error   out number,
                              po_des_error   out varchar2);

  PROCEDURE SGASS_DETA_TPENDIENTE(pi_CODSOLOT    number,
                                  po_dato        out sys_refcursor,
                                  po_cod_error   out number,
                                  po_des_error   out varchar2);
                                      
  PROCEDURE SGASS_DETA_ANOTACIONES(pi_codsolot    number,
                                   po_dato        out sys_refcursor,
                                   po_cod_error   out number,
                                   po_des_error   out varchar2); 
                                   
  PROCEDURE SGASS_DETA_CTREQU (pi_codsolot    number,
                               po_dato        out sys_refcursor,
                               po_cod_error   out number,
                               po_des_error   out varchar2); 

  PROCEDURE SGASS_DETA_AGENDAMIENTO (pi_codsolot    number,
                                     po_dato        out sys_refcursor,
                                     po_cod_error   out number,
                                     po_des_error   out varchar2);                                  

  PROCEDURE SGASS_DETALLE_AGENDA (pi_idagenda    number,
                                  po_dato        out sys_refcursor,
                                  po_cod_error   out number,
                                  po_des_error   out varchar2);                                     
                                    
  PROCEDURE SGASS_DETA_TRANS (pi_codsolot    number,
                              po_dato        out sys_refcursor,
                              po_cod_error   out number,
                              po_des_error   out varchar2);  
                              
  PROCEDURE SGASS_IMP_REDIRECCIONA (pi_codsolot       number, 
                                   pi_usuario        varchar2,
                                   po_cursor     out sys_refcursor,
                                   po_cod_error   out number,
                                   po_des_error   out varchar2);                                                                   
END;
/


