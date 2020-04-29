CREATE OR REPLACE VIEW OPERACION.V_PERSONAL
AS 
select a.codtra, a.apepat||' '||a.apemat||' '||a.nomtra, b.login, b.coddpt, decode(a.codsit,'01','A','02','I'), a.sextra, c.desdpt, d.descar  
from perdatper a, perdatlab b, pertabdpt c, pertabcar d  
where a.codtra = b.codtra and b.coddpt = c.coddpt and b.codcar = d.codcar;


