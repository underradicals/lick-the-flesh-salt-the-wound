import type { Action1, TLocalName } from "../types";
import { select } from "../utils";

const LocalNames = {
  span: ifSpan,
  button: ifButton,
  svg: ifSvg
} satisfies TLocalName;

function ifSpan(target: HTMLElement): void {
  const element = target.parentElement as HTMLElement;
  const selector = element.dataset.target as string;
  return toggleColorThemeMenu(selector);
}

function ifButton(target: HTMLElement): void {
  const selector = target.dataset.target as string;
  return toggleColorThemeMenu(selector);
}

function ifSvg(target: HTMLElement): void {
  const element = target.parentElement?.parentElement as HTMLElement;
  const selector = element.dataset.target as string;
  return toggleColorThemeMenu(selector);
}

function SwitchOnLocalName<TLocalName extends Record<string, Action1>>
  (
    machine: TLocalName,
    localName: string
  ): Action1 {
  return machine[localName];
}

function toggleColorThemeMenu(selector: string): void {
  const element_target = select(selector);
  const chevron = document.querySelector(".chevron-entity") as HTMLSpanElement;
  if (!element_target.hasAttribute("open")) {
    element_target.setAttribute('open', '');
    chevron.style.transform = `rotate(${90}deg)`;
    return;
  }
  element_target.removeAttribute('open');
  chevron.style.transform = `rotate(${0}deg)`;
  return;
}

function ColorThemeClickEvent(event: Event): void {
  const target = event.target as HTMLElement;
  const func = SwitchOnLocalName(LocalNames, target.localName);
  return func(target);
}

function ChangeColorThemeEvent(event: Event) {
  const target = event.target as HTMLElement;
  const css_selector = target.dataset.target as string;
  const node = select(css_selector);
  node.dataset.theme = target.textContent?.toLowerCase();
  const theme = node.dataset.theme as string;
  localStorage.setItem('theme', theme);
  if (theme?.toLowerCase() === 'system') {
    document.querySelector('html')?.removeAttribute('data-theme');
  }
  toggleColorThemeMenu(`.${target.parentElement?.className}` as string);
}

function HandleAccessibilityNavigation(event: Event) {
  const eve = event as KeyboardEvent;
  if (eve.key === 'Enter') {
    const target = eve.target as HTMLElement;
    const css_selector = target.dataset.target as string;
    const node = select(css_selector);
    node.dataset.theme = target.textContent?.toLowerCase();
    const theme = node.dataset.theme as string;
    localStorage.setItem('theme', theme);
    if (theme?.toLowerCase() === 'system') {
      document.querySelector('html')?.removeAttribute('data-theme');
    }
    toggleColorThemeMenu(`.${target.parentElement?.className}` as string);
  }
}

function handleOutsideClickEvent(button_selector: string, menu_selector: string) {
  return (event: Event) => {
    const target = event.target as HTMLElement;
    const MenuItemsContainer = select(menu_selector);
    console.log(target.className);
    if (
      target.className === button_selector.replace(".", "") ||
      target.className === menu_selector.replace(".", "")) {
      return;
    }

    MenuItemsContainer?.removeAttribute("open");
  }
}

/**
 * @description This controls the toggle of the Theme Switch Component.
 * @module DropDownMenu
 * @param selector This is either the class name, id, or some other path that determines a 
 * point in the DOM. 
 * @summary This is broken into a FSM deterministically. Available nodes may vary determined by where the click occurred. For example if the Button {@type HTMLButtonElement} was clicked as opposed to a Span {@type HTMLSpanElement} we have to traverse the DOM in a different manner. 
 * 
 * There are also some caveats when using the pattern here. The Source Node (That is the node on which the event is initiated) holds a reference to the Target Nodes CSS Selector. The event is toggled by adding or removing `open` attribute from the Target Node.
 */
export default function ColorThemeSwitch(button_selector: string, menu_selector: string, animate: boolean = false): void {
  if (animate) {
    document.querySelector(button_selector)?.parentElement?.classList.add('animation');
  } else {
    document.querySelector(button_selector)?.parentElement?.classList.remove('animation');
  }
  const ColorThemeButton = select(button_selector);
  const MenuItemsContainer = ColorThemeButton.nextElementSibling;
  ColorThemeButton.addEventListener('click', ColorThemeClickEvent);
  MenuItemsContainer?.addEventListener("click", ChangeColorThemeEvent);
  MenuItemsContainer?.addEventListener('keyup', HandleAccessibilityNavigation);
  addEventListener('click', handleOutsideClickEvent(button_selector, menu_selector));
}