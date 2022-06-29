# CrevID

The original documentation states this:

```
Default (and currently the only supported) identity type in crev. A
self-generated identity used to sign proofs.

Under the hood it's just a keypair, with the public key used as a public ID,
and the secret key stored locally and encrypted with a passphrase.
```

An idea can be creating a key pair using the username@crev and the keyID as crevID on a adhoc keyring under crev config dir
