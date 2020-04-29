update operacion.ope_horaxcuadrilla_det  set  activo=1
where dia in (1,2,3,4,5,6) and id_ope_cuadrillaxdistrito_Det in (
select id_ope_cuadrillaxdistrito_Det from operacion.ope_cuadrillaxdistrito_det where tiptra=658);
/
update operacion.ope_horaxcuadrilla_det  set  activo=0
where hora='14:00'  and id_ope_cuadrillaxdistrito_Det in (
select id_ope_cuadrillaxdistrito_Det from operacion.ope_cuadrillaxdistrito_det where tiptra=658);
/
