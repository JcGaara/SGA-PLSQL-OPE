CREATE OR REPLACE TRIGGER OPERACION.T_OT_AI
AFTER INSERT
ON operacion.OT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
ls_texto varchar2(32000);
ls_tipo  varchar2(4000);
ls_motivo  varchar2(4000);
ls_pry  varchar2(40);
ls_area varchar2(100);
cursor cur_correo is
select a.email
from envcorreo a where a.coddpt = :new.coddpt and a.tipo = 1;
BEGIN
ls_texto := 'Fue generado por '||:new.codusu||' Fecha: '||to_char(:new.fecusu,'dd/mm/yyyy hh24:mi')||chr(13);
select a.descripcion into ls_tipo from tiptrabajo a where a.tiptra = :new.tiptra;
select a.descripcion into ls_motivo from motot a where a.codmotot = :new.codmotot;
select numslc into ls_pry from solot a where a.codsolot = :new.codsolot;
select descripcion into ls_area from areaope where area = :new.area;
ls_texto := ls_texto || 'Area:      '||ls_area||chr(13);
ls_texto := ls_texto || 'Proyecto:  '||ls_pry||chr(13);
ls_texto := ls_texto || 'Tipo:      '||ls_tipo||chr(13);
ls_texto := ls_texto || 'Motivo:    '||ls_motivo||chr(13)||chr(13);
ls_texto := ls_texto || 'Solicitud: '||to_char(:new.codsolot)||chr(13)||chr(13);
ls_texto := ls_texto || nvl(F_GET_DETALLE_CORREO_OT(:new.codsolot),' ');
ls_texto := substr(ls_texto,1,3990);
for  ls_correo in cur_correo loop
  P_ENVIA_CORREO_DE_TEXTO_ATT('Nueva Orden de Trabajo '||to_char(:new.codot), ls_correo.email, ls_texto);
end  loop;
--- Gustavo Ormeño.
if :new.area = 14 then
   PQ_SOLOT.p_asig_wf(:new.codsolot,699);
end if;
-------------------------
END;
/



