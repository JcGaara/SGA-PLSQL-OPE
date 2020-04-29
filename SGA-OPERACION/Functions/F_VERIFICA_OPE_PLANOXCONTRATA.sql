create or replace function operacion.f_verifica_ope_planoxcontrata(av_idplano   operacion.ope_planoxcontrata_rel.idplano%type,
                                                                   an_codcon    operacion.ope_planoxcontrata_rel.codcon%type,
                                                                   an_tiptra    operacion.ope_planoxcontrata_rel.tiptra%type)
  return number is

  /************************************************************
  NOMBRE: F_VERIFICA_OPE_PLANOXCONTRATA
  PROPOSITO: Validacion de Archivo Plano x Contrata
  PROGRAMADO EN JOB: NO
  REVISIONES:
  Versión    Fecha      Autor           Descripción
  ---------  ---------- --------------- -----------------------
  1.0        14/12/2016 Aldo Salazar     Creación
  ***********************************************************/

  ln_resultado number;
  ll_valida    number;
  ll_valida1   number;
BEGIN

  select count(1)
    into ll_valida
    from operacion.ope_planoxcontrata_rel
   where idplano = av_idplano
     and codcon = an_codcon
     and tiptra = an_tiptra;

  if ll_valida > 0 then
    ln_resultado := 1; 
    else
      ln_resultado := 0;
    end if;
  
 

  RETURN ln_resultado;
exception
  when others then
    return - 1;
end;
/