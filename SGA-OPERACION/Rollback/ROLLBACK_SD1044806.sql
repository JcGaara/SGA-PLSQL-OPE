delete from opedd where tipopedd = (select tipopedd from tipopedd where abrev = 'TRANS_BILL') and abreviacion = 'P_VAL_NUMTLF_TRAS' and codigon_aux is not null;
commit;
/