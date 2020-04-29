CREATE OR REPLACE PROCEDURE OPERACION.P_CONSULTA_DTH(pv_numero_serie in varchar2,
                           pn_tipo         in number,
                           pv_nomcli       out marketing.vtatabcli.nomcli%type,
                           pv_estado       out varchar2,
                           pv_codresp      out varchar2,
                           pv_mesresp      out varchar2) is
  /***********************************************************************************************
    NOMBRE:     OPERACION.P_CONSULTA_DTH
    PROPOSITO:  Consultar el estado de las tarjetas / decos en BSCS
    PROGRAMADO EN JOB:  NO

    REVISIONES:
    Version      Fecha        Autor             Solicitado Por        Descripcion
    ---------  ----------  -----------------    --------------        ------------------------
    1.0        28/08/2013  Hector Huaman                              Creación
  **********************************************************************************************/
  begin
    TIM.SP_CONSULTA_DTH@DBL_BSCS_BF(pv_numero_serie,
                                    pn_tipo,
                                    pv_nomcli,
                                    pv_estado,
                                    pv_codresp,
                                    pv_mesresp);

  exception
    when others then
      pv_nomcli  := Null;
      pv_codresp := 0;
      pv_mesresp := 'Error de Conexión a BSCS...';

 END P_CONSULTA_DTH;
/
