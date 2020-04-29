delete
  from opedd o
where o.tipopedd in
       (select tipopedd from tipopedd where abrev = 'SWTICH_ACT_DESCT');
commit;

delete from tipopedd where abrev = 'SWTICH_ACT_DESCT';
commit;
/