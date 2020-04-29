CREATE OR REPLACE VIEW OPERACION.V_DD_ESTADO_SOLOTPTOEQU
AS 
select codigon,descripcion,codigoc from opedd where tipopedd = 18;


