// Will enables popover on elements...

// Use like so:
// <button data-tippy-content="Tooltip">Text</button>
// <button data-tippy-content="Another Tooltip">Text</button>

import tippy from 'tippy.js';

const initTippy = () => {
  tippy('[data-tippy-content]', {
    animation: 'scale',
    theme: 'light-border',
  });
}

export { initTippy }
