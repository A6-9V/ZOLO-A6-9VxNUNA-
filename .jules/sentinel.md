## 2024-07-25 - Initial Security Enhancement: Tabnabbing Prevention & Security Headers

**Vulnerability:** The `index.html` file contained several external links using `target="_blank"` without `rel="noopener noreferrer"`. This creates a "tabnabbing" vulnerability, where the newly opened page can access the original page's `window.opener` object and potentially redirect it to a malicious site. The application was also missing the `X-Content-Type-Options` header, which could allow browsers to incorrectly interpret file types.

**Learning:** Even static sites with no user input can have security vulnerabilities. It's crucial to follow best practices for all web development, including securing external links and adding appropriate security headers.

**Prevention:** All future external links using `target="_blank"` must include `rel="noopener noreferrer"` to sever the connection between the parent and child windows. The `X-Content-Type-Options: nosniff` header should be included to prevent MIME-sniffing attacks.
