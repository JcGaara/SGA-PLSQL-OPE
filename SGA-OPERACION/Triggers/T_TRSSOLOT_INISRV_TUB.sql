CREATE OR REPLACE TRIGGER OPERACION.T_TRSSOLOT_INISRV_TUB
BEFORE UPDATE OF FECTRS ON TRSSOLOT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
--EMPLEADO PARA CARGAR VTACARINISERV - CARTAS DE INSTALACION
DECLARE
ll_count number;
ll_num number;
BEGIN
select count(*)
into ll_count
from vtacariniserv
where numslc=:new.numslc
and numpto =:new.numpto;
If ll_count=0 then
P_CARGA_VTACARINISERV(:new.numslc, :new.numpto, :new.codsrvnue, :new.fectrs, :new.bwnue, :new.codinssrv);
else
Update vtacariniserv
set fecinisrv=:new.fectrs,
fecmod= sysdate
where numslc=:new.numslc
and numpto =:new.numpto ;
end if;
EXCEPTION
WHEN OTHERS THEN
P_ENVIA_CORREO_DE_TEXTO_ATT('Carta de Instalacion '||:new.numslc, 'edwin.terreros@attla.com', 'Ocurrio un problema en punto '||:new.numpto);
END TRSSOLOT_INISRV_TUB;
/



