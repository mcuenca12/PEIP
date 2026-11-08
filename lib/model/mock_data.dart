import 'models.dart';

// el organizador del usuario de prueba, sus eventos se pueden editar
const int kOrganizadorPropio = 3;

final DateTime kHoy = DateTime(2026, 11, 5);

// hash falso, nada de bcrypt aquí
String hashSimulado(String password) => 'h\$${password.hashCode}';

class MockData {
  static const ciudades = [
    Ciudad(1, 'Bogotá'),
    Ciudad(2, 'Medellín'),
    Ciudad(3, 'Cali'),
    Ciudad(4, 'Barranquilla'),
    Ciudad(5, 'Bucaramanga'),
  ];

  // colores inventados, no tuvimos forma de sacarlos del Figma
  static const categorias = [
    Categoria(1, 'Technology & Data', 'tech', '#2563EB'),
    Categoria(2, 'Leadership', 'leadership', '#7C3AED'),
    Categoria(3, 'Medical Education', 'medical', '#DC2626'),
    Categoria(4, 'Research', 'research', '#0EA5E9'),
    Categoria(5, 'Agile & Delivery', 'agile', '#059669'),
    Categoria(6, 'Project Management', 'project', '#D97706'),
    Categoria(7, 'Innovation', 'innovation', '#DB2777'),
    Categoria(8, 'Entrepreneurship', 'entrepreneurship', '#EA580C'),
    Categoria(9, 'Public Speaking', 'speaking', '#4F46E5'),
    Categoria(10, 'Finance & Economics', 'finance', '#16A34A'),
    Categoria(11, 'Sustainability', 'sustainability', '#22C582'),
    Categoria(12, 'Workplace Wellbeing', 'wellbeing', '#0D9488'),
  ];

  static const etiquetas = [
    Etiqueta(1, 'team leadership'),
    Etiqueta(2, 'agile delivery'),
    Etiqueta(3, 'data analytics'),
    Etiqueta(4, 'clinical research'),
    Etiqueta(5, 'public speaking'),
    Etiqueta(6, 'change management'),
    Etiqueta(7, 'innovation'),
    Etiqueta(8, 'product management'),
    Etiqueta(9, 'statistics'),
    Etiqueta(10, 'sustainability'),
    Etiqueta(11, 'coaching'),
    Etiqueta(12, 'certification'),
  ];

  static const organizadores = [
    Organizador(1, 'Cámara de Comercio de Bogotá'),
    Organizador(2, 'Ruta N'),
    Organizador(3, 'Universidad Icesi'),
    Organizador(4, 'ACIS'),
    Organizador(5, 'Centro de Convenciones Ágora'),
  ];

  static const series = [SerieEvento(1, 'Data Analytics Bootcamp', 'semestral', 2, 1)];

  static final usuarios = <Usuario>[
    Usuario(
      idUsuario: 1,
      nombre: 'Ana Torres',
      email: 'ana.torres@icesi.edu.co',
      contrasenaHash: hashSimulado('123456'),
      idCiudad: 3,
      intereses: const {1, 2, 5},
      pesosEtiquetas: const {
        1: 0.86, // team leadership
        2: 0.74, // agile delivery
        3: 0.69, // data analytics
        4: 0.61, // clinical research
        5: 0.55, // public speaking
        6: 0.52, // change management
      },
    ),
  ];

  static final eventos = <Evento>[
    Evento(
      idEvento: 1,
      titulo: 'Congreso Nacional de Innovación 2025',
      eslogan: 'Tres días para repensar la industria',
      descripcion:
          'El congreso insignia del sector: conferencias magistrales, '
          'paneles de industria y una zona de innovación con casos reales.',
      fechaInicio: DateTime(2026, 11, 24),
      fechaFin: DateTime(2026, 11, 26),
      todoElDia: true,
      lugar: 'Centro de Convenciones Ágora',
      aforo: 1200,
      idCategoria: 1,
      idOrganizador: 1,
      idCiudad: 1,
      idEtiquetas: const [7, 8, 3],
    ),
    Evento(
      idEvento: 2,
      titulo: 'Cumbre de Transformación Digital',
      eslogan: 'De la estrategia a la ejecución',
      descripcion:
          'Casos de transformación digital en empresas colombianas, con '
          'foco en adopción y cambio organizacional.',
      fechaInicio: DateTime(2026, 12, 2, 8),
      fechaFin: DateTime(2026, 12, 3, 17),
      lugar: 'Corferias',
      aforo: 1800,
      idCategoria: 7,
      idOrganizador: 2,
      idCiudad: 1,
      idEtiquetas: const [7, 8],
    ),
    Evento(
      idEvento: 3,
      titulo: 'Seminario de Investigación Clínica',
      eslogan: 'Metodología y ética en investigación en salud',
      descripcion:
          'Seminario para profesionales de la salud sobre diseño de '
          'estudios clínicos y buenas prácticas de investigación.',
      fechaInicio: DateTime(2026, 11, 18, 8),
      fechaFin: DateTime(2026, 11, 18, 17),
      lugar: 'Hotel Tequendama',
      aforo: 300,
      idCategoria: 3,
      idOrganizador: 1,
      idCiudad: 1,
      idEtiquetas: const [4, 12],
    ),
    Evento(
      idEvento: 4,
      titulo: 'Foro de Bienestar Laboral',
      eslogan: 'Equipos sanos, resultados sostenibles',
      descripcion:
          'Foro sobre salud mental, carga laboral y políticas de bienestar '
          'en el trabajo, con casos de empresas de la región.',
      fechaInicio: DateTime(2026, 11, 20, 9),
      fechaFin: DateTime(2026, 11, 20, 16),
      lugar: 'Cámara de Comercio de Bogotá',
      estado: 'borrador',
      aforo: 150,
      idCategoria: 12,
      idOrganizador: kOrganizadorPropio,
      idCiudad: 1,
      idEtiquetas: const [6, 11],
    ),
    Evento(
      idEvento: 5,
      titulo: 'Scrum for Teams Workshop',
      eslogan: 'Agilidad práctica para equipos reales',
      descripcion:
          'Taller intensivo de Scrum con dinámicas de equipo y un caso de '
          'aplicación guiado de principio a fin.',
      fechaInicio: DateTime(2026, 11, 28, 8),
      fechaFin: DateTime(2026, 11, 28, 17),
      lugar: 'Universidad Icesi',
      aforo: 40,
      idCategoria: 5,
      idOrganizador: kOrganizadorPropio,
      idCiudad: 3,
      idEtiquetas: const [2, 11],
    ),
    Evento(
      idEvento: 6,
      titulo: 'Data Analytics Bootcamp — Cohorte Septiembre',
      eslogan: 'Edición anterior de la cohorte',
      descripcion:
          'De datos crudos a decisiones: limpieza, análisis exploratorio y '
          'visualización, con proyecto final por equipos.',
      fechaInicio: DateTime(2026, 9, 14, 8),
      fechaFin: DateTime(2026, 9, 16, 17),
      lugar: 'Ruta N',
      aforo: 60,
      idCategoria: 1,
      idOrganizador: 2,
      idCiudad: 2,
      idSerie: 1,
      idEtiquetas: const [3, 9],
    ),
    Evento(
      idEvento: 7,
      titulo: 'Data Analytics Bootcamp — Cohorte Noviembre',
      eslogan: 'Nueva cohorte, mismo formato intensivo',
      descripcion:
          'Nueva edición del bootcamp: limpieza de datos, análisis '
          'exploratorio y visualización, con proyecto final por equipos.',
      fechaInicio: DateTime(2026, 11, 30, 8),
      fechaFin: DateTime(2026, 12, 2, 17),
      lugar: 'Ruta N',
      aforo: 60,
      idCategoria: 1,
      idOrganizador: 2,
      idCiudad: 2,
      idSerie: 1,
      idEventoAnterior: 6,
      idEtiquetas: const [3, 9],
    ),
    Evento(
      idEvento: 8,
      titulo: 'Open Lecture: Ethics in AI',
      eslogan: 'Una hora para pensar antes de programar',
      descripcion:
          'Charla abierta sobre los dilemas éticos de la inteligencia '
          'artificial aplicada, con espacio de preguntas.',
      fechaInicio: DateTime(2026, 11, 17, 18),
      fechaFin: DateTime(2026, 11, 17, 19),
      lugar: 'Universidad de los Andes',
      aforo: 80,
      idCategoria: 4,
      idOrganizador: 4,
      idCiudad: 1,
      idEtiquetas: const [7, 9],
    ),
    Evento(
      idEvento: 9,
      titulo: 'Product Leadership Meetup',
      eslogan: 'Product managers compartiendo lo que funciona',
      descripcion:
          'Meetup informal de liderazgo de producto: dos charlas cortas y '
          'networking entre profesionales del gremio.',
      fechaInicio: DateTime(2026, 11, 21, 18),
      fechaFin: DateTime(2026, 11, 21, 20),
      lugar: 'Ruta N',
      aforo: 60,
      idCategoria: 2,
      idOrganizador: 2,
      idCiudad: 2,
      idEtiquetas: const [1, 8],
    ),
    Evento(
      idEvento: 10,
      titulo: 'Agile Leadership Workshop',
      eslogan: 'Liderar equipos ágiles sin perder el rumbo',
      descripcion:
          'Taller sobre liderazgo de equipos ágiles: delegación, manejo de '
          'conflicto y gestión del cambio en entornos de entrega continua.',
      fechaInicio: DateTime(2026, 12, 4, 8),
      fechaFin: DateTime(2026, 12, 4, 17),
      lugar: 'Cámara de Comercio de Bogotá',
      aforo: 50,
      idCategoria: 2,
      idOrganizador: 1,
      idCiudad: 1,
      idEtiquetas: const [1, 2, 6],
    ),
    Evento(
      idEvento: 11,
      titulo: 'Coaching for Team Leads',
      eslogan: 'Herramientas de coaching para líderes de equipo',
      descripcion:
          'Sesión práctica de coaching aplicado a la gestión de personas, '
          'pensada para líderes de equipos pequeños y medianos.',
      fechaInicio: DateTime(2026, 12, 9, 8),
      fechaFin: DateTime(2026, 12, 9, 13),
      lugar: 'Universidad Icesi',
      aforo: 35,
      idCategoria: 2,
      idOrganizador: kOrganizadorPropio,
      idCiudad: 3,
      idEtiquetas: const [1, 11],
    ),
    Evento(
      idEvento: 12,
      titulo: 'Advanced Statistics Seminar',
      eslogan: 'Estadística aplicada para investigadores',
      descripcion:
          'Seminario de estadística avanzada orientado a investigadores: '
          'modelos, supuestos y errores comunes de interpretación.',
      fechaInicio: DateTime(2026, 11, 14, 8),
      fechaFin: DateTime(2026, 11, 14, 17),
      lugar: 'Universidad Nacional',
      aforo: 100,
      idCategoria: 4,
      idOrganizador: 4,
      idCiudad: 1,
      idEtiquetas: const [9, 3],
    ),
    Evento(
      idEvento: 13,
      titulo: 'Research Methods Masterclass',
      eslogan: 'Diseño de investigación de principio a fin',
      descripcion:
          'Masterclass sobre diseño metodológico, recolección de datos y '
          'análisis para proyectos de investigación aplicada.',
      fechaInicio: DateTime(2026, 12, 6, 8),
      fechaFin: DateTime(2026, 12, 6, 17),
      lugar: 'Pontificia U. Javeriana',
      aforo: 70,
      idCategoria: 4,
      idOrganizador: 4,
      idCiudad: 1,
      idEtiquetas: const [9, 12],
    ),
  ];

  static const tiposEntrada = <TipoEntrada>[
    TipoEntrada(
      idEntrada: 1,
      nombre: 'General Access',
      precio: 85000,
      beneficios: 'Acceso a conferencias y zona de innovación',
      idEvento: 1,
    ),
    TipoEntrada(
      idEntrada: 2,
      nombre: 'Professional',
      precio: 180000,
      beneficios: 'Incluye talleres y almuerzo los tres días',
      idEvento: 1,
    ),
    TipoEntrada(
      idEntrada: 3,
      nombre: 'Corporate',
      precio: 320000,
      beneficios: 'Cupo para equipo de hasta 3 personas y sesión privada',
      idEvento: 1,
    ),
    TipoEntrada(
      idEntrada: 4,
      nombre: 'General Access',
      precio: 120000,
      beneficios: 'Acceso a todas las charlas',
      idEvento: 2,
    ),
    TipoEntrada(
      idEntrada: 5,
      nombre: 'Professional',
      precio: 220000,
      beneficios: 'Incluye los talleres prácticos',
      idEvento: 2,
    ),
    TipoEntrada(idEntrada: 6, nombre: 'General Access', precio: 95000, idEvento: 3),
    TipoEntrada(idEntrada: 7, nombre: 'General Access', precio: 60000, idEvento: 4),
    TipoEntrada(
      idEntrada: 8,
      nombre: 'General Access',
      precio: 150000,
      beneficios: 'Materiales incluidos',
      idEvento: 5,
    ),
    TipoEntrada(idEntrada: 9, nombre: 'General Access', precio: 190000, idEvento: 6),
    TipoEntrada(idEntrada: 10, nombre: 'General Access', precio: 210000, idEvento: 7),
    TipoEntrada(
      idEntrada: 11,
      nombre: 'Professional',
      precio: 350000,
      beneficios: 'Incluye mentoría individual post-bootcamp',
      idEvento: 7,
    ),
    TipoEntrada(idEntrada: 12, nombre: 'Entrada libre', precio: 0, idEvento: 8),
    TipoEntrada(idEntrada: 13, nombre: 'Entrada libre', precio: 0, idEvento: 9),
    TipoEntrada(idEntrada: 14, nombre: 'General Access', precio: 140000, idEvento: 10),
    TipoEntrada(idEntrada: 15, nombre: 'General Access', precio: 160000, idEvento: 11),
    TipoEntrada(idEntrada: 16, nombre: 'General Access', precio: 130000, idEvento: 12),
    TipoEntrada(idEntrada: 17, nombre: 'General Access', precio: 145000, idEvento: 13),
  ];

  static final reservas = <Reserva>[
    Reserva(
      idReserva: 1,
      cantidad: 1,
      codigoQr: 'PEIP-DATA-SEP-0001',
      fechaReserva: DateTime(2026, 9, 1, 10),
      fechaUso: DateTime(2026, 9, 14, 8, 10),
      idUsuario: 1,
      idEntrada: 9,
    ),
    Reserva(
      idReserva: 2,
      cantidad: 2,
      codigoQr: 'PEIP-AGILE-DIC-0002',
      fechaReserva: DateTime(2026, 11, 5, 10),
      idUsuario: 1,
      idEntrada: 14,
    ),
  ];

  static final guardados = <EventoGuardado>[
    EventoGuardado(1, 11, DateTime(2026, 11, 2, 9)),
    EventoGuardado(1, 12, DateTime(2026, 11, 3, 14)),
    EventoGuardado(1, 7, DateTime(2026, 11, 4, 20)),
  ];

  static final busquedas = <BusquedaReciente>[
    BusquedaReciente(1, 'agile', DateTime(2026, 11, 3, 11), 1),
    BusquedaReciente(2, 'estadística', DateTime(2026, 11, 4, 19), 1),
  ];
}
