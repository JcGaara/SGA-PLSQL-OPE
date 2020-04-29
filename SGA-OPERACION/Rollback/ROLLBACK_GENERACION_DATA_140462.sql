delete from operacion.opedd t
 where t.tipopedd in
       (select t.tipopedd
          from tipopedd t
         where t.abrev in ('ajuste_masivo_cab', 'ajuste_masivo_det'));
         
delete from operacion.tipopedd t
where t.abrev in ('ajuste_masivo_cab', 'ajuste_masivo_det');
COMMIT;