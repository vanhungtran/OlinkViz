# Contributing to OlinkViz

Thank you for considering contributing to `OlinkViz`! We welcome contributions
from the Olink proteomics and R bioinformatics community.

## How to Contribute

### 1. Report Bugs

Open an issue on [GitHub Issues](https://github.com/vanhungtran/OlinkViz/issues):

- Use a clear, descriptive title
- Include a minimal reproducible example (ideally using a built-in dataset)
- Describe expected vs. actual behavior
- Note your R version, OS, and package version (`packageVersion("OlinkViz")`)

### 2. Suggest Features

Propose enhancements via GitHub Issues:

- Explain the use case and why it would benefit the proteomics community
- Provide example workflows if possible
- Tag with "enhancement" label

### 3. Submit Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes with tests
4. Run `devtools::test()` to ensure all tests pass
5. Run `devtools::document()` to regenerate documentation
6. Commit and push, then submit a PR with a clear description

### 4. Improve Documentation

- Fix typos or clarify examples
- Add vignettes for advanced use cases
- Improve function documentation

## Development Guidelines

### Code Style

- Follow the [tidyverse style guide](https://style.tidyverse.org/)
- Use `snake_case` for function and variable names
- Use `ggplot2::` prefix for all ggplot2 function calls

### Data Conventions

- Functions expect long-format NPX data with `Assay`, `NPX`, and `SampleID`
  columns by default (configurable via parameters)
- Use `validate_npx()` for input checking in new plotting functions
- Use `to_wide()` and `to_long()` for format conversions

### Testing

- All new functionality must include testthat tests
- Tests should use built-in datasets where possible
- Run `devtools::test()` before submitting

### Documentation

- All exported functions must have complete roxygen2 documentation
- Include `@examples` with `\dontrun{}` for computation-heavy examples
- Regenerate docs with `devtools::document()`

### Package Dependencies

- Maintain the current dependency structure:
  - Core plotting functions use `ggplot2` explicitly
  - Visualization packages in Imports (pheatmap, umap, corrplot, RColorBrewer)
  - Interactive functionality in Imports (shiny, data.table, dplyr, tidyr)
  - Optional packages in Suggests (ggrepel, ggpubr, OlinkAnalyze)

## Code of Conduct

Please note that this project follows a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you agree to abide by its terms.
