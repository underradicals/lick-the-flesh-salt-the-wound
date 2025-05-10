import ColorThemeSwitch from './features/DropDownMenu/DropDownMenu';
import { initializeTheme } from './features/utils';
import './style.scss'

export function OnLoad() {
  initializeTheme();
}

addEventListener('DOMContentLoaded', OnLoad);

ColorThemeSwitch(".drop-down-menu-button", ".drop-down-menu", true);