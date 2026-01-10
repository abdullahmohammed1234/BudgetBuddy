/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./views/**/*.{html,js,ejs}", "./public/**/*.js"],
  theme: {
    extend: {
      colors: {
        primary: '#1E1B4B',
        accent: '#22C55E',
        secondary: '#2DD4BF',
        text: '#64748B',
        background: '#F8FAFC',
        dark: '#0F172A',
      },
      fontFamily: {
        primary: ['Inter', 'sans-serif'],
        heading: ['Poppins', 'sans-serif'],
      },
    },
  },
  plugins: [],
}