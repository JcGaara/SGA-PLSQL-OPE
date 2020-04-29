-- Elimniar detalle de parametros
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'TV_HFC');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'TV_HFC_PAIS');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'TV_HFC_FOX');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'TV_HFC_MOVIECITY');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'TV_HFC_MOVIECITY_F2');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where abrev = 'TV_HFC_MOVIECITY_F1');

-- Eliminar cabecera de parametros
delete from operacion.tipopedd where abrev = 'TV_HFC';
delete from operacion.tipopedd where abrev = 'TV_HFC_PAIS';
delete from operacion.tipopedd where abrev = 'TV_HFC_FOX';
delete from operacion.tipopedd where abrev = 'TV_HFC_MOVIECITY';
delete from operacion.tipopedd where abrev = 'TV_HFC_MOVIECITY_F2';
delete from operacion.tipopedd where abrev = 'TV_HFC_MOVIECITY_F1';

-- Elimniar detalle de parametros TNT GO SPACE GO
DELETE FROM opedd d WHERE d.tipopedd IN (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TNT_GO_SPACE_GO');
-- Elimniar cabecera de parametros TNT GO SPACE GO
DELETE FROM tipopedd t WHERE t.abrev = 'TNT_GO_SPACE_GO';


-- Elimniar detalle de parametros CARTOON NETWORK GO
DELETE FROM opedd d WHERE d.tipopedd IN (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'CN_GO');
-- Elimniar cabecera de parametros CARTOON NETWORK GO
DELETE FROM tipopedd t WHERE t.abrev = 'CN_GO';

commit;