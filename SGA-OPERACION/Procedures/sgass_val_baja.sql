create or replace procedure operacion.sgass_val_baja(p_contract_id in varchar2,
                                                     p_customer_id in varchar2,
                                                     p_flagresult out varchar2,
                                                     p_motivecancellation out varchar2,
                                                     p_cod_error out number,
                                                     p_msg_error out varchar2)
/*'****************************************************************
'* Nombre SP         : OPERACION.SGASS_VAL_BAJA
'* Propósito         : Validar si el contrato tiene una SOT de baja
'* Input             : pi_co_id    - Valor del Contrato del cliente
'* Output            : po_sot_baja - Envia 0 si en caso no encontro SOT de Baja
                                     caso contrario mas de 0.
                       po_cod      - Envia 0 si el procedimiento se ejecuto de manera
                                     correcta.
                       po_mensaje  - Retorna 'Exito' en caso de la ejecucion correcta
                                     del procedimiento, caso contrario envia el mensaje
                                     del error presentado por la BD.
'* Creado por        : Hitss
'* Fec Creación      : 17/04/2018
'* Fec Actualización : 17/04/2018
'****************************************************************/
is

begin

  p_cod_error  := 0;
  p_msg_error  := 'Exito';

    select count(s.codsolot)
      into p_flagresult
      from operacion.solot s 
     where s.tiptra in  (select o.codigon
                           from operacion.tipopedd t,
                                operacion.opedd o
                          where t.tipopedd=o.tipopedd
                            and t.abrev='CFG_SU_MTV'
                            and o.abreviacion='TIPTRA')
      and s.customer_id=to_number(p_customer_id)
      and s.cod_id=to_number(p_contract_id)
      and s.estsol in (29,12);
  
  if p_flagresult > 0 then
    begin

     select m.descripcion
     into p_motivecancellation
     from operacion.solot s, operacion.motot m
     where 
     s.codmotot=m.codmotot
     and s.tiptra in  (select o.codigon
                           from operacion.tipopedd t,
                                operacion.opedd o
                          where t.tipopedd=o.tipopedd
                            and t.abrev='CFG_SU_MTV'
                            and o.abreviacion='TIPTRA')
      and s.customer_id=to_number(p_customer_id)
      and s.cod_id=to_number(p_contract_id)
      and s.estsol in (29,12)
      and rownum=1
      order by s.fecusu desc;
      
      if SUBSTR(UPPER(p_motivecancellation),1,11) = 'HFC/SIAC - ' or SUBSTR(UPPER(p_motivecancellation),1,11) = 'WLL/SIAC - ' then
         p_motivecancellation :=SUBSTR(UPPER(p_motivecancellation),12);
      else
         p_motivecancellation :=UPPER(p_motivecancellation);
      end if;
        
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_flagresult:='0';
          p_cod_error := -99;
          p_msg_error := 'Codigo Error: ' || to_char(sqlcode) || chr(13) ||
                         'Mensaje Error: ' || to_char(sqlerrm) || chr(13) ||
                         'Linea Error: ' || dbms_utility.format_error_backtrace;
          return;
    end;
  else
    return;
  end if;

exception
  when others then
    p_flagresult:='0';
    p_cod_error := -99;
    p_msg_error := 'Codigo Error: ' || to_char(sqlcode) || chr(13) ||
                   'Mensaje Error: ' || to_char(sqlerrm) || chr(13) ||
                   'Linea Error: ' || dbms_utility.format_error_backtrace;
end;
/