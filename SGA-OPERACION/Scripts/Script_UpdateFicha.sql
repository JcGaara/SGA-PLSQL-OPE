--UPDATE PARA EL IDLISTA serviceType PAQUETE ADICIONAL TV
--antes se debe actualizar la configuración de la ficha de tv adicional atributo PAQUETE ADICIONAL TV-->serviceType
update ft_instdocumento set idlista=93 where idlista=118;
commit;