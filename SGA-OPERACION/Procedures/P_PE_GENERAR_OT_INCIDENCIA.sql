CREATE OR REPLACE PROCEDURE OPERACION.P_PE_GENERAR_OT_INCIDENCIA (
   a_recosi in number,
   a_tiptra in number,
   a_codmotot in number,
   a_area in number,
   a_obs in varchar2,
   a_codot out number

)IS
/******************************************************************************
NAME:       P_PE_GENERAR_OT_TP
PURPOSE:    Genera una OT en base a un reclamo

REVISIONS:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        20/08/2004  CCorrales        Se genera una OT para TP

******************************************************************************/
l_codot number;
l_codsolot number;
l_coddpt areaope.coddpt%type;
l_codcli solot.CODCLI%type;

BEGIN

   l_codsolot := F_GET_CLAVE_SOLOT;

   begin
      select CUSTOMERCODE into l_codcli from CUSTOMERXINCIDENCE where codincidence = a_recosi and rownum = 1;
   exception
      when no_data_found then
         raise_application_error(-20500,'No existe servicio asociado al reclamo.');
   end;

   P_AUTOGENERAR_SOLOT(
      l_codsolot,
      a_tiptra,
      l_codcli,
      null,
      a_recosi,
      null,
      'I',
      a_codmotot,
      a_obs) ;


   select coddpt into l_coddpt from areaope where area = a_area;

   select F_GET_CLAVE_OT() into l_codot from DUAL;

   insert into ot (
   CODOT,   CODMOTOT, CODSOLOT, TIPTRA,        ESTOT, FECCOM,       AREA,   CODDPT,   observacion )
   values (
   l_codot, a_codmotot, l_codsolot, a_tiptra,          1,     null    ,     a_area, l_coddpt, a_obs);

   P_LLENA_OTPTO_DE_SOLOTPTO(l_codot);

   a_codot := l_codot;

END;
/


