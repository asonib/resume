# Resume - Aryan Burman

Professional LaTeX resume built with a clean, ATS-friendly template optimized for software engineering positions.

## 📄 About

This repository contains my professional resume in LaTeX format, designed to be:
- **ATS-Compatible**: Machine-readable format that passes Applicant Tracking Systems
- **Clean & Professional**: Modern single-column layout with clear section hierarchy
- **Easy to Customize**: Well-structured LaTeX code with reusable commands
- **Print-Ready**: Optimized for both digital viewing and physical printing

## 🚀 Quick Start

### Compile on Overleaf (Recommended)
1. Visit [Overleaf.com](https://www.overleaf.com)
2. Create a new project and upload `resume.tex`
3. Click "Recompile" to generate the PDF

### Compile Locally

**Prerequisites:**
- LaTeX distribution (TeX Live, MiKTeX, or MacTeX)
- Required packages: `latexsym`, `fullpage`, `titlesec`, `marvosym`, `color`, `verbatim`, `enumitem`, `hyperref`, `fancyhdr`, `babel`, `tabularx`, `fontawesome5`, `multicol`

**Compilation:**
```bash
# Using pdflatex
pdflatex resume.tex

# Or using latexmk (recommended)
latexmk -pdf resume.tex
```

## 📦 Structure

```
resume/
├── resume.tex          # Main LaTeX source file
├── resume.pdf          # Generated PDF (not tracked in git)
└── README.md           # This file
```

## 🛠️ Customization

The template includes custom commands for easy content updates:

- `\resumeSubheading{Company}{Date}{Role}{Location}` - Job positions
- `\resumeProjectHeading{Project Name}{Link}` - Project entries
- `\resumeItem{Description}` - Bullet points for experience/projects

**Key sections to customize:**
1. **Heading** (lines 75-83): Name, contact info, links
2. **Professional Summary** (lines 85-88): Brief career overview
3. **Technical Skills** (lines 90-102): Technologies and tools
4. **Experience** (lines 104-167): Work history
5. **Projects** (lines 169-193): Personal/side projects
6. **Education** (lines 195-204): Academic background
7. **Certifications** (lines 206-215): Credentials and achievements

## 📝 Tips for Editing

- Keep bullet points **action-oriented** with quantifiable results
- Use **strong verbs**: Architected, Engineered, Implemented, Optimized
- Include **metrics** wherever possible (e.g., "reduced latency by 60%")
- Maintain **consistent formatting** across all sections
- Keep the resume to **1-2 pages** maximum

## 📄 License

This resume template is based on Jake's Resume Template and is available under the MIT License. Feel free to use and modify for your own purposes.

## 🔗 Contact

- **Email**: arburman@outlook.com
- **LinkedIn**: [linkedin.com/in/aryan-burman](https://linkedin.com/in/aryan-burman)
- **GitHub**: [github.com/aryan-burman](https://github.com/aryan-burman)

---

**Note**: Remember to update the PDF in this repository after making changes to `resume.tex`. Add `resume.pdf` to `.gitignore` if you prefer not to track the compiled output.
