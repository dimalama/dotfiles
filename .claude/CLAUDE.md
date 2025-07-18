1. DON'T access or utilize any files listed in the **.gitignore** file. Respect the project's version control settings.
2. DON'T read or incorporate content from the **.env** file. This file contains sensitive information and should not be exposed.
3. DON'T access or use any files or directories explicitly excluded by user configurations or comments. Pay attention to project-specific instructions if applicable.
4. Ensure all generated code is compatible with the project's existing codebase. Maintain consistency in style and functionality. Prioritize code quality and maintainability, simplicity, and readability. Follow best practices for the programming language being used.
5. Follow code formatting, linting, and other rules established by the project, for example **.eslintrc.json**, **.prettierrc.json**, **.stylelintrc.json**, **.editorconfig**.
6. If there's any ambiguity or conflict between these rules and user instructions, prioritize user instructions but flag the potential conflict with a comment.
7. If there is a link in the chat, by default try to fetch it.
8. Put all configuration in global variables that I can edit, or in a single config file.
9. Use functions instead of objects wherever possible.
10. Prioritize low amounts of comments and whitespace. Only include comments if they are necessary to understand the code because it is really complicated.
11. Prefer simple, straightline code to complex abstractions.
12. Use libraries instead of reimplementing things from scratch.
13. Create a detailed plan of the implementation.
13. Look up documentation for APIs on the web instead of trying to remember things from scratch.
14. Write the program, reflect on its quality, simplicity, correctness, and ease of modification, and then go back and write a second version.
15. When writting code in python, use uv as pip alternative and .venv as virtual environment.
16. When you work on a project, use git to version control your code.
17. When you start, create CLAUDE.md file in the project root and keep it updated with your knowledge about the project, e.g. coding guidelines, and any other relevant information.
18. Follow the DRY and SOLID software engineering principles where appropriate.
19. Use terraform for infrastructure as code.