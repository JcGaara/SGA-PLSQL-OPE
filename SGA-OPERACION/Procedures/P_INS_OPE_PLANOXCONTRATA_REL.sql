create or replace procedure operacion.p_ins_ope_planoxcontrata_rel(an_codcon    operacion.ope_planoxcontrata_rel.codcon%type,
                                                                   av_idplano   operacion.ope_planoxcontrata_rel.idplano%type,
                                                                   an_tiptra    operacion.ope_planoxcontrata_rel.tiptra%type,
                                                                   an_prioridad operacion.ope_planoxcontrata_rel.prioridad%type,
                                                                   an_estado    operacion.ope_planoxcontrata_rel.estado%type) is

 /************************************************************
  NOMBRE: P_INS_OPE_PLANOXCONTRATA_REL
  PROPOSITO: Inserta Datos en la tabla ope_planoxcontrata_rel
  PROGRAMADO EN JOB: NO
  REVISIONES:
  Versión    Fecha      Autor           Descripción
  ---------  ---------- --------------- -----------------------
  1.0        14/12/2016 Aldo Salazar     Creación
  ***********************************************************/

  ln_resultado number;
begin

  if operacion.f_verifica_ope_planoxcontrata(av_idplano,
                                             an_codcon,
                                             an_tiptra) = 0 then
    insert into operacion.ope_planoxcontrata_rel
      (codcon, idplano, tiptra, estado, prioridad)
    values
      (an_codcon, av_idplano, an_tiptra, an_estado, an_prioridad);
  end if;

exception
  when others then
    raise_application_error(-20500,
                            'error al registrar la transaccion: en p_ins_ope_planoxcontrata_rel() - ' ||
                            sqlerrm);
end;

/