--actualizar para desactivacion stb(unassign)
update sgacrm.ft_tiptra_escenario set tipsrv='TODO', escenario=4
where tiptra=658 and tipsrv='0061' and escenario=3;
commit;