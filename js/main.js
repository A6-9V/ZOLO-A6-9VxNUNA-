/**
 * ZOLO-A6-9VxNUNA Website JavaScript
 * A6-9V Organization - 2025
 */

// DOM Ready
document.addEventListener('DOMContentLoaded', () => {
    initNavigation();
    initScrollEffects();
    initAnimations();
    initCopyButtons();
});

/**
 * Utility: Debounce function
 */
function debounce(func, wait = 100) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}

/**
 * Utility: Throttle function
 */
function throttle(func, limit = 100) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

/**
 * Navigation functionality
 */
function initNavigation() {
    const navToggle = document.querySelector('.nav-toggle');
    const navLinks = document.querySelector('.nav-links');
    // Performance: Cache the navbar element to avoid repeated DOM queries.
    // This query is now performed only once during initialization, making
    // subsequent smooth scroll clicks more efficient.
    const navbar = document.querySelector('.navbar');
    
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            navToggle.classList.toggle('active');
        });
        
        // Close menu on link click
        navLinks.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                navLinks.classList.remove('active');
                navToggle.classList.remove('active');
            });
        });
    }
    
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const target = document.querySelector(targetId);
            if (target && navbar) {
                e.preventDefault();
                const navHeight = navbar.offsetHeight;
                const targetPosition = target.offsetTop - navHeight - 20;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
}

/**
 * Scroll effects
 */
function initScrollEffects() {
    const navbar = document.querySelector('.navbar');

    // Performance: Throttle scroll events to prevent excessive function calls.
    // Toggling a class is more performant than changing styles directly,
    // as it allows the browser to optimize rendering.
    const handleScroll = () => {
        const currentScroll = window.pageYOffset;
        
        // Add/remove .scrolled class based on scroll position
        if (currentScroll > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    };

    window.addEventListener('scroll', throttle(handleScroll, 100));
}

/**
 * Intersection Observer for animations
 */
function initAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    // Observe elements
    const animateElements = document.querySelectorAll(
        '.feature-card, .system-card, .doc-card, .step, .arch-layer'
    );
    
    animateElements.forEach((el, index) => {
        // ⚡ Bolt Optimization: Use a class to set initial animation state.
        // This is more performant than setting inline styles directly, as it
        // avoids triggering unnecessary style recalculations by the browser.
        el.classList.add('animation-prepare');
        // ⚡ Bolt Optimization: Set a CSS custom property for the animation order.
        // This is more performant than setting `transitionDelay` directly, as it
        // offloads the animation timing to the CSS rendering engine.
        el.style.setProperty('--animation-order', index);
        observer.observe(el);
    });
    
}

/**
 * Copy to clipboard functionality
 */
function initCopyButtons() {
    const copyButtons = document.querySelectorAll('.copy-btn');

    const copyCode = (btn) => {
        const codeBlock = btn.closest('.code-block');
        const code = codeBlock.querySelector('code').textContent;

        navigator.clipboard.writeText(code).then(() => {
            // Show feedback
            const originalHTML = btn.innerHTML;
            btn.innerHTML = `<svg width="16" height="16"><use href="#check"></use></svg>`;
            btn.style.color = 'var(--primary)';

            setTimeout(() => {
                btn.innerHTML = originalHTML;
                btn.style.color = '';
            }, 2000);
        }).catch(err => {
            console.error('Failed to copy:', err);
        });
    };

    copyButtons.forEach(btn => {
        btn.addEventListener('click', () => copyCode(btn));
    });
}

/**
 * Terminal typing effect (optional enhancement)
 */
function typeWriter(element, text, speed = 50) {
    let i = 0;
    element.textContent = '';
    
    function type() {
        if (i < text.length) {
            element.textContent += text.charAt(i);
            i++;
            setTimeout(type, speed);
        }
    }
    
    type();
}

// Console branding
console.log(`
%c⚡ ZOLO-A6-9VxNUNA %c
AI-Powered Trading & Automation Platform
https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-

© 2025 A6-9V Organization
`, 'color: #00ff88; font-size: 20px; font-weight: bold;', 'color: #8b949e;');
