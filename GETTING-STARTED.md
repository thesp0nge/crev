# Getting started

Securing the third party components ecosystem for a given open source project
is one of the most hard challenges of those days.
Given an application, its security posture is heavily affected by the security
of the connected third party libraries.

The basic idea behing Crev is to create a web of trust between code reviews and
people doing audits. When a user makes some audits that are notable, people
trust him and his work so other subsequent audits will be credited as well.

The application will have a list of security score given by the score of the
third pary libraries audits. Its score will be more consolidated based on the
reputation of the auditors and their work.

# Subcommands

config      Local configuration
id          Create an Id (own and of other users)
proof       Find a proof in the proof repo
repo        Proof Repository
trust       The fact of trusting a crev user is publicly recorded as a trust
            proof. This allows building a public network of trusted reviewers.  You can
            trust a user specifically by their CrevID
goto
open
publish
review
update      Reviews are stored in public git repositories of crev users. This
            command will automatically update known repositories. It's also possible to
            fetch them individually.
verify      As a user, your typical goal is verifying that all the dependencies
            of the current package are trustworthy and free of serious bugs and flaws.

## id - Creating a CrevID

You can also be a reviewer, and other people will be able to use your reviews.
You will need a public git repository to serve as your *proof repository*.
Customarily the repository should be called `crev-proofs`.

- GitHub users can just [fork a
  template](https://github.com/crev-dev/crev-proofs/fork) (same [for
  GitLab](https://gitlab.com/crev-dev/crev-proofs)).
- Other users can do it manually. **Note**: `cargo-crev` requires the master
  branch to already exist, so the repository you create has to contain at least
  one existing commit.

Then run `crev.sh id new` like this:

``` text
$ crev.sh id new --url https://github.com/YOUR-USERNAME/crev-proofs
https://github.com/YOUR-USERNAME/crev-proofs cloned to /home/YOUR-USERNAME/.config/crev/proofs/Sp87YXeDKUyh4jImm23bCp1Gr-6eNkMoQogWbftNobQ
CrevID will be protected by a passphrase.
There's no way to recover your CrevID if you forget your passphrase.
Enter new passphrase:
```

The command will ask you to encrypt your identity, and print out some encrypted
data to back up. Please copy that data and store it somewhere reliable.

You can generate and use multiple IDs, but one is generally enough. Check your
current `CrevID` like this:

``` text
$ crev.sh id current
2CxdPgo2cbKpAfaPmEjMXJnXa7pdQGBBeGsgXjBJHzA https://github.com/YOUR-USERNAME/crev-proofs
```

To push your changes (reviews, trust proofs) run:

``` bash
crev.sh publish
```
