insert into cusbra.br_sel_wf (TIPTRA, WFDEF, FLG_SELECT)
values ((select t.tiptra from  OPERACION.tiptrabajo t where t.descripcion =  'HFC - RECLAMO CLARO EMPRESAS'),(select t.wfdef from  OPEWF.wfdef t where t.descripcion = 'Mantenimiento HFC'), 0);

commit;
