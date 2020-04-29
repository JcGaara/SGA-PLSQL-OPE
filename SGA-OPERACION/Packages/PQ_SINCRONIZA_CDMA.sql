CREATE OR REPLACE PACKAGE OPERACION.PQ_SINCRONIZA_CDMA is
  /************************************************************
  NOMBRE:     PQ_SINCRONIZA_CDMA
  PROPOSITO:  Intercambio de informacion de SGA con aplicacion web
              SISCOR (Sistema de configuracion remota)
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version   Fecha        Autor                   Descripcion
  --------- ----------  ---------------        ------------------------
  1.0       01/09/2009  Luis Valdivia

  ***********************************************************/

  TIPO_BTS        constant number(6) := 114;
  TIPO_NCOS       constant number(6) := 237;
  EST_ERROR_ENVIO constant number(6) := 15;

  procedure p_sincroniza_tarea(p_idtareawf    tareawf.idtareawf%type,
                               an_origen      number,
                               ar_siscortarea out operacion.siscortarea%rowtype);

  procedure p_sincroniza_tareadet(p_idtareawf tareawf.idtareawf%type);

  -- Conteo de lotes con error
  function f_conteo_error(a_idtareawf in number) return number;

  procedure p_chg_status_tareawf(a_idtareawf    in number,
                                 a_esttarea     in number,
                                 a_fecini       in date,
                                 a_fecfin       in date,
                                 ar_siscortarea out operacion.siscortarea%rowtype);

  procedure p_sincroniza_antenas;

  procedure p_sincroniza_sectores;

  procedure p_sincroniza_ncos_list;

END;
/


