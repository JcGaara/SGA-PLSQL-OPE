DELETE FROM opedd d
 WHERE d.tipopedd IN
       (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'TV_HFC');
DELETE FROM tipopedd t WHERE t.abrev = 'TV_HFC';
