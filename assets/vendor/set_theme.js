function setTheme(theme) {
  const rootDocument = document.documentElement;
  if (theme === 'dark') {
    rootDocument.classList.add('dark');
  } else {
    rootDocument.classList.remove('dark');
  }
  localStorage.setItem('cascade-theme', theme)
};

function getTheme() {
  return localStorage.getItem('cascade-theme') ||
    (window.matchMedia('(prefers-color-scheme: dark)').matches
      ? 'dark'
      : 'light');
};

function toggleTheme() {
  console.log('toggleTheme');
  const theme = getTheme();
  setTheme(theme === 'dark' ? 'light' : 'dark');
}

const ToggleThemeHook = {
  mounted() {
    setTheme(getTheme());
    this.el.addEventListener('click', toggleTheme);
  }
};

export default ToggleThemeHook;
