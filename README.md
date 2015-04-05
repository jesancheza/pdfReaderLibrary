# pdfReaderLibrary
Practica IOS fundamentos

1- Tenemos isKindOfClass y isMemberOfClass. El primero comprueba si el objeto es una instancia de la clase indicada y el segundo 
comprueba si es una instancia de la clase indicada o una subclase.

2- Las imágenes de los libros y los pdf los guardaría en Document para mantenerlos mientras sea necesario.

3- Después de realizar la práctica, creo que el método más sencillo habría sido modificar el JSON añadiendo el dato nuevo isFavorite.
 Por mi planteamiento inicial he tenido que hacerlo de forma difernte. He guardado los nombres de los libros favoritos en un NSString
 en UserDefault y lo recupero posteriormente para mantenerlo actualizado. La idea inicial era haber creado un NSArray con dichos favoritos
 y guardarlos en Document, pero me di cuenta más tarde que no permite guardar NSArray y mi planteamiento se vino abajo. 

4- Al marcar un libro como favorito envío una notificación que he definido en el controlador de la tabla y actualizo tanto el array de 
favoritos como la tabla con un reloadData. Lo podríamos hacer mediante un delegado pero en este caso ya no podríamos hacerlo al tener ya un delegado el controlador del BookViewController.

5- No sería una aberrración realizar un reloadData puesto que no se recargan todas las celdas sino un número determinado que se están
 mostrando y alguna más. Merece la pena usarlo siempre que necesitemos actualizar los datos de la tabla que han sido modificados por
 el modelo.

6- Para actualizar el AGTSimplePDFViewController me suscribo a una notificación que se mandará cuando se modifique el libro seleccionado
 en la tabla y de esta manera actualizaré el libro que se está mostrando.  

** Conclusiones **

He realizado un planteamiento erroneo al comienzo de la práctica y esto me ha bloqueado al final provocando que no esté terminada
 correctamente. Mi idea era mantener el JSON intacto y que al cargar la app simplemente se creara un diccionario con los tags y en cada
tag un array con los libros asociados. Esto me ha ido relativamente bien hasta llegar a la selección de favoritos que he tenido que picar
mucho código para que medianamente funcione. 
Otro problema que tiene la app, es que me añade a favorito n veces el libro. Creo que no he entendido bien las notificaciones porque no
logro ver el error. Si una notificación se manda cuando se cambia el Switch de valor, no entiendo por qué se envía n veces la
notificación auque cambiara el modelo.  
