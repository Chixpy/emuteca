---
layout: page
title: Notas varias
EmuVer: 0.8
---

Aquí hay alguna cosilla aleatoría sobre el programa y funcionamiento antes de ponerlo dónde le correspondería.

## Títulos, identificadores y claves de ordenación ##

Ficheros que contienen varios juegos y compilaciones:
  * Hay que diferenciar si realmente se trata de un HUB como tal o simplemente juegos puestos sin más. Si los juegos ni siquiera tienen un menú donde seleccionarlos y son pocos listarlos como tal. Separados por ' + ' (¿Posiblemente '; ' sea mejor?)
  * A Emuteca le interesan los juegos en sí, y si se encuentran en una compilación física pero cada juego es un archivo diferente serían la versión incluida en dicha compilación.
  * Si un fichero contiene varios juegos, los grupos contienen los juegos ordenados alfabéticamente mientras que el título del software puede representar el orden dentro del fichero (por ejemplo en cintas de cassete).
  
Títulos:
  * Título del juego... difícil ¿eh?
  * En caso de incongruencia elegir el título más completo con subtítulo.
  * Mantener nombres de compañía, creadores, etc. y similares al comienzo del título: Por ejemplo: "Disney's", "Hudson's", etc.
    * Sin embargo hay que diferenciar cosas como "Tecmo World Cup" o "Konami Tennis" que forman parte real del título del juego.
    * Aquí el truco sería si tienen apóstrofe o fórmulas similares como "Disney presents".
  * Respetar el formato de numeración usado.
  * En el lenguaje original y si hace falta con caracteres no latinos.
  * Subtítulos separados por ': '.
  
Identificador (sólo para grupos):
  * Con MAME usar el identificador propio del MAME. Además tienen el identificador de la ROM padre.
  * ***Título*** transliterado con carácteres latinos.
  * Se mantienen los nombres de compañía: "Disney's"
  * Sin artículos iniciales, en los subtítulos tampoco. Se quitan incluso si el título del juego contiene el nombre de una compañia.
  * Ejemplos:
    * "Disney's _The_ Lion King" → "Disney's Lion King"
  
Clave de ordenación:
  * ***Identificador*** con los número de partes normalizado a números arábigos.
  * Se quitan los nombres de compañías iniciales, como por ejemplo "Disney's"
  * Sustitución de caracteres en nombres de fichero no permitidos por Windows.
  * NO pueden terminar en punto '.', sustituirlo por '_'; Windows da algunos problemas si las carpetas terminan en punto '.'
  * ': ' → ' - '
  * '&' → ' and '
  
### Ejemplos ###
| Título | Identificador | Clave de ordenación |
| -- | -- | -- |
| The Emuteca Example | Emuteca Example | Emuteca Example |
| The Emuteca Example II: The Twist | Emuteca Example II: Twist | Emuteca Example 2: Twist |
| Disney's _The_ Lion King | Disney's Lion King | Lion King |

  
## MAME ##

Si se ejecuta a pantalla completa a veces no termina de salir programa, quedándose colgado sin más y con la pantalla en negro. Se ve el ratón y se puede interactuar con los elementos que debieran estar en pantalla pero es completamente a ciegas.

Como Emuteca está esperando a que termine MAME, no se puede interactuar con el programa.

En Win10 era posible, aunque muy difícil hacerlo, abrir el administrador de tareas y terminar la ejecución de MAME. En Win11, realmente lo veo imposible a no ser que se tengan dos pantallas.

Estoy pensando en ejecutar los emuladores en hilos aparte para poder interactuar con Emuteca cuando se está ejecutando un Emulador.