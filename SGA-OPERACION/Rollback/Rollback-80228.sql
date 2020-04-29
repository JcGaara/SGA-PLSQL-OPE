--Rollback Configuración Claro Play
delete from operacion.opedd t
 where t.tipopedd in (select tipopedd
                        from operacion.tipopedd
                       where abrev in ('CPLAY',
                                       'CPLAY_DTH_POST',
                                       'CPLAY_DTH_PRE',
                                       'CPLAY_FILT_DURAC',
                                       'CPLAY_IDCONFIGITW'));

delete from operacion.tipopedd
 where abrev in ('CPLAY',
                 'CPLAY_DTH_POST',
                 'CPLAY_DTH_PRE',
                 'CPLAY_FILT_DURAC',
                 'CPLAY_IDCONFIGITW');

commit;
