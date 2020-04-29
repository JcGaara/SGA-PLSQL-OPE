
delete from opedd where tipopedd in ( select tipopedd from tipopedd where descripcion ='BAM-Config  TIPACCIONPV');
delete from tipopedd where descripcion ='BAM-Config  TIPACCIONPV';
commit;


delete from opedd where tipopedd in ( select tipopedd from tipopedd where descripcion ='BAM-Config  IDTRANCORTE');
delete from tipopedd where descripcion ='BAM-Config  IDTRANCORTE';
commit;