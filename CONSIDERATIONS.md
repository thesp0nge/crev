# Considerations on about Crev

Collaborative code review is a must have for a secure open source ecosystem.
Security audits for OSS packages must be public and shared along the community.

Crev introduced a proposal for doing this and an implementation for rust, since
main developers use that programming language.

For my taste framework specifications and implementation must be decoupled. A
collaborative code review framework should be described in full in an ad hoc
document with all possible command and subcommands.

The framework should describe also file formats, which kind of information you
should enter and the conventions to use.

Severity indicators, in example, should be formalized either in terms of naming
convention ("high", "medium", "low") and in terms of formal description of
every possible value.

Adding a grammar, for files you want to create using a collaborative code
review framework, let people free to implement it, without the danger of
misunderstanding or confusion.

Crev approach is focused on rust and some documentation is spread in rust
respository, mixed in with sources. This makes the framework hard to
understand.

A framework like this is heavily based on human interaction and workflows. For
such a reason, documenting by example a real case code review information
exchange or how a web of trust network is build and maintained, it must be
done.

The idea of having the crev framework implemented in every programming language
dependency manager can be good from the UX point of view, however it requires
that a lot of code must be rewritten several times. This can be avoided
implementing it as a shell script, however this is a very minor issue.

Another key point is that we don't have to re-invent th wheel when dealing on
about signing proofs. Let's break custom algo and use GPG public keys. There is
the possibility to use a custom keyring, so there's no the drawback of clashing
the keys you use to sign emails or files.

## A collaborative code review framework must have

* Describe how an user identify itself among the developers network. There must
  be a clear description on how to create an identifier and how the identifier
  is represented (e.g. 16 alphanumerical characters).
* Describe the file format for the web of trust file and for the proofs.
* Describe how data is exchanged and where it is stored locally (plus: keep an
  eye on how to configure file permissions)
* A lot of examples

## Future improvements

* Redesign the framework and make a pull request to the original project
* Implement a python code that integrates the collaborative code review framework in [OBS](https://openbuildservice.org/)
