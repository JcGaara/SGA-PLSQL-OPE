CREATE OR REPLACE VIEW OPERACION.V_M_PUERTOXEQUIPO_BAJAS
AS 
select
c.descripcion site,
c.codubired,
--b.codequipo,
a.CODPUERTO,
a.CODEQUIPO,
a.CODPRD,
a.CODTARJETA,
a.ESTADO,
a.IDE,
a.ESTADOANT,
d.descripcion des_estado,
e.descripcion des_estado_ant,
trunc(a.FECEJE) FECEJE,
case
  when to_number(to_char(a.feceje,'dd'))  between 1 and 7 then 'Semana_1'
  when to_number(to_char(a.feceje,'dd'))  between 8 and 14 then 'Semana_2'
  when to_number(to_char(a.feceje,'dd'))  between 15 and 21 then 'Semana_3'
  when to_number(to_char(a.feceje,'dd'))  > 22 then 'Semana_4'
end Semana,
to_char(a.feceje,'ww') semana_anhio,
to_char(a.FECEJE,'yyyymm') periodo,
to_number(to_char(a.feceje,'dd')) dia,
a.USUMOD
from OPERACION.puertoxequipo_LOG a, equipored b, ubired c,
  (select codigon, descripcion from opedd where tipopedd = 22) d,
  (select codigon, descripcion from opedd where tipopedd = 22) e
  where a.codequipo = b.codequipo (+)
  and b.codubired = c.codubired
  and a.estado = d.codigon
  and a.estadoant = e.codigon
  and to_char(feceje,'yyyymm') >=200903
order by a.feceje;


