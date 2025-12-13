// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Add active class to current navigation item
function normalizePath(path) {
    // Handle null/undefined
    if (!path) return 'index.html';
    
    // Remove query string and hash
    path = path.split('?')[0].split('#')[0];
    
    // If path is '/' or empty, return 'index.html'
    if (path === '/' || path === '') return 'index.html';
    
    // If path ends with '/', remove it and get last segment
    if (path.endsWith('/')) {
        path = path.slice(0, -1);
    }
    
    // Get last segment
    const lastSegment = path.split('/').pop();
    return lastSegment === '' ? 'index.html' : lastSegment;
}

const currentLocation = normalizePath(location.pathname);
const navLinks = document.querySelectorAll('.nav-links a');

navLinks.forEach(link => {
    const linkHref = normalizePath(link.getAttribute('href'));
    if (linkHref === currentLocation) {
        link.classList.add('active');
    } else {
        link.classList.remove('active');
    }
});

// Fade-in animation on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe feature cards
document.addEventListener('DOMContentLoaded', () => {
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });
});

// Mobile menu toggle (future enhancement)
// This can be expanded if a hamburger menu is needed for mobile devices

// Contact form handler
const contactForm = document.getElementById('contactForm');
if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
        e.preventDefault();
        alert('Thank you for your message! This is a demo form. In a production environment, this would send your message to our team.');
        this.reset();
    });
}
