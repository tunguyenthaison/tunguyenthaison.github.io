
const fnmap = {
  'toggle': 'toggle',
  'show': 'add',
  'hide': 'remove'
};

const collapse = (selector, cmd) => {
  const targets = Array.from(document.querySelectorAll(selector));
  targets.forEach(target => {
    target.classList[fnmap[cmd]]('show');
  });
};

// Handler that uses Bootstrap-style data attributes. Event delegation keeps
// buttons working even when an include is inserted after the script loads.
window.addEventListener('click', (event) => {
  const trigger = event.target.closest('[data-toggle="collapse"]');
  if (!trigger) return;

  const selector = trigger.getAttribute('data-target');
  if (!selector) return;

  collapse(selector, 'toggle');
  const expanded = Array.from(document.querySelectorAll(selector))
    .some(target => target.classList.contains('show'));
  trigger.setAttribute('aria-expanded', String(expanded));
}, false);

// plasTeX emits proof headings without a button element. Enhance those
// headings into keyboard-accessible disclosure controls while leaving the
// proof visible when JavaScript is unavailable.
const initializeTexProofs = () => {
  const proofs = Array.from(document.querySelectorAll('.tex-blog .proof_wrapper'));

  proofs.forEach((proof, index) => {
    if (proof.dataset.collapseReady === 'true') return;

    const heading = proof.querySelector('.proof_heading');
    const content = proof.querySelector('.proof_content');
    if (!heading || !content) return;

    const contentId = content.id || `${proof.id || `tex-proof-${index + 1}`}-content`;
    content.id = contentId;
    content.hidden = true;
    heading.setAttribute('role', 'button');
    heading.setAttribute('tabindex', '0');
    heading.setAttribute('aria-controls', contentId);
    heading.setAttribute('aria-expanded', 'false');
    proof.dataset.collapseReady = 'true';

    const toggleProof = () => {
      const shouldOpen = content.hidden;
      content.hidden = !shouldOpen;
      heading.setAttribute('aria-expanded', String(shouldOpen));
      proof.classList.toggle('is-open', shouldOpen);

      if (
        shouldOpen &&
        !content.querySelector('mjx-container') &&
        window.MathJax &&
        typeof window.MathJax.typesetPromise === 'function'
      ) {
        window.MathJax.typesetPromise([content]).catch(() => {});
      }
    };

    heading.addEventListener('click', toggleProof);
    heading.addEventListener('keydown', (event) => {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        toggleProof();
      }
    });
  });
};

initializeTexProofs();
