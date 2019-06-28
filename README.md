# TweetNaCl_binding

This is a binding in Ada and SPARK of the C crypto-library [TweetNaCl](http://tweetnacl.cr.yp.to/index.html) by Prof Daniel J. Bernstein et al.

## Low level binding

The package tweetnacl_h.ads is a low level binding used as an interface between C and Ada.

## High level binding

The package tweetnaclhl.ads and tweetnaclhl.adb is a higher level binding than tweetnacl_h.ads, which comply with the limitations enforced by SPARK. Thus one can use the SPARK tools for formal verification. For instance, they can check if the programs declared in tweetnaclhl.ads are used as they are meant to be, with the right arguments and in the right order.

## Description of the programs

### To encrypt and decrypt

Crypto_box encrypts and authenticates a message m using a nonce n (which should be generated by randombytes and used only for this message) and secret keys sk and pk (which must be generated by crypto_box_keypair). It returns the resulting ciphertext c. 

Crypto_box_open verifies and decrypts a  ciphertext c using the nonce n and public and secret keys sk and pk used to encrypt c in the first place. It returns the resulting plaintext m. It prints out "error crypto_box_open" if c fails the authentication.

Crypto_box_keypair randomly generates a secret key sk and the corresponding public key pk to be used with crypto_box and crypto_box_open.

### To sign and verify the signature

Crypto_sign signs a message m using the signer's secret key sk (which must be generated by crypto_sign_keypair). It returns the resulting signed message sm.

Crypto_sign_open verifies the signature in sm using the signer's public key pk (which must be generated by crypto_sign_keypair with the secret_key that was used to signed the message in the first place). It returns the initial message m. It prints out "error crypto_sign_open" if the signature fails the verification.

Crypto_sign_keypair generates a secret key sk and the corresponding public key pk to be used with crypto_sign and crypto_sign_open.

### Other programs

Randombytes can be used to randomly generate a Key or a Nonce.

The other programs declared in tweetnaclhl.ads are the basic components of these six main procedures. If you want to use these other programs in a different way than tweetnacl.c, then the pre- and post-conditions in tweetnaclhl.ads could be an hindrance. That could mean that what you are trying to do is unsafe, but if you want to keep trying you should consider calling directly the functions declared in the low-level binding tweetnacl_h.ads.

### Ghost functions

Ghost functions like isSigned always return 0, thus the Pre- and Post-conditions they are called in are always valid : they have no influence during the execution. They are only useful with the proof stage of formal verification, where they check if the right arguments are used in the right way. For instance a Nonce has to be only used once, or a message has to be signed before being encrypted and not the other way around, in order to prove that these Pre-conditions are always valid.

## Test

Test.adb uses the six main procedure of tweetnacl to generate two pairs of keys: one pair to sign and authentify, the other to encrypt and decrypt a message. Then it uses these keys to sign the message, encrypt it, decrypt it, check the signature and return the initial message.
