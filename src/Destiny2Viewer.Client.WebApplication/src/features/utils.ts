export const select = (selector: string) => document.querySelector(selector) as HTMLElement;


export function initializeTheme() {
  const currentTheme = localStorage.getItem('theme');
  if (currentTheme === undefined || currentTheme === null) {
    localStorage.setItem('theme', 'dark');
  }
  if (currentTheme === 'system') {
    document.documentElement.removeAttribute('data-theme');
    return;
  }

  document.documentElement.setAttribute('data-theme', localStorage.getItem('theme') as string)
}


