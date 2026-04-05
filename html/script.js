/* ============================================================
   PRESENTATION ENGINE — Vanilla JS
   ============================================================ */

(function () {
  'use strict';

  const slides = document.querySelectorAll('.slide');
  const totalSlides = slides.length;
  let currentSlide = 0;
  let isAnimating = false;

  // DOM refs
  const prevBtn = document.getElementById('btn-prev');
  const nextBtn = document.getElementById('btn-next');
  const fsBtn = document.getElementById('btn-fullscreen');
  const counter = document.getElementById('slide-counter');
  const progressBar = document.getElementById('progress-bar');

  /* ------ helpers ------ */
  function updateUI() {
    counter.textContent = `${currentSlide + 1} / ${totalSlides}`;
    prevBtn.disabled = currentSlide === 0;
    nextBtn.disabled = currentSlide === totalSlides - 1;
    progressBar.style.width = `${((currentSlide + 1) / totalSlides) * 100}%`;
  }

  function goTo(index, direction) {
    if (index < 0 || index >= totalSlides || index === currentSlide || isAnimating) return;
    isAnimating = true;

    const outSlide = slides[currentSlide];
    const inSlide = slides[index];

    // Direction-aware exit with scale + blur
    outSlide.classList.remove('active');
    outSlide.classList.remove('exit-left');
    if (direction === 'next') {
      outSlide.classList.add('exit-left');
    }
    outSlide.style.transform = direction === 'next' ? 'translateX(-60px) scale(0.98)' : 'translateX(60px) scale(0.98)';
    outSlide.style.opacity = '0';
    outSlide.style.filter = 'blur(2px)';

    // Prepare incoming slide
    inSlide.style.transform = direction === 'next' ? 'translateX(60px) scale(0.98)' : 'translateX(-60px) scale(0.98)';
    inSlide.style.opacity = '0';
    inSlide.style.filter = 'blur(2px)';

    // Small delay to allow CSS to register the start state
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        inSlide.classList.add('active');
        inSlide.style.transform = 'translateX(0) scale(1)';
        inSlide.style.opacity = '1';
        inSlide.style.filter = 'blur(0)';

        currentSlide = index;
        updateUI();

        setTimeout(() => {
          outSlide.classList.remove('exit-left');
          outSlide.style.transform = '';
          outSlide.style.opacity = '';
          outSlide.style.filter = '';
          inSlide.style.transform = '';
          inSlide.style.opacity = '';
          inSlide.style.filter = '';
          isAnimating = false;
        }, 600);
      });
    });
  }

  function next() { goTo(currentSlide + 1, 'next'); }
  function prev() { goTo(currentSlide - 1, 'prev'); }

  /* ------ fullscreen ------ */
  function toggleFullscreen() {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen().catch(() => {});
    } else {
      document.exitFullscreen();
    }
  }

  function updateFsIcon() {
    if (document.fullscreenElement) {
      fsBtn.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="4 14 4 20 10 20"/><polyline points="20 10 20 4 14 4"/><line x1="14" y1="10" x2="21" y2="3"/><line x1="3" y1="21" x2="10" y2="14"/></svg>';
    } else {
      fsBtn.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 3 21 3 21 9"/><polyline points="9 21 3 21 3 15"/><line x1="21" y1="3" x2="14" y2="10"/><line x1="3" y1="21" x2="10" y2="14"/></svg>';
    }
  }

  /* ------ keyboard ------ */
  function handleKeyboardNavigation(e) {
    if (e.ctrlKey || e.metaKey || e.altKey) return;

    const target = e.target;
    const tag = target && target.tagName;
    if (target && (target.isContentEditable || tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT')) {
      return;
    }

    switch (e.key) {
      case 'ArrowRight':
      case 'ArrowDown':
      case ' ':
      case 'Spacebar':
        e.preventDefault();
        next();
        break;
      case 'ArrowLeft':
      case 'ArrowUp':
        e.preventDefault();
        prev();
        break;
      case 'Home':
        e.preventDefault();
        goTo(0, 'prev');
        break;
      case 'End':
        e.preventDefault();
        goTo(totalSlides - 1, 'next');
        break;
      case 'f':
      case 'F':
        if (!e.ctrlKey && !e.metaKey) toggleFullscreen();
        break;
      case 'Escape':
        // handled by fullscreen API
        break;
    }
  }

  // Capture phase improves reliability in fullscreen across browsers/embeds.
  document.addEventListener('keydown', handleKeyboardNavigation, { capture: true });

  /* ------ touch / swipe ------ */
  let touchStartX = 0;
  let touchStartY = 0;
  document.addEventListener('touchstart', (e) => {
    touchStartX = e.changedTouches[0].screenX;
    touchStartY = e.changedTouches[0].screenY;
  }, { passive: true });

  document.addEventListener('touchend', (e) => {
    const dx = e.changedTouches[0].screenX - touchStartX;
    const dy = e.changedTouches[0].screenY - touchStartY;
    if (Math.abs(dx) > Math.abs(dy) && Math.abs(dx) > 50) {
      dx < 0 ? next() : prev();
    }
  }, { passive: true });

  /* ------ mouse wheel ------ */
  let wheelCooldown = false;
  document.addEventListener('wheel', (e) => {
    if (wheelCooldown) return;
    if (Math.abs(e.deltaY) < 30) return;
    wheelCooldown = true;
    if (e.deltaY > 0) next();
    else prev();
    setTimeout(() => { wheelCooldown = false; }, 800);
  }, { passive: true });

  /* ------ button listeners ------ */
  prevBtn.addEventListener('click', prev);
  nextBtn.addEventListener('click', next);
  fsBtn.addEventListener('click', toggleFullscreen);
  document.addEventListener('fullscreenchange', () => {
    updateFsIcon();

    // Defensive reset: avoids getting stuck in "isAnimating" after fullscreen toggles.
    isAnimating = false;
    slides.forEach((slide) => {
      slide.classList.remove('exit-left');
      slide.style.transform = '';
      slide.style.opacity = '';
      slide.style.filter = '';
    });
  });

  /* ------ init ------ */
  slides.forEach((s, i) => {
    if (i === 0) s.classList.add('active');
    else s.classList.remove('active');
  });
  updateUI();
  updateFsIcon();

})();
