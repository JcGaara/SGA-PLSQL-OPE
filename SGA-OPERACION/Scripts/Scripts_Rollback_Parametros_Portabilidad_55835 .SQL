  ----------------------------------------------------------------------------------------------------------------------------------------------
  -- Borrando datos
  ----------------------------------------------------------------------------------------------------------------------------------------------  
  begin
    delete from operacion.opedd where tipopedd in (select tipopedd from tipopedd 
       where abrev in ('PARAM_PORTA','PR-CORP-WF','PR-CORP-ALER','PR-CORP-MAIL','PR_CORP_CONF','PR-CORP-WS'));

    delete from operacion.tipopedd where abrev in ('PARAM_PORTA','PR-CORP-WF','PR-CORP-ALER','PR-CORP-MAIL','PR_CORP_CONF','PR-CORP-WS')
    commit;
  exception
    when others then
      rollback;
  end;
  /