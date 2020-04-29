
declare
newidcab number;
begin
SELECT IDCAB INTO newidcab FROM OPERACION.OPE_cab_XML WHERE PROGRAMA = 'registra_usuario_cab';
DELETE FROM OPERACION.OPE_det_XML WHERE IDCAB = newidcab;
DELETE FROM OPERACION.OPE_cab_XML WHERE PROGRAMA = 'registra_usuario_cab' and IDCAB = newidcab;
end;
/

declare
newidcab number;
begin
SELECT IDCAB INTO newidcab FROM OPERACION.OPE_cab_XML WHERE PROGRAMA = 'registra_usuario_det';
DELETE FROM OPERACION.OPE_det_XML WHERE IDCAB = newidcab;
DELETE FROM OPERACION.OPE_cab_XML WHERE PROGRAMA = 'registra_usuario_det' and IDCAB = newidcab;
end;
/