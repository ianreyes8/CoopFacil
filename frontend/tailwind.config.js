/** Configuración de Tailwind: las clases se leen de las páginas, el código de las páginas y los scripts. */
module.exports = {
  darkMode: 'class',
  content: [
    '../CoopFacil/Pages/**/*.cshtml',
    '../CoopFacil/Pages/**/*.cs',
    '../CoopFacil/Compat/**/*.cs',
    '../CoopFacil/Helpers/**/*.cs',
    '../CoopFacil/wwwroot/Js/**/*.js'
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
