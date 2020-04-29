create or replace package operacion.pq_abrev  is

  /******************************************************************************
     NOMBRE:       PQ_ABREV_ATC
     PROPOSITO:

     REVISIONES:
     Ver        Fecha        Autor               Solicitado por  Descripcion
     ---------  ----------  ---------------      --------------  ----------------------

      1.0       24/10/2013  Alfonso Perez Ramos  Hector Huaman   REQ-164553: Creacion
  *********************************************************************/
  function f_obt_valores_codsrv(av_lista  varchar2,
                                an_indice number,
                                ac_delim  varchar2) return varchar2;

  function f_val_existe_codsrv(as_numslc in vtatabslcfac.numslc%type,
                               an_idprod in producto.idproducto%type,
                               an_iddet  in detalle_paquete.iddet%type)

   return number;

  function f_geterrores(k_id in number) return varchar2;

  procedure p_actualiza_abrev(as_numslc   in varchar2,
                              as_abrevia  in varchar2,
                              o_resultado out number,
                              o_mensaje   out varchar2);

  procedure p_obtiene_det_serv(as_numslc   in vtatabslcfac.numslc%type,
                               an_idprod   in producto.idproducto%type,
                               an_iddet    in vtadetptoenl.iddet%type,
                               o_banwid    out tystabsrv.banwid%type,
                               o_abrev     out tystabsrv.abrev%type,
                               o_resultado out number,
                               o_mensaje   out varchar2);

  procedure p_genera_transaccion_det(an_sid      in number,
                                     as_codcli   in varchar2,
                                     as_codsvr   in varchar2,
                                     av_id       in number,
                                     o_coderror  out number,
                                     o_descerror out varchar2);

  procedure p_ejecuta_abreviatura(as_numslc   in vtatabslcfac.numslc%type,
                                  o_abrev     out varchar2,
                                  o_coderror  out number,
                                  o_descerror out varchar2);

end pq_abrev;
/
