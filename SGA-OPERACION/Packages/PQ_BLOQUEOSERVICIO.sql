CREATE OR REPLACE PACKAGE OPERACION.PQ_BLOQUEOSERVICIO AS
  /************************************************************
  NOMBRE:     PQ_BLOQUEOSERVICIO
  PROPOSITO: Realiza las transacciones  para los bloqueos/desbloqueo de LD a solicitud del operador
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        19/06/2009  Hector Huaman M
  2.0        06/10/2010                      REQ.139588 Cambio de Marca
  3.0        28/03/2011  Juan Pablo Ramos    REQ.157873 Mejoras en bloqueo/desbloqueo por FCO y conciliación de pagos por FCO
  ***********************************************************/

  PROCEDURE p_genera_solicitudes;

  PROCEDURE p_genera_DESBLOQUEO(a_idtransfco transacciones_fco.idtransfco%type);

  PROCEDURE p_genera_BLOQUEO(a_idtransfco transacciones_fco.idtransfco%type);

  PROCEDURE p_pendiente_transacciones;

  PROCEDURE p_insert_sot(v_codcli       in solot.codcli%type,
                         v_tiptra       in solot.tiptra%type,
                         v_tipsrv       in solot.tipsrv%type,
                         v_grado        in solot.grado%type,
                         v_motivo       in solot.codmotot%type,
                         v_obsservacion in solot.observacion%type,
                         v_codsolot     out number);

  PROCEDURE p_insert_solotpto_desbloqueo(v_codsolot solot.codsolot%type,
                                         v_numero   inssrv.numero%type);

  PROCEDURE p_insert_solotpto_bloqueo(v_codsolot solot.codsolot%type,
                                      v_numero   inssrv.numero%type);

  PROCEDURE p_genera_trans_DESBLOQUEO;

  PROCEDURE p_genera_trans_BLOQUEO;

  FUNCTION f_obtienetiponumero(v_numero in numtel.numero%type) return number;
  PROCEDURE p_Actualiza_ncos(v_codsolot in solot.codsolot%type,
                             v_numero   in numtel.numero%type,
                             an_error_ncos   out number,--<3.0>
                             l_codsrv out tystabsrv.codsrv%type,--<3.0>
                             l_nombrencos out configuracion_itw.descripcion%type);--<3.0>
  FUNCTION f_verifica_baja(v_codcli transacciones.codcli%type,v_nomabr transacciones.nomabr%type) return number;

  PROCEDURE p_verificadesbloqueo(v_numero        numtel.numero%type, v_idtipobloqueo varchar2);
  PROCEDURE p_verificaregistro;
END PQ_BLOQUEOSERVICIO;
/


