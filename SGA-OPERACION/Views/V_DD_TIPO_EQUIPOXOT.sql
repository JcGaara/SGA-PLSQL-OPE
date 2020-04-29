CREATE OR REPLACE VIEW OPERACION.V_DD_TIPO_EQUIPOXOT
AS 
select codigoc,descripcion,abreviacion from opedd where tipopedd = 28;


