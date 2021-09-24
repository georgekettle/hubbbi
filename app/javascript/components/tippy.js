// Will enables popover on elements...

// Use like so:
// <button data-tippy-content="Tooltip">Text</button>
// <button data-tippy-content="Another Tooltip">Text</button>

import tippy from 'tippy.js';
import 'tippy.js/dist/tippy.css'; // optional for styling
import 'tippy.js/animations/scale.css'; // animation effect
import 'tippy.js/themes/light-border.css';

const initTippy = () => {
  tippy('[data-tippy-content]', {
    animation: 'scale',
    theme: 'light-border',
  });
}

export { initTippy }
