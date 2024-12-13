# Add Or Update

_Commands that ensure the existence of a text fragment in a file._

Text fragments can be single lines, or as a specialization `ASSIGNEE=VALUE` lines, or whole blocks of text.

### Dependencies

* Bash, GNU `sed`
* [inkarkat/memoizers](https://github.com/inkarkat/memoizers) for the `containedOr...` commands
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)

### Installation

* The `./bin` subdirectory is supposed to be added to `PATH`.
