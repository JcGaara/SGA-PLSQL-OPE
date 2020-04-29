CREATE OR REPLACE VIEW OPERACION.V_DD_ESTADO_EQUIPOXOT
AS 
select codigoc,descripcion,codigon from opedd where tipopedd = 18;


