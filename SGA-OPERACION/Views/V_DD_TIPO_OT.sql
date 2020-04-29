CREATE OR REPLACE VIEW OPERACION.V_DD_TIPO_OT
AS 
select codigoc,descripcion from opedd where tipopedd = 25;


