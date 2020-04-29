
/*Delete configuracion operaciones tipgen_vod*/

DELETE FROM opedd d
 WHERE d.tipopedd IN
       (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TIPGENERA_VOD');
DELETE FROM tipopedd t WHERE t.abrev = 'TIPGENERA_VOD';
