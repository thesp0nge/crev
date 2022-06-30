# CrevID

The original documentation states this:

```
Default (and currently the only supported) identity type in crev. A
self-generated identity used to sign proofs.

Under the hood it's just a keypair, with the public key used as a public ID,
and the secret key stored locally and encrypted with a passphrase.
```

An idea can be creating a key pair using the username@crev and the keyID as
crevID on a adhoc keyring under crev config dir.

Crev bash implementation uses a GPG adhoc keyring stored in
$HOME/.local/share/crev/.crev.keyring. The users crev id is the 16 alphanumeric
characters public key fingerprint.

Subcommands for id command are:

* current: shows your current crev identifier also stored on disk.
    ```
    ❯ ls -la ~/.local/share/crev/.identity
    -rw------- 1 thesp0nge users 35 30 giu 11.10 /home/thesp0nge/.local/share/crev/.identity

    ```
* new: creates a new gpg pair of keys in the crev custom keyring.
* set-url: sets the upstream url for proof
* trust: adds an identifiier to the user trust list
* trusted: shows trusted identifiers
