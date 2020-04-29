CREATE OR REPLACE PACKAGE OPERACION.pq_almacen as
  /************************************************************
  NOMBRE:     PQ_ALMACEN
  PROPOSITO:  Envio de Correos por asignacion de trabajo a Contrata mediante un JOB
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        23/06/2009  Edilberto Astulle  Creado
  1.0        23/06/2009  Edilberto Astulle  REQ-95805:procedimiento p_envia_correo_reserva, envio de Correos por asignacion de trabajo a Contrata mediante un JOB
                                            1 : Equipo ,2 : Material
  2.0        16/07/2009  Edilberto Astulle  REQ-97853 :se modifico el procedmiento p_envia_correo_reserva para optimizar el envio de correo
  3.0        05/10/2009  Joseph Asencios    REQ-103416: Se agregó el procedimiento p_envia_correo_reserva_anulada, para envio de correo de reservas anuladas.
  4.0        18/12/2009  MEchevarr/EAstulle REQ-112471: Se modifico el procedimiento p_despacho_masivo para que los proyeto tipo 2 envien fecha de liquidación
  5.0        30/12/2009  Joseph/Edilberto   REQ-114000: Se agregó el procedimiento P_cargar_equ_traslado para el traslado de materiales mediante una plantilla
  6.0        12/01/2010  Alfonso Pérez      REQ-115142: Se agrego procedimiento para carga de material de traslado
  7.0        11/05/2010  Edson Caqui        Req.128297: Modificacion de p_envia_correo_reserva y creacion dep_despacho_masivo2
  8.0        26/05/2010  Alexander Yong     REQ-136852: Problemas con la reservas por Traspaso
  9.0        06/10/2010                      REQ.139588 Cambio de Marca

  ***********************************************************/

  procedure p_envia_correo_reserva(a_transaccion in number,
                                   a_tipo        in number);
  procedure p_envia_correo_reserva_anulada(a_transaccion in number,
                                           a_solot       in number,
                                           a_tipo        in number); --REQ 103416

  procedure p_stock_despacho(a_tipproyecto number,
                             a_fecini      date,
                             a_fecfin      date,
                             a_codcon      number);

  procedure p_despacho_masivo(a_tipproyecto    number,
                              a_fecini         date,
                              a_fecfin         date,
                              a_codcon         number,
                              a_trans_despacho out number);
  --<REQ ID = 114000>
  procedure p_cargar_equ_traslado(a_codsolot    solot.codsolot%type,
                                  a_idplantilla plantilla_traslado.idplantilla%type);
  --</REQ>

  --<6.0
  procedure p_cargar_mat_traslado(a_codsolot    solot.codsolot%type,
                                  a_tipequ      number,
                                  a_centro_ori  varchar2,
                                  a_almacen_ori varchar2,
                                  a_centro_des  varchar2,
                                  a_almacen_des varchar2,
                  a_cantidad  number);--<8.0>
  -->6.0

  procedure p_despacho_masivo2(a_tipproyecto    in number,
                               a_fecini         in date,
                               a_fecfin         in date,
                               a_codcon         in number,
                               a_trans_despacho out number);--<7.0>
end pq_almacen;
/


