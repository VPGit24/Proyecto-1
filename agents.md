# agents.md

## Proyecto: BA AIMood

### Descripción General
Una plataforma web interactiva que permite al usuario organizar su viaje por Argentina de forma sencilla, explorando actividades turísticas, gastronómicas y culturales. 

### Objetivo del Agente
El agente debe asistir al usuario en:

- Seleccionar una ciudad y su idioma preferido.
- Recomendar experiencias personalizadas en base a intereses.
- Explicar las diferencias entre categorías como "Tour", "Comer" y "Actividad Cultural".
- Sugerir itinerarios optimizados.
- Proveer contexto adicional sobre los lugares mostrados (historia, cultura, gastronomía, etc.).
- Conectar con servicios externos de reservas si está disponible.

---

### Intenciones del Usuario

| Intención                     | Ejemplo de Pregunta                                        | Acción del Agente                                 |
|------------------------------|------------------------------------------------------------|---------------------------------------------------|
| Explorar actividades         | "¿Qué puedo hacer en Córdoba?"                            | Mostrar actividades por categoría para Córdoba    |
| Recomendación personalizada  | "Quiero una experiencia gastronómica para esta noche"     | Sugerir lugares para comer según ciudad y hora    |
| Cambio de ciudad             | "Cambiá la ciudad a Mendoza"                              | Actualizar contexto de ciudad                     |
| Cambio de idioma             | "Poné el sitio en inglés"                                 | Cambiar el idioma de visualización                |
| Información adicional        | "Contame más sobre esta actividad cultural"               | Mostrar detalles históricos o culturales          |
| Crear itinerario             | "Armame un plan para 3 días en Buenos Aires"              | Crear un plan con tours, comidas y actividades    |

---

### Datos Clave del Contexto Visual

- **Nombre del Proyecto:** BA AIMood
- **Tópicos principales:**
  - 🧭 Tour
  - 🍽️ Comer
  - 🎭 Actividad Cultural
- **Categorías de ejemplo para Tours:** Historia y Cultura, Tango y Vida Nocturna, Naturaleza y Paseos al Aire Libre, Gastronomía y Vinos, Fútbol y Pasión Argentina y Fotografía.
- **Frase de bienvenida:** “Arma tu viaje fácilmente, visita increíbles lugares de Argentina y planea las mejores salidas.”

---

### Comportamiento del Agente

- Preguntar por la ciudad si no está definida.
- Ofrecer una categoría de inicio si el usuario no indica preferencias.
- Recordar selecciones anteriores dentro de la sesión (idioma, ciudad, intereses).
- Adaptar el lenguaje y tono según el idioma elegido por el usuario.

---

### Posibles Mejoras Futuras

- Integración con APIs de reservas.
- Modo offline con recomendaciones pre-cargadas.
- Integración de calendario para planificación detallada.
- Agente con voz (integración TTS/STT).

---

### Descripción Visual de la Interfaz (ui.png)

#### 1. Encabezado Superior
- **Logo**: Ícono con gradiente azul-violeta.
- **Nombre de la app**: "BA AIMood".
- **Menú Ciudad**: Permite seleccionar la ciudad de destino.
- **Menú Idioma**: Permite seleccionar el idioma de visualización.

#### 2. Sección Principal (Hero)
- **Fondo**: Degradado de azul a violeta con círculos translúcidos decorativos.
- **Título Central**: "BA AIMood".
- **Subtítulo**: "Arma tu viaje fácilmente, visita increíbles lugares de Argentina y planea las mejores salidas."

#### 3. Sección de Categorías
- **Título**: "Explora por Categoría".
- **Descripción**: "Descubre las mejores experiencias en Argentina, organizadas para ti."
- **Tarjetas de Categoría**:
  - 🧭 **Tour**: Actividades de recorridos por la ciudad.
  - 🍽️ **Comer**: Experiencias gastronómicas.
  - 🎭 **Actividad Cultural**: Eventos y experiencias culturales.