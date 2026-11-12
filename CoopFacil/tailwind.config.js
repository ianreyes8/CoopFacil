/** Configuración de Tailwind CSS. Tras cambiar clases en las páginas, ejecuta: npm run css */
module.exports = {
  darkMode: 'class',
  content: [
    './Pages/**/*.cshtml',
    './Pages/**/*.cs',
    './Helpers/**/*.cs',
    './wwwroot/Js/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'ui-sans-serif', 'system-ui', '-apple-system', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'sans-serif']
      },
      colors: {
        coop: {
          darkBg: '#0B1A30',
          darkCard: '#0F233D',
          emerald: '#10B981',
          blue: '#3B82F6'
        }
      }
    }
  }
};
