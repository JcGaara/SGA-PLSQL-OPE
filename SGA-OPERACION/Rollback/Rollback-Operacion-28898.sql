delete from cusbra.br_sel_wf t  where t.tiptra = (select t.tiptra from  OPERACION.tiptrabajo t where t.descripcion =  'HFC - RECLAMO CLARO EMPRESAS') and t.wfdef = (select t.wfdef from  OPEWF.wfdef t where t.descripcion = 'Mantenimiento HFC');

commit;
