CREATE OR REPLACE PACKAGE OPERACION.PKG_GESTION_RECURSOS IS

  /****************************************************************
  * Nombre Package : PKG_GESTION_RECURSOS
  * Propósito : Validar disponibilidad de hilo y reservar hilo
  * Input : Ninguno
  * Output : Ninguno
  * Creado por : GLOBAL HITSS
  * Fec Creación : 10/09/2019
  * Fec Actualización : 10/09/2019
  ****************************************************************/

  procedure sgass_valid_dispo_hilo_puerto(pi_cursor_datos      in clob,
                                          po_cursor_datos      out sys_refcursor,
                                          po_codigo_respuesta  out varchar2,
                                          po_mensaje_respuesta out varchar2);

  procedure sgass_reserva_hilo(pv_codmufagis        in varchar2,
                               pv_deshilo           in varchar2,
                               pv_numslc            in varchar2,
                               pv_codsuc            in varchar2,
                               po_cursor_datos      out sys_refcursor,
                               po_codigo_respuesta  out varchar2,
                               po_mensaje_respuesta out varchar2);

  procedure sgass_libera_hilo(pv_codmufagis        in varchar2,
                               pv_deshilo           in varchar2,
                               pv_numslc            in varchar2,
                               pv_codsuc            in varchar2,
                               po_cursor_datos      out sys_refcursor,
                               po_codigo_respuesta  out varchar2,
                               po_mensaje_respuesta out varchar2);
                                   
  procedure sgass_bss_gestionsefgis(pi_codigoProyecto    in varchar2,
                                    pi_codigoSucursal    in varchar2,
                                    pi_idTrazabilidad    in number,
                                    po_xml_input         out clob,
                                    po_xml_output        out clob,                                    
                                    po_codigo_respuesta  out number, 
                                    po_mensaje_respuesta out varchar2);
END;
/