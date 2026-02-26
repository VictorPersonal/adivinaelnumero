#  Adivina el Número

El programa clonado de github se le hicieron ajustes en su aspecto visual, con el color y estructura de los mensajes para el usuario, dependiendo del modo, cambia el rango de números en el juego de adivinanza. Brinda varios intentos al usuario y una barra de colores que disminuye el nivel del color a medida que los intentos aumentan. Muestra al usuario los números ingresados en los intentos anteriores. Sin embargo, en uno de las versiones (NO ACTUAL) involucra la pista de NÚMERO PAR O IMPAR.

---

#  Paso 4 – Preguntas y Respuestas

---

## 1 ¿Qué hace la función `main` y por qué es importante?

La función `main()` es el **punto de entrada de la aplicación Flutter**.  

Es la primera función que se ejecuta cuando inicia el programa y permite que la aplicación se cargue y se muestre en pantalla mediante `runApp()`.

Sin `main()`, la aplicación no podría ejecutarse.

---

## 2 ¿Cuál es la diferencia entre `MyApp` (StatelessWidget) y `MyHomePage` (StatefulWidget)?

**MyApp (StatelessWidget)**  
- No cambia su estado.  
- No necesita actualizarse dinámicamente.  
- Solo define la estructura general de la aplicación.

**MyHomePage (StatefulWidget)**  
- Sí cambia su estado.  
- Necesita actualizarse constantemente.  
- Maneja variables del juego como:
  - Número secreto  
  - Intentos restantes  
  - Mensajes  
  - Animaciones  

En resumen:  
 *StatelessWidget no cambia*  
 *StatefulWidget sí cambia durante la ejecución*

---

## 3 ¿Qué papel juega `setState` en `_iniciarJuego` y `_verificarAdivinanza`?

`setState()` permite **actualizar la pantalla cuando cambian las variables del juego**.

Por ejemplo:

- Número secreto (`_numeroSecreto`)
- Juego terminado (`_juegoTerminado`)
- Color del mensaje (`_colorMensaje`)
- Intentos restantes

Cada vez que se modifica una variable dentro de `setState()`, la interfaz se reconstruye automáticamente para reflejar los cambios.

Sin `setState()`, la pantalla no se actualizaría.

---

## 4 ¿Cómo funciona la validación de entrada en `_verificarAdivinanza`?

La validación ocurre en tres pasos:

**4.1** Se verifica que el campo de texto no esté vacío.  

**4.2** Se convierte el texto ingresado en número.  
Si no se puede convertir, devuelve `null` para evitar errores en la aplicación.

**4.3** Se verifica que el número esté dentro del rango permitido.

Esto evita que el usuario ingrese datos inválidos y protege la aplicación de fallos.

---

## 5 ¿Qué propósito tiene `TextEditingController` y por qué se debe liberar en `dispose`?

`TextEditingController` permite:

- Leer el texto que el usuario escribe.
- Modificar el texto.
- Limpiar el campo de entrada.

Se debe liberar en `dispose()` porque:

- Evita consumo innecesario de memoria.
- Libera recursos cuando el widget deja de usarse.
- Previene posibles errores o fugas de memoria.

Es una buena práctica en Flutter.

---

## 6 ¿Cómo se organiza la interfaz usando `Column` y qué otros widgets de layout se utilizan?

La estructura general de la interfaz es:
Scaffold
└── Container
    └── SafeArea
        └── Center
            └── SingleChildScrollView
                └── FadeTransition
                    └── SlideTransition
                        └── Column

Column organiza los elementos verticalmente. No obstante podemos ver otros widgets como:

Row → organiza horizontalmente (icono + texto).

SizedBox → espacio entre elementos.

Container → estilos y decoración.

Stack → superposición de widgets.

Center → centrar contenido.

SafeArea → evita zonas del sistema.

SingleChildScrollView → permite scroll

---

## 7. **Identifica los Tipos de Widgets**

| Categoría | Widgets Clave | Línea (aprox.) | Función |
|-----------|---------------|----------------|---------|
| **Layout** | `Column`, `Row`, `Stack`, `Container`, `Center`, `SingleChildScrollView`, `Padding` | 153, 185, 213, 149, 141, 141, 153 | Organizan y posicionan los elementos en pantalla. |
| **Interacción** | `TextField`, `ElevatedButton`, `OutlinedButton`, `IconButton` | 224, 258, 301, 239 | Permiten al usuario ingresar datos y pulsar botones. |
| **Animación** | `FadeTransition`, `SlideTransition`, `TweenAnimationBuilder`, `AnimationController` | 147, 148, 209, 53 | Dan vida a la interfaz con efectos visuales. |
| **Decoración** | `BoxDecoration`, `LinearGradient`, `BoxShadow` | 130, 132, 164 | Aplican colores, sombras y bordes para un diseño atractivo. |
| **Feedback** | `SnackBar`, `Text` | 115, 167 | Muestran mensajes al usuario (errores, resultados, pistas). |

---
