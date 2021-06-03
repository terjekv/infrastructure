# Dynamic EESSI infrastructure

To create a new dynamic node, log in to login.eessi-infra.org, set your AWS_SECRET_ACCESS_KEY and your AWS_ACCESS_KEY_ID, and then use `eessi-dynamic` as such:

```
eessi-dynamic --create-node aarch64:large \
    --node-name terjekv-tmp \
    --node-description '[TK] Mesa-testing for 2021.03' \
    --node-issuer terjekv \
    --node-user-slack terjekv
```

This will create a host with the DNS name `terjekv-tmp.dynamic.eessi-infra.org` to which the EESSI staff has access.

`--node-issuer` and `--node-user-slack` is intended for future bookkeeping.

# Granting external users access to a node

To grant access to an external user, based on their github SSH keys, then do:

```
eessi-grant-access github-user-name terjekv-tmp
```

Note that the external user will have access as the user `eessi`. Creating a personal account is (currently) not supported.

## Listing existing dynamic hosts

```
eessi-dynamic --list-nodes
```

## Terminating an existing hosts

```
eessi-dynamic --kill terjekv-tmp
```


## Caveats

Note that `--node-description` is what is set as "Name" in the AWS console. `--node-name` is the hostname (and thus DNS name) for the node. This is not ideal.